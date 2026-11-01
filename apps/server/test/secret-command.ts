import assert from 'node:assert/strict';
import { randomBytes, randomUUID } from 'node:crypto';
import type { Pool, PoolConnection, RowDataPacket } from 'mysql2/promise';
import { withBusinessTransaction, withConnection } from '../src/db/pool.js';
import { runSecretCommand } from '../src/db/secret-command.js';

export async function verifySecretCommands(pool: Pool): Promise<void> {
  const scope = randomBytes(32);
  const otherScope = randomBytes(32);
  const identity = {
    actorScope: scope,
    clientKey: randomUUID(),
    operation: 'login' as const,
    fingerprint: randomBytes(32),
  };
  const authorize = async (connection: PoolConnection) => {
    await connection.query('SELECT 1');
  };
  const mutate = async (connection: PoolConnection) => {
    await connection.execute(
      `INSERT INTO auth_failures (principal_digest, source_digest, window_start, count)
      VALUES (?, ?, UTC_TIMESTAMP(3), 1)`,
      [scope, scope],
    );
    return { value: 'synthetic-secret-never-persist', objectId: null };
  };
  try {
    const results = await Promise.allSettled([
      runSecretCommand(pool, identity, authorize, mutate),
      runSecretCommand(pool, identity, authorize, mutate),
    ]);
    assert.equal(
      results.filter((result) => result.status === 'fulfilled').length,
      1,
    );
    const rejected = results.find((result) => result.status === 'rejected');
    assert.ok(rejected?.status === 'rejected');
    assert.equal(
      (rejected.reason as { code: string }).code,
      'RESULT_ALREADY_COMMITTED',
    );
    await assert.rejects(
      runSecretCommand(
        pool,
        { ...identity, clientKey: identity.clientKey.toUpperCase() },
        authorize,
        mutate,
      ),
      { code: 'RESULT_ALREADY_COMMITTED' },
    );
    await assert.rejects(
      runSecretCommand(
        pool,
        { ...identity, operation: 'signup' },
        authorize,
        mutate,
      ),
      { code: 'IDEMPOTENCY_CONFLICT' },
    );
    await assert.rejects(
      runSecretCommand(
        pool,
        { ...identity, fingerprint: randomBytes(32) },
        authorize,
        mutate,
      ),
      { code: 'IDEMPOTENCY_CONFLICT' },
    );
    const denied = new Error('synthetic permission denied');
    await assert.rejects(
      runSecretCommand(pool, identity, () => Promise.reject(denied), mutate),
      (error: unknown) => error === denied,
    );

    // Kunci sama boleh dipakai principal berbeda; respons tidak disimpan/replay.
    assert.equal(
      await runSecretCommand(
        pool,
        { ...identity, actorScope: otherScope },
        authorize,
        () => Promise.resolve({ value: 'other-secret', objectId: null }),
      ),
      'other-secret',
    );
    const failingKey = randomUUID();
    const failure = new Error('synthetic mutation failure');
    await assert.rejects(
      runSecretCommand(
        pool,
        { ...identity, clientKey: failingKey },
        authorize,
        async (connection) => {
          await connection.execute(
            'UPDATE auth_failures SET count = 9 WHERE principal_digest = ? AND source_digest = ?',
            [scope, scope],
          );
          throw failure;
        },
      ),
      (error: unknown) => error === failure,
    );
    await withConnection(pool, async (connection) => {
      const [effects] = await connection.execute<RowDataPacket[]>(
        'SELECT count FROM auth_failures WHERE principal_digest = ? AND source_digest = ?',
        [scope, scope],
      );
      assert.equal(effects[0]?.count, 1);
      const [commands] = await connection.execute<RowDataPacket[]>(
        'SELECT * FROM commands WHERE actor_scope = ?',
        [scope],
      );
      assert.equal(commands.length, 1);
      assert.equal(commands[0]?.client_key, identity.clientKey);
      assert.equal(typeof commands[0]?.action_seq, 'string');
      assert.ok(!JSON.stringify(commands).includes('synthetic-secret'));
      assert.equal(commands[0]?.safe_error, null);
    });
  } finally {
    // Hanya hapus fixture milik tes ini; tidak reset data lain atau sequence.
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute(
        'DELETE FROM commands WHERE actor_scope IN (?, ?)',
        [scope, otherScope],
      );
      await connection.execute(
        'DELETE FROM auth_failures WHERE principal_digest = ? AND source_digest = ?',
        [scope, scope],
      );
    });
  }
}
