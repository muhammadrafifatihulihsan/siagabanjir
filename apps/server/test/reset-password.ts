import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { withBusinessTransaction } from '../src/db/pool.js';

export async function verifyResetPassword(app: FastifyInstance, pool: Pool) {
  const email = `${randomUUID()}@example.invalid`;
  const initialPassword = 'sandi awal reset test 123';
  const signupResponse = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/signup',
    headers: { 'idempotency-key': randomUUID() },
    payload: {
      displayName: 'Warga Reset',
      email,
      password: initialPassword,
    },
  });
  assert.equal(signupResponse.statusCode, 201);
  const signupData = signupResponse.json<{
    data: { account: { id: string }; recoveryCode: string };
  }>().data;

  try {
    // Login to have an active session
    const loginResponse = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/login',
      headers: { 'idempotency-key': randomUUID() },
      payload: {
        email,
        password: initialPassword,
        client: 'ANDROID',
      },
    });
    assert.equal(loginResponse.statusCode, 200);
    const activeSession = loginResponse.json<{
      data: { accessToken: string };
    }>().data;

    // Missing or bad idempotency key
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/reset-password',
          payload: {
            email,
            code: signupData.recoveryCode,
            newPassword: 'sandi baru reset 123',
          },
        })
      ).statusCode,
      400,
    );

    // Short new password (< 12)
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/reset-password',
          headers: { 'idempotency-key': randomUUID() },
          payload: {
            email,
            code: signupData.recoveryCode,
            newPassword: 'short',
          },
        })
      ).statusCode,
      422,
    );

    // Wrong email
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/reset-password',
          headers: { 'idempotency-key': randomUUID() },
          payload: {
            email: `${randomUUID()}@example.invalid`,
            code: signupData.recoveryCode,
            newPassword: 'sandi baru reset 123',
          },
        })
      ).statusCode,
      401,
    );

    // Wrong recovery code
    const wrongCode = 'B'.repeat(32);
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/reset-password',
          headers: { 'idempotency-key': randomUUID() },
          payload: {
            email,
            code: wrongCode,
            newPassword: 'sandi baru reset 123',
          },
        })
      ).statusCode,
      401,
    );

    // Valid reset password
    const resetKey = randomUUID();
    const newPassword1 = 'sandi baru reset sukses 123';
    const resetResponse = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/reset-password',
      headers: { 'idempotency-key': resetKey },
      payload: {
        email,
        code: signupData.recoveryCode,
        newPassword: newPassword1,
      },
    });
    assert.equal(resetResponse.statusCode, 200, resetResponse.body);
    const resetData = resetResponse.json<{
      data: { recoveryCode: string };
    }>().data;
    assert.match(resetData.recoveryCode, /^[A-Z2-7]{32}$/);
    assert.notEqual(resetData.recoveryCode, signupData.recoveryCode);

    // Replay reset password returns 409 RESULT_ALREADY_COMMITTED
    const resetReplay = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/reset-password',
      headers: { 'idempotency-key': resetKey },
      payload: {
        email,
        code: signupData.recoveryCode,
        newPassword: newPassword1,
      },
    });
    assert.equal(resetReplay.statusCode, 409);
    assert.equal(
      resetReplay.json<{ code: string }>().code,
      'RESULT_ALREADY_COMMITTED',
    );

    // Using old recovery code again fails
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/reset-password',
          headers: { 'idempotency-key': randomUUID() },
          payload: {
            email,
            code: signupData.recoveryCode,
            newPassword: 'sandi ketiga lagi 123',
          },
        })
      ).statusCode,
      401,
    );

    // Previous active session is invalidated
    assert.equal(
      (
        await app.inject({
          url: '/api/v1/me',
          headers: { authorization: `Bearer ${activeSession.accessToken}` },
        })
      ).statusCode,
      401,
    );

    // Old password fails to login
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/auth/login',
          headers: { 'idempotency-key': randomUUID() },
          payload: { email, password: initialPassword, client: 'ANDROID' },
        })
      ).statusCode,
      401,
    );

    // New password logs in successfully
    const loginSuccess = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/login',
      headers: { 'idempotency-key': randomUUID() },
      payload: { email, password: newPassword1, client: 'ANDROID' },
    });
    assert.equal(loginSuccess.statusCode, 200);

    // Second reset with newly issued recovery code works
    const newPassword2 = 'sandi keempat sukses 123';
    const secondReset = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/reset-password',
      headers: { 'idempotency-key': randomUUID() },
      payload: {
        email,
        code: resetData.recoveryCode,
        newPassword: newPassword2,
      },
    });
    assert.equal(secondReset.statusCode, 200);
  } finally {
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute('DELETE FROM commands WHERE object_id = ?', [
        signupData.account.id,
      ]);
      await connection.execute('DELETE FROM sessions WHERE account_id = ?', [
        signupData.account.id,
      ]);
      await connection.execute(
        'DELETE FROM recovery_verifiers WHERE account_id = ?',
        [signupData.account.id],
      );
      await connection.execute('DELETE FROM accounts WHERE id = ?', [
        signupData.account.id,
      ]);
    });
  }
}
