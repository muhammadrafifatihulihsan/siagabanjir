import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { withBusinessTransaction } from '../src/db/pool.js';

export async function verifySession(
  app: FastifyInstance,
  pool: Pool,
  accountId: string,
  session: { sessionId: string; accessToken: string; revokeSecret: string },
) {
  const headers = { authorization: `Bearer ${session.accessToken}` };
  const me = () => app.inject({ url: '/api/v1/me', headers });
  assert.equal((await app.inject('/api/v1/me')).statusCode, 401);
  assert.equal(
    (await me()).json<{ data: { id: string } }>().data.id,
    accountId,
  );
  assert.equal(
    (
      await app.inject({
        url: '/api/v1/me',
        headers: { authorization: `Bearer ${session.revokeSecret}` },
      })
    ).statusCode,
    401,
  );
  await withBusinessTransaction(pool, async (c) => {
    await c.execute(
      'UPDATE accounts SET credential_epoch = credential_epoch + 1 WHERE id = ?',
      [accountId],
    );
  });
  assert.equal((await me()).statusCode, 401);
  await withBusinessTransaction(pool, async (c) => {
    await c.execute(
      'UPDATE accounts SET credential_epoch = credential_epoch - 1 WHERE id = ?',
      [accountId],
    );
  });
  await withBusinessTransaction(pool, async (c) => {
    await c.execute(
      'UPDATE sessions SET expires_at = created_at + INTERVAL 1000 MICROSECOND WHERE id = ?',
      [session.sessionId],
    );
  });
  assert.equal((await me()).statusCode, 401);
  await withBusinessTransaction(pool, async (c) => {
    await c.execute(
      'UPDATE sessions SET expires_at = created_at + INTERVAL 7 DAY WHERE id = ?',
      [session.sessionId],
    );
  });
  const logoutKey = randomUUID();
  const logout = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/logout',
    headers: { ...headers, 'idempotency-key': logoutKey },
  });
  assert.equal(logout.statusCode, 200);
  assert.equal((await me()).statusCode, 401);
  assert.equal(
    (
      await app.inject({
        method: 'POST',
        url: '/api/v1/auth/logout',
        headers: { ...headers, 'idempotency-key': logoutKey },
      })
    ).statusCode,
    401,
  );
  const key = randomUUID();
  const revoke = (secret: string) =>
    app.inject({
      method: 'POST',
      url: '/api/v1/auth/revoke',
      headers: { 'idempotency-key': key },
      payload: { sessionId: session.sessionId, revokeSecret: secret },
    });
  assert.equal((await revoke(session.accessToken)).statusCode, 401);
  assert.equal((await revoke(session.revokeSecret)).statusCode, 200);
  assert.equal(
    (await revoke(session.revokeSecret)).json<{ data: { state: string } }>()
      .data.state,
    'ALREADY_COMMITTED',
  );
}
