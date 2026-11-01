export interface ServerConfig {
  environment: 'development' | 'test';
  host: '127.0.0.1' | '::1';
  port: number;
  logLevel: 'info' | 'warn' | 'error' | 'silent';
}

// Tolak nilai konfigurasi sebelum membuka socket; jangan cetak nilainya.
export function readConfig(env: NodeJS.ProcessEnv): ServerConfig {
  const environment = env.NODE_ENV ?? 'development';
  const host = env.HOST ?? '127.0.0.1';
  const port = env.PORT ?? '3000';
  const logLevel = env.LOG_LEVEL ?? 'info';
  if (environment !== 'development' && environment !== 'test') {
    throw new Error(
      'NODE_ENV belum didukung; fondasi ini hanya untuk lokal/test.',
    );
  }
  if (host !== '127.0.0.1' && host !== '::1') {
    throw new Error(
      'HOST wajib loopback sampai transport deployment tersedia.',
    );
  }
  if (!/^[1-9]\d{0,4}$/.test(port) || Number(port) > 65535) {
    throw new Error('PORT wajib bilangan bulat 1 sampai 65535.');
  }
  if (!['info', 'warn', 'error', 'silent'].includes(logLevel)) {
    throw new Error('LOG_LEVEL tidak didukung.');
  }
  return {
    environment,
    host,
    port: Number(port),
    logLevel: logLevel as ServerConfig['logLevel'],
  };
}
