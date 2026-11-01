import { buildApp } from './app.js';
import { readConfig } from './config.js';
import { readDatabaseConfig } from './db/config.js';
import {
  createDatabasePool,
  verifyDatabase,
  withConnection,
} from './db/pool.js';
import { readSecurityKeys } from './security/keys.js';

async function start(): Promise<void> {
  const config = readConfig(process.env);
  const keys = readSecurityKeys(process.env);
  const pool = createDatabasePool(readDatabaseConfig(process.env, 'app'));
  const app = buildApp(config, undefined, { pool, keys });
  app.addHook('onClose', async () => {
    await pool.end();
  });
  const stop = () => {
    const deadline = setTimeout(() => process.exit(1), 10_000);
    deadline.unref();
    void app.close().then(
      () => clearTimeout(deadline),
      () => {
        process.stderr.write('Server gagal berhenti dengan normal.\n');
        process.exitCode = 1;
      },
    );
  };
  process.once('SIGINT', stop);
  process.once('SIGTERM', stop);
  try {
    await withConnection(pool, verifyDatabase);
    await app.listen({ host: config.host, port: config.port });
  } catch {
    await app.close();
    process.removeListener('SIGINT', stop);
    process.removeListener('SIGTERM', stop);
    throw new Error('Server gagal dimulai.');
  }
}

void start().catch(() => {
  process.stderr.write(
    'Server gagal dimulai; periksa konfigurasi dan port lokal.\n',
  );
  process.exitCode = 1;
});
