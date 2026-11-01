/**
 * Health Check Domain Logic SiagaBanjir
 * Memeriksa status kesehatan server, proses Node.js, database MySQL, dan riwayat migrasi.
 */
import type { Pool, RowDataPacket } from 'mysql2/promise';

export interface HealthCheckResult {
  status: 'healthy' | 'unhealthy';
  server: {
    status: 'UP';
    uptimeSeconds: number;
    nodeVersion: string;
    memoryMb: {
      rss: number;
      heapUsed: number;
      heapTotal: number;
    };
  };
  database: {
    status: 'UP' | 'DOWN';
    latencyMs: number;
    error?: string;
  };
  migrations: {
    status: 'UP' | 'DOWN';
    appliedCount: number;
  };
}

/**
 * Menjalankan pemeriksaan kesehatan komprehensif terhadap server dan MySQL.
 */
export async function checkHealth(pool?: Pool): Promise<HealthCheckResult> {
  const uptimeSeconds = Math.round(process.uptime() * 100) / 100;
  const mem = process.memoryUsage();
  const toMb = (bytes: number) =>
    Math.round((bytes / (1024 * 1024)) * 100) / 100;

  const serverInfo = {
    status: 'UP' as const,
    uptimeSeconds,
    nodeVersion: process.version,
    memoryMb: {
      rss: toMb(mem.rss),
      heapUsed: toMb(mem.heapUsed),
      heapTotal: toMb(mem.heapTotal),
    },
  };

  if (!pool) {
    return {
      status: 'healthy',
      server: serverInfo,
      database: { status: 'UP', latencyMs: 0 },
      migrations: { status: 'UP', appliedCount: 0 },
    };
  }

  let dbStatus: 'UP' | 'DOWN';
  let latencyMs = 0;
  let dbError: string | undefined;
  let appliedCount = 0;
  let migStatus: 'UP' | 'DOWN' = 'DOWN';

  try {
    const start = performance.now();
    const connection = await pool.getConnection();
    try {
      await connection.execute('SELECT 1');
      latencyMs = Math.round((performance.now() - start) * 100) / 100;
      dbStatus = 'UP';

      // Periksa status riwayat migrasi
      try {
        const [rows] = await connection.execute<RowDataPacket[]>(
          "SELECT COUNT(*) as count FROM migration_history WHERE state = 'applied'",
        );
        appliedCount = Number(rows[0]?.count ?? 0);
        migStatus = 'UP';
      } catch {
        // Tabel migration_history mungkin belum dibuat di test non-db
        migStatus = 'DOWN';
      }
    } finally {
      connection.release();
    }
  } catch (err) {
    dbStatus = 'DOWN';
    dbError = err instanceof Error ? err.message : 'Database connection error';
  }

  const isHealthy = dbStatus === 'UP';

  return {
    status: isHealthy ? 'healthy' : 'unhealthy',
    server: serverInfo,
    database: {
      status: dbStatus,
      latencyMs,
      ...(dbError ? { error: dbError } : {}),
    },
    migrations: {
      status: migStatus,
      appliedCount,
    },
  };
}
