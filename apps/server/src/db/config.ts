export type DatabaseRole = 'app' | 'migrate';

export function readDatabaseConfig(env: NodeJS.ProcessEnv, role: DatabaseRole) {
  const environment = env.NODE_ENV;
  if (environment !== 'development' && environment !== 'test') {
    throw new Error('Database memerlukan NODE_ENV development/test eksplisit.');
  }
  const suffix = environment === 'test' ? 'test' : 'dev';
  const database = `siagabanjir${suffix}`;
  const user = `sb_${suffix}_${role}`;
  const prefix = role === 'app' ? 'DB' : 'MIGRATION_DB';
  const password = env[`${prefix}_PASSWORD`];
  const port = env.DB_PORT ?? '3306';
  const host =
    role === 'app'
      ? (env.DB_HOST ?? '127.0.0.1')
      : (env.MIGRATION_DB_HOST ?? env.DB_HOST ?? '127.0.0.1');
  const allowedHosts = ['127.0.0.1', 'localhost', 'mysql', 'db'];
  if (
    env.DB_NAME !== database ||
    env[`${prefix}_USER`] !== user ||
    !allowedHosts.includes(host) ||
    !password ||
    !/^[1-9]\d{0,4}$/.test(port) ||
    Number(port) > 65535
  ) {
    throw new Error('Konfigurasi database tidak sesuai lingkungan/peran.');
  }
  return { host, port: Number(port), database, user, password };
}
