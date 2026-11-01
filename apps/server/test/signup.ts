import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { Pool, RowDataPacket } from 'mysql2/promise';
import { buildApp } from '../src/app.js';
import { readConfig } from '../src/config.js';
import { readSecurityKeys } from '../src/security/keys.js';
import { actorScope } from '../src/security/fingerprint.js';
import { withBusinessTransaction, withConnection } from '../src/db/pool.js';
import { verifyPassword } from '../src/security/password.js';
import { recoveryVerifier } from '../src/security/secrets.js';
import { verifySession } from './session.js';
import { verifyProfile } from './profile.js';
import { verifyResetPassword } from './reset-password.js';

export async function verifySignup(pool: Pool) {
  const keys = readSecurityKeys(process.env);
  const app = buildApp(
    readConfig({ NODE_ENV: 'test', LOG_LEVEL: 'silent' }),
    undefined,
    { pool, keys },
  );
  const email = `${randomUUID()}@example.invalid`;
  const payload = {
    displayName: ' Warga Uji ',
    email: email.toUpperCase(),
    password: 'sandi sintetis signup',
  };
  const key = randomUUID();
  const request = (body: object, id = key) =>
    app.inject({
      method: 'POST',
      url: '/api/v1/auth/signup',
      headers: { 'idempotency-key': id },
      payload: body,
    });
  try {
    const unknown = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/login',
      headers: { 'idempotency-key': randomUUID() },
      payload: { email, password: 'wrong', client: 'ANDROID' },
    });
    assert.equal(unknown.statusCode, 401);
    const response = await request(payload);
    assert.equal(response.statusCode, 201, response.body);
    const result = response.json<{
      data: {
        account: {
          id: string;
          role: string;
          email: string;
          displayName: string;
        };
        recoveryCode: string;
      };
    }>();
    assert.equal(result.data.account.role, 'CITIZEN');
    assert.equal(result.data.account.email, email);
    assert.equal(result.data.account.displayName, 'Warga Uji');
    const loginKey = randomUUID();
    const loginRequest = (
      password: string,
      client = 'ANDROID',
      id = randomUUID(),
    ) =>
      app.inject({
        method: 'POST',
        url: '/api/v1/auth/login',
        headers: { 'idempotency-key': id },
        payload: { email, password, client },
      });
    assert.equal((await loginRequest('wrong')).statusCode, 401);
    assert.equal(
      (await loginRequest(payload.password, 'ADMIN_WEB')).statusCode,
      403,
    );
    const session = await loginRequest(payload.password, 'ANDROID', loginKey);
    assert.equal(session.statusCode, 200, session.body);
    const sessionData = session.json<{
      data: { sessionId: string; accessToken: string; revokeSecret: string };
    }>().data;
    assert.notEqual(sessionData.accessToken, sessionData.revokeSecret);
    await verifySession(app, pool, result.data.account.id, sessionData);
    const active = (await loginRequest(payload.password)).json<{
      data: { sessionId: string; accessToken: string; revokeSecret: string };
    }>().data;
    const revokeKey = randomUUID();
    const revoke = (id: string, secret = active.revokeSecret) =>
      app.inject({
        method: 'POST',
        url: '/api/v1/auth/revoke',
        headers: { 'idempotency-key': revokeKey },
        payload: { sessionId: id, revokeSecret: secret },
      });
    assert.equal((await revoke(sessionData.sessionId)).statusCode, 401);
    const concurrent = await Promise.all([
      revoke(active.sessionId.toUpperCase()),
      revoke(active.sessionId),
    ]);
    for (const response of concurrent) assert.equal(response.statusCode, 200);
    const acknowledgements = concurrent.map(
      (response) =>
        response.json<{
          data: { actionId: string; state: string };
        }>().data,
    );
    assert.deepEqual(acknowledgements.map((ack) => ack.state).sort(), [
      'ALREADY_COMMITTED',
      'COMMITTED',
    ]);
    assert.equal(acknowledgements[0]?.actionId, acknowledgements[1]?.actionId);
    assert.equal(
      (
        await app.inject({
          url: '/api/v1/me',
          headers: { authorization: `Bearer ${active.accessToken}` },
        })
      ).statusCode,
      401,
    );
    assert.equal(
      (await revoke(active.sessionId, active.accessToken)).statusCode,
      401,
    );
    assert.equal(
      (await revoke(sessionData.sessionId, sessionData.revokeSecret))
        .statusCode,
      409,
    );
    assert.equal(
      (await loginRequest(payload.password, 'ANDROID', loginKey)).statusCode,
      409,
    );
    for (let attempt = 0; attempt < 5; attempt++)
      assert.equal((await loginRequest('wrong')).statusCode, 401);
    assert.equal((await loginRequest(payload.password)).statusCode, 429);
    assert.match(result.data.recoveryCode, /^[A-Z2-7]{32}$/);
    assert.equal(response.headers['cache-control'], 'no-store');
    const replay = await request(payload);
    assert.equal(replay.statusCode, 409);
    assert.equal(
      replay.json<{ code: string }>().code,
      'RESULT_ALREADY_COMMITTED',
    );
    assert.ok(!replay.body.includes(result.data.recoveryCode));
    assert.equal(
      (await request({ ...payload, displayName: 'Berbeda' })).statusCode,
      409,
    );
    assert.equal((await request(payload, randomUUID())).statusCode, 409);
    assert.equal(
      (await request({ ...payload, role: 'ADMIN' }, randomUUID())).statusCode,
      422,
    );
    await withConnection(pool, async (connection) => {
      const [rows] = await connection.execute<RowDataPacket[]>(
        'SELECT password_hash, password_salt FROM accounts WHERE id = ?',
        [result.data.account.id],
      );
      assert.ok(
        await verifyPassword(
          payload.password,
          rows[0]?.password_salt as Buffer,
          rows[0]?.password_hash as Buffer,
        ),
      );
      const [recovery] = await connection.execute<RowDataPacket[]>(
        'SELECT verifier FROM recovery_verifiers WHERE account_id = ?',
        [result.data.account.id],
      );
      assert.deepEqual(
        recovery[0]?.verifier,
        recoveryVerifier(result.data.recoveryCode, keys.recovery),
      );
    });
    await verifyProfile(app, pool);
    await verifyResetPassword(app, pool);
  } finally {
    await app.close();
    await withBusinessTransaction(pool, async (connection) => {
      const [owners] = await connection.execute<RowDataPacket[]>(
        'SELECT id FROM accounts WHERE email_normalized = ?',
        [email],
      );
      for (const owner of owners)
        await connection.execute('DELETE FROM commands WHERE actor_scope = ?', [
          actorScope(keys.journal, 'account', owner.id as string),
        ]);
      await connection.execute(
        'DELETE FROM auth_failures WHERE principal_digest = ?',
        [actorScope(keys.journal, 'public', email)],
      );
      await connection.execute(
        'DELETE FROM sessions WHERE account_id IN (SELECT id FROM accounts WHERE email_normalized = ?)',
        [email],
      );
      await connection.execute('DELETE FROM commands WHERE actor_scope = ?', [
        actorScope(keys.journal, 'public', email),
      ]);
      await connection.execute(
        'DELETE FROM recovery_verifiers WHERE account_id IN (SELECT id FROM accounts WHERE email_normalized = ?)',
        [email],
      );
      await connection.execute(
        'DELETE FROM accounts WHERE email_normalized = ?',
        [email],
      );
    });
  }
}
