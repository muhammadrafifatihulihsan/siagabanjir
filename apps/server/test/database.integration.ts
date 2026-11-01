import assert from 'node:assert/strict';
import { test } from 'node:test';
import type { RowDataPacket } from 'mysql2/promise';
import { readDatabaseConfig } from '../src/db/config.js';
import {
  createDatabasePool,
  verifyDatabase,
  withBusinessTransaction,
  withConnection,
} from '../src/db/pool.js';
import { migrate } from '../src/db/migrations.js';
import { verifyAuthSchema } from './auth-schema.js';
import { verifySecretCommands } from './secret-command.js';

void test('MySQL nyata: migrasi berulang, isolasi, rollback dan batas akses runtime', async () => {
  assert.equal(
    process.env.NODE_ENV,
    'test',
    'Tes DB hanya untuk lingkungan test.',
  );
  const runtime = createDatabasePool(readDatabaseConfig(process.env, 'app'));
  const migrator = createDatabasePool(
    readDatabaseConfig(process.env, 'migrate'),
  );
  try {
    await withConnection(migrator, async (connection) => {
      await verifyDatabase(connection);
      const directory = new URL('../migrations/', import.meta.url);
      await migrate(connection, directory);
      assert.equal(await migrate(connection, directory), 0);
    });
    await verifyAuthSchema(runtime);
    await verifySecretCommands(runtime);
    await withConnection(runtime, async (connection) => {
      const [rows] = await connection.query<RowDataPacket[]>(
        'SELECT DATABASE() AS db, @@transaction_isolation AS isolationLevel, @@session.time_zone AS zone, @@autocommit AS autoCommit',
      );
      assert.equal(rows[0]?.db, 'siagabanjirtest');
      assert.equal(rows[0]?.isolationLevel, 'READ-COMMITTED');
      assert.equal(rows[0]?.zone, '+00:00');
      assert.equal(rows[0]?.autoCommit, '1');
      await assert.rejects(connection.query('USE siagabanjirdev'), {
        code: 'ER_DBACCESS_DENIED_ERROR',
      });
      await assert.rejects(
        connection.query('CREATE TABLE forbidden_runtime (id INT)'),
        { code: 'ER_TABLEACCESS_DENIED_ERROR' },
      );
    });
    const sentinel = new Error('synthetic rollback');
    await assert.rejects(
      withBusinessTransaction(runtime, async (connection) => {
        await connection.execute(
          'DELETE FROM business_write_guard WHERE id = ?',
          [1],
        );
        throw sentinel;
      }),
      (error: unknown) => error === sentinel,
    );
    await withBusinessTransaction(runtime, async (connection) => {
      const [rows] = await connection.query<RowDataPacket[]>(
        'SELECT id FROM business_write_guard',
      );
      assert.equal(rows.length, 1);
      assert.equal(rows[0]?.id, 1);
    });
  } finally {
    await Promise.all([runtime.end(), migrator.end()]);
  }
});
