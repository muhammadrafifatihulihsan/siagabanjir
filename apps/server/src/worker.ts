import { setTimeout as delay } from 'node:timers/promises';
import { readAiConfig } from './ai/config.js';
import { claimJob } from './ai/queue.js';
import { processJob } from './ai/process.js';
import { readDatabaseConfig } from './db/config.js';
import { createDatabasePool } from './db/pool.js';
import { cleanupOne } from './storage/cleanup.js';

async function run() {
  const config = readAiConfig(process.env);
  const pool = createDatabasePool(readDatabaseConfig(process.env, 'app'));
  let stopping = false;
  const stop = () => {
    stopping = true;
  };
  process.once('SIGINT', stop);
  process.once('SIGTERM', stop);
  try {
    process.stdout.write('Worker analisis aktif.\n');
    while (!stopping) {
      try {
        const job = await claimJob(pool);
        if (job) await processJob(pool, job, config);
        else if (!(await cleanupOne(pool))) await delay(1000);
      } catch {
        process.stderr.write(
          'Worker gagal memproses antrean; akan mencoba kembali.\n',
        );
        await delay(5000);
      }
    }
  } finally {
    await pool.end();
  }
}
void run().catch(() => {
  process.stderr.write('Worker gagal dimulai; periksa konfigurasi privat.\n');
  process.exitCode = 1;
});
