import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { withBusinessTransaction } from '../src/db/pool.js';

export async function verifyProfile(app: FastifyInstance, pool: Pool) {
  const email = `${randomUUID()}@example.invalid`;
  const initialPassword = 'sandi awal profile test 123';
  const signupResponse = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/signup',
    headers: { 'idempotency-key': randomUUID() },
    payload: {
      displayName: 'Warga Asli',
      email,
      password: initialPassword,
    },
  });
  assert.equal(signupResponse.statusCode, 201);
  const signupData = signupResponse.json<{
    data: { account: { id: string; version: number }; recoveryCode: string };
  }>().data;

  try {
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
    let session = loginResponse.json<{
      data: { accessToken: string };
    }>().data;

    // 1. PATCH /api/v1/me validation & errors
    // Missing auth
    assert.equal(
      (
        await app.inject({
          method: 'PATCH',
          url: '/api/v1/me',
          headers: {
            'idempotency-key': randomUUID(),
            'if-match': '"1"',
          },
          payload: { displayName: 'Nama Baru' },
        })
      ).statusCode,
      401,
    );

    // Missing If-Match
    assert.equal(
      (
        await app.inject({
          method: 'PATCH',
          url: '/api/v1/me',
          headers: {
            authorization: `Bearer ${session.accessToken}`,
            'idempotency-key': randomUUID(),
          },
          payload: { displayName: 'Nama Baru' },
        })
      ).statusCode,
      428,
    );

    // Malformed If-Match
    for (const badIfMatch of ['1', '"0"', '"abc"', '""', '""1""']) {
      assert.equal(
        (
          await app.inject({
            method: 'PATCH',
            url: '/api/v1/me',
            headers: {
              authorization: `Bearer ${session.accessToken}`,
              'idempotency-key': randomUUID(),
              'if-match': badIfMatch,
            },
            payload: { displayName: 'Nama Baru' },
          })
        ).statusCode,
        400,
      );
    }

    // Missing or bad idempotency key
    assert.equal(
      (
        await app.inject({
          method: 'PATCH',
          url: '/api/v1/me',
          headers: {
            authorization: `Bearer ${session.accessToken}`,
            'if-match': '"1"',
          },
          payload: { displayName: 'Nama Baru' },
        })
      ).statusCode,
      400,
    );

    // Invalid displayName
    assert.equal(
      (
        await app.inject({
          method: 'PATCH',
          url: '/api/v1/me',
          headers: {
            authorization: `Bearer ${session.accessToken}`,
            'idempotency-key': randomUUID(),
            'if-match': '"1"',
          },
          payload: { displayName: ' ' },
        })
      ).statusCode,
      422,
    );

    // Version conflict
    const conflict = await app.inject({
      method: 'PATCH',
      url: '/api/v1/me',
      headers: {
        authorization: `Bearer ${session.accessToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"99"',
      },
      payload: { displayName: 'Nama Baru' },
    });
    assert.equal(conflict.statusCode, 409);
    const conflictBody = conflict.json<{
      code: string;
      currentVersion: number;
    }>();
    assert.equal(conflictBody.code, 'VERSION_CONFLICT');
    assert.equal(conflictBody.currentVersion, 1);

    // Valid PATCH /api/v1/me
    const patchKey = randomUUID();
    const patchSuccess = await app.inject({
      method: 'PATCH',
      url: '/api/v1/me',
      headers: {
        authorization: `Bearer ${session.accessToken}`,
        'idempotency-key': patchKey,
        'if-match': '"1"',
      },
      payload: { displayName: 'Warga Diperbarui' },
    });
    assert.equal(patchSuccess.statusCode, 200, patchSuccess.body);
    const patchData = patchSuccess.json<{
      data: { id: string; displayName: string; version: number };
    }>().data;
    assert.equal(patchData.id, signupData.account.id);
    assert.equal(patchData.displayName, 'Warga Diperbarui');
    assert.equal(patchData.version, 2);

    // Replay PATCH with same key & payload
    const patchReplay = await app.inject({
      method: 'PATCH',
      url: '/api/v1/me',
      headers: {
        authorization: `Bearer ${session.accessToken}`,
        'idempotency-key': patchKey,
        'if-match': '"1"',
      },
      payload: { displayName: 'Warga Diperbarui' },
    });
    assert.equal(patchReplay.statusCode, 200);
    assert.equal(
      patchReplay.json<{ data: { version: number } }>().data.version,
      2,
    );

    // Replay with conflict payload
    assert.equal(
      (
        await app.inject({
          method: 'PATCH',
          url: '/api/v1/me',
          headers: {
            authorization: `Bearer ${session.accessToken}`,
            'idempotency-key': patchKey,
            'if-match': '"1"',
          },
          payload: { displayName: 'Nama Lain Lagi' },
        })
      ).statusCode,
      409,
    );

    // Verify GET /me reflects updated displayName and version 2
    const meCheck = await app.inject({
      url: '/api/v1/me',
      headers: { authorization: `Bearer ${session.accessToken}` },
    });
    assert.equal(meCheck.statusCode, 200);
    assert.equal(
      meCheck.json<{ data: { displayName: string; version: number } }>().data
        .displayName,
      'Warga Diperbarui',
    );
    assert.equal(
      meCheck.json<{ data: { displayName: string; version: number } }>().data
        .version,
      2,
    );

    // 2. POST /api/v1/me/credentials
    // Missing If-Match
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/me/credentials',
          headers: {
            authorization: `Bearer ${session.accessToken}`,
            'idempotency-key': randomUUID(),
          },
          payload: {
            currentPassword: initialPassword,
            newPassword: 'sandi baru kredensial 123',
          },
        })
      ).statusCode,
      428,
    );

    // Wrong current password
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/me/credentials',
          headers: {
            authorization: `Bearer ${session.accessToken}`,
            'idempotency-key': randomUUID(),
            'if-match': '"2"',
          },
          payload: {
            currentPassword: 'salah sandi',
            newPassword: 'sandi baru kredensial 123',
          },
        })
      ).statusCode,
      401,
    );

    // Outdated version for credentials update
    const credConflict = await app.inject({
      method: 'POST',
      url: '/api/v1/me/credentials',
      headers: {
        authorization: `Bearer ${session.accessToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"1"',
      },
      payload: {
        currentPassword: initialPassword,
        newPassword: 'sandi baru kredensial 123',
      },
    });
    assert.equal(credConflict.statusCode, 409);
    assert.equal(
      credConflict.json<{ currentVersion: number }>().currentVersion,
      2,
    );

    // Valid credentials update: change password
    const newPassword1 = 'sandi baru kredensial 123';
    const credKey = randomUUID();
    const credSuccess = await app.inject({
      method: 'POST',
      url: '/api/v1/me/credentials',
      headers: {
        authorization: `Bearer ${session.accessToken}`,
        'idempotency-key': credKey,
        'if-match': '"2"',
      },
      payload: {
        currentPassword: initialPassword,
        newPassword: newPassword1,
      },
    });
    assert.equal(credSuccess.statusCode, 200, credSuccess.body);
    const credAck = credSuccess.json<{
      data: { actionId: string; state: string; version: number };
    }>().data;
    assert.equal(credAck.state, 'COMMITTED');
    assert.equal(credAck.version, 3);

    // Old session is now invalidated
    assert.equal(
      (
        await app.inject({
          url: '/api/v1/me',
          headers: { authorization: `Bearer ${session.accessToken}` },
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
    const newLogin = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/login',
      headers: { 'idempotency-key': randomUUID() },
      payload: { email, password: newPassword1, client: 'ANDROID' },
    });
    assert.equal(newLogin.statusCode, 200);
    session = newLogin.json<{ data: { accessToken: string } }>().data;

    // Replay credentials update with new authenticated session
    const credReplay = await app.inject({
      method: 'POST',
      url: '/api/v1/me/credentials',
      headers: {
        authorization: `Bearer ${session.accessToken}`,
        'idempotency-key': credKey,
        'if-match': '"2"',
      },
      payload: {
        currentPassword: initialPassword,
        newPassword: newPassword1,
      },
    });
    assert.equal(credReplay.statusCode, 200);
    assert.equal(
      credReplay.json<{ data: { state: string } }>().data.state,
      'ALREADY_COMMITTED',
    );

    // 3. POST /api/v1/me/recovery-code (rotateRecoveryCode)
    // Wrong password
    assert.equal(
      (
        await app.inject({
          method: 'POST',
          url: '/api/v1/me/recovery-code',
          headers: {
            authorization: `Bearer ${session.accessToken}`,
            'idempotency-key': randomUUID(),
          },
          payload: { currentPassword: 'sandi salah' },
        })
      ).statusCode,
      401,
    );

    // Valid rotation
    const rotateKey = randomUUID();
    const rotateSuccess = await app.inject({
      method: 'POST',
      url: '/api/v1/me/recovery-code',
      headers: {
        authorization: `Bearer ${session.accessToken}`,
        'idempotency-key': rotateKey,
      },
      payload: { currentPassword: newPassword1 },
    });
    assert.equal(rotateSuccess.statusCode, 200, rotateSuccess.body);
    const rotatedCode = rotateSuccess.json<{
      data: { recoveryCode: string };
    }>().data.recoveryCode;
    assert.match(rotatedCode, /^[A-Z2-7]{32}$/);
    assert.notEqual(rotatedCode, signupData.recoveryCode);

    // Replay rotate returns 409 RESULT_ALREADY_COMMITTED
    const rotateReplay = await app.inject({
      method: 'POST',
      url: '/api/v1/me/recovery-code',
      headers: {
        authorization: `Bearer ${session.accessToken}`,
        'idempotency-key': rotateKey,
      },
      payload: { currentPassword: newPassword1 },
    });
    assert.equal(rotateReplay.statusCode, 409);
    assert.equal(
      rotateReplay.json<{ code: string }>().code,
      'RESULT_ALREADY_COMMITTED',
    );
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
