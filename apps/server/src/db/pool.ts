import { createPool } from 'mysql2/promise';
import type { Pool, PoolConnection, RowDataPacket } from 'mysql2/promise';
import type { readDatabaseConfig } from './config.js';

export function createDatabasePool(
  config: ReturnType<typeof readDatabaseConfig>,
) {
  return createPool({
    ...config,
    connectionLimit: 4,
    waitForConnections: true,
    queueLimit: 16,
    connectTimeout: 5_000,
    idleTimeout: 30_000,
    maxIdle: 2,
    charset: 'utf8mb4',
    timezone: 'Z',
    dateStrings: true,
    supportBigNumbers: true,
    bigNumberStrings: true,
    multipleStatements: false,
    enableKeepAlive: true,
  });
}

export async function withConnection<T>(
  pool: Pool,
  operation: (connection: PoolConnection) => Promise<T>,
): Promise<T> {
  const connection = await pool.getConnection();
  try {
    // Inisialisasi setiap checkout; tidak bergantung event async pool.
    await connection.rollback();
    await connection.query('SET SESSION autocommit = 1');
    await connection.query(
      'SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED',
    );
    await connection.query("SET SESSION time_zone = '+00:00'");
    await connection.query('SET SESSION innodb_lock_wait_timeout = 5');
    const result = await operation(connection);
    connection.release();
    return result;
  } catch (error) {
    // Jangan kembalikan sesi dengan state transaksi/lock yang tidak diketahui.
    connection.destroy();
    throw error;
  }
}

export async function verifyDatabase(
  connection: PoolConnection,
): Promise<void> {
  const [rows] = await connection.query<RowDataPacket[]>(
    'SELECT VERSION() AS version, @@default_storage_engine AS engine',
  );
  const row = rows[0];
  if (
    typeof row?.version !== 'string' ||
    !/^8\.(0|4)\./.test(row.version) ||
    row.version.toLowerCase().includes('mariadb') ||
    row.engine !== 'InnoDB'
  ) {
    throw new Error('Instance harus MySQL 8.0/8.4 dengan InnoDB.');
  }
}

export async function withBusinessTransaction<T>(
  pool: Pool,
  operation: (connection: PoolConnection) => Promise<T>,
): Promise<T> {
  return withConnection(pool, async (connection) => {
    await connection.beginTransaction();
    try {
      const [guard] = await connection.query<RowDataPacket[]>(
        'SELECT id FROM business_write_guard WHERE id = 1 FOR UPDATE',
      );
      if (guard.length !== 1)
        throw new Error('Guard transaksi belum tersedia.');
      const result = await operation(connection);
      await connection.commit();
      return result;
    } catch (error) {
      await connection.rollback();
      throw error;
    }
  });
}
