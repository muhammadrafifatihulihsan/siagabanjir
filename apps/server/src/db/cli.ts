import { readDatabaseConfig } from './config.js';
import { createDatabasePool, verifyDatabase, withConnection } from './pool.js';
import { migrate } from './migrations.js';

async function run() {
  const command = process.argv[2];
  if (command !== 'check' && command !== 'migrate')
    throw new Error('Perintah invalid.');
  const config = readDatabaseConfig(
    process.env,
    command === 'migrate' ? 'migrate' : 'app',
  );
  const pool = createDatabasePool(config);
  try {
    await withConnection(pool, async (connection) => {
      await verifyDatabase(connection);
      if (command === 'migrate') {
        const count = await migrate(
          connection,
          new URL('../../migrations/', import.meta.url),
        );
        process.stdout.write(`Migrasi selesai: ${count} diterapkan.\n`);
      } else {
        process.stdout.write('Koneksi MySQL dan konfigurasi instance valid.\n');
      }
    });
  } finally {
    await pool.end();
  }
}

void run().catch(() => {
  process.stderr.write(
    'Operasi database gagal. Periksa konfigurasi privat, akses, versi dan riwayat migrasi; detail sensitif tidak dicetak.\n',
  );
  process.exitCode = 1;
});
