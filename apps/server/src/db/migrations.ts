import { createHash } from 'node:crypto';
import { readdir, readFile } from 'node:fs/promises';
import type { PoolConnection, RowDataPacket } from 'mysql2/promise';

export async function loadMigrations(directory: URL) {
  const names = (await readdir(directory)).sort();
  if (!names.length) throw new Error('Migrasi tidak ditemukan.');
  return Promise.all(
    names.map(async (name, index) => {
      if (
        !/^\d{3}_[a-z_]+\.sql$/.test(name) ||
        Number(name.slice(0, 3)) !== index + 1
      ) {
        throw new Error('Nama/urutan migrasi invalid.');
      }
      // Normalisasi EOL agar checksum sama pada checkout Windows/Linux.
      const sql = (await readFile(new URL(name, directory), 'utf8'))
        .replaceAll('\r\n', '\n')
        .trim();
      if (!sql) throw new Error('Migrasi kosong.');
      return {
        name,
        sql,
        checksum: createHash('sha256').update(sql).digest('hex'),
      };
    }),
  );
}

export function validateHistory(
  migrations: readonly { name: string; checksum: string }[],
  history: readonly { name: unknown; checksum: unknown; state: unknown }[],
): void {
  for (const [index, row] of history.entries()) {
    const expected = migrations[index];
    if (
      !expected ||
      row.name !== expected.name ||
      row.checksum !== expected.checksum ||
      row.state !== 'applied'
    ) {
      throw new Error(
        'Riwayat migrasi berubah/tidak lengkap; inspeksi manual diperlukan.',
      );
    }
  }
}

interface MigrationRow extends RowDataPacket {
  name: string;
  checksum: string;
  state: string;
}

export async function migrate(connection: PoolConnection, directory: URL) {
  const migrations = await loadMigrations(directory);
  const [locks] = await connection.execute<RowDataPacket[]>(
    'SELECT GET_LOCK(CONCAT(DATABASE(), ?), 0) AS acquired',
    [':migrations'],
  );
  if (locks[0]?.acquired !== 1)
    throw new Error('Migrasi lain sedang berjalan.');
  try {
    await connection.query(`CREATE TABLE IF NOT EXISTS schema_migrations (
      name VARCHAR(100) CHARACTER SET ascii COLLATE ascii_bin PRIMARY KEY,
      checksum CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
      state ENUM('applying', 'applied') NOT NULL,
      applied_at DATETIME(3) NULL
    ) ENGINE=InnoDB`);
    const [history] = await connection.query<MigrationRow[]>(
      'SELECT name, checksum, state FROM schema_migrations ORDER BY name',
    );
    validateHistory(migrations, history);
    for (const migration of migrations.slice(history.length)) {
      // DDL MySQL implicit commit: marker dirty harus persisten sebelum DDL.
      await connection.execute(
        "INSERT INTO schema_migrations (name, checksum, state) VALUES (?, ?, 'applying')",
        [migration.name, migration.checksum],
      );
      await connection.query(migration.sql);
      await connection.execute(
        "UPDATE schema_migrations SET state = 'applied', applied_at = UTC_TIMESTAMP(3) WHERE name = ?",
        [migration.name],
      );
    }
    return migrations.length - history.length;
  } finally {
    await connection.execute('SELECT RELEASE_LOCK(CONCAT(DATABASE(), ?))', [
      ':migrations',
    ]);
  }
}
