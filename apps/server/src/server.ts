import { buildApp } from './app.js';
import { readConfig } from './config.js';

async function start(): Promise<void> {
  const config = readConfig(process.env);
  const app = buildApp(config);
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
