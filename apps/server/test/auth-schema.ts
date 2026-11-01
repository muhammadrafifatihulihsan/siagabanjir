import assert from 'node:assert/strict';
import { randomBytes, randomUUID } from 'node:crypto';
import type { Pool, PoolConnection, RowDataPacket } from 'mysql2/promise';
import { withConnection } from '../src/db/pool.js';

async function insertAccount(
  connection: PoolConnection,
  id: string,
  email: string,
) {
  await connection.execute(
    `INSERT INTO accounts (id, email_normalized, display_name, password_hash, password_salt, created_at)
      VALUES (?, ?, ?, ?, ?, UTC_TIMESTAMP(3))`,
    [id, email, 'Warga Sintetis', randomBytes(64), randomBytes(16)],
  );
}

export async function verifyAuthSchema(pool: Pool): Promise<void> {
  await withConnection(pool, async (connection) => {
    await connection.beginTransaction();
    try {
      const accountId = randomUUID();
      const email = `${accountId}@example.invalid`;
      await insertAccount(connection, accountId, email);
      const [accounts] = await connection.execute<RowDataPacket[]>(
        'SELECT role, version, credential_epoch FROM accounts WHERE id = ?',
        [accountId],
      );
      assert.equal(accounts[0]?.role, 'CITIZEN');
      assert.equal(accounts[0]?.version, 1);
      assert.equal(accounts[0]?.credential_epoch, 1);
      await assert.rejects(insertAccount(connection, randomUUID(), email), {
        code: 'ER_DUP_ENTRY',
      });
      await assert.rejects(
        insertAccount(connection, randomUUID(), email.toUpperCase()),
        { code: 'ER_CHECK_CONSTRAINT_VIOLATED' },
      );
      for (const sql of [
        "UPDATE accounts SET role = 'OWNER' WHERE id = ?",
        'UPDATE accounts SET version = 0 WHERE id = ?',
        'UPDATE accounts SET credential_epoch = 0 WHERE id = ?',
        'UPDATE accounts SET password_n = 1024 WHERE id = ?',
        "UPDATE accounts SET password_hash = X'01' WHERE id = ?",
      ])
        await assert.rejects(connection.execute(sql, [accountId]), {
          code: 'ER_CHECK_CONSTRAINT_VIOLATED',
        });

      const token = randomBytes(32);
      const revoke = randomBytes(32);
      const insertSession = (owner: string, digest: Buffer, days: number) =>
        connection.execute(
          `INSERT INTO sessions (id, account_id, token_digest, revoke_digest, epoch, created_at, expires_at)
          VALUES (?, ?, ?, ?, 1, '2026-11-01 00:00:00.000', DATE_ADD('2026-11-01 00:00:00.000', INTERVAL ? DAY))`,
          [randomUUID(), owner, digest, randomBytes(32), days],
        );
      await insertSession(accountId, token, 7);
      await assert.rejects(insertSession(accountId, token, 7), {
        code: 'ER_DUP_ENTRY',
      });
      await assert.rejects(insertSession(accountId, randomBytes(32), 8), {
        code: 'ER_CHECK_CONSTRAINT_VIOLATED',
      });
      await assert.rejects(insertSession(randomUUID(), randomBytes(32), 7), {
        code: 'ER_NO_REFERENCED_ROW',
      });
      await connection.execute(
        'INSERT INTO recovery_verifiers (account_id, verifier) VALUES (?, ?)',
        [accountId, revoke],
      );
      await assert.rejects(
        connection.execute(
          'INSERT INTO recovery_verifiers (account_id, verifier) VALUES (?, ?)',
          [accountId, randomBytes(32)],
        ),
        { code: 'ER_DUP_ENTRY' },
      );
      await connection.execute(
        `INSERT INTO auth_failures (principal_digest, source_digest, window_start, count)
          VALUES (?, ?, UTC_TIMESTAMP(3), 5)`,
        [token, revoke],
      );
      await assert.rejects(
        connection.execute(
          `INSERT INTO auth_failures (principal_digest, source_digest, window_start)
          VALUES (?, ?, UTC_TIMESTAMP(3))`,
          [token, revoke],
        ),
        { code: 'ER_DUP_ENTRY' },
      );
    } finally {
      // Semua fixture sintetis dibatalkan, termasuk saat assertion gagal.
      await connection.rollback();
    }
  });
}
