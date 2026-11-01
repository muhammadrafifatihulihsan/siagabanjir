import type { PoolConnection, RowDataPacket } from 'mysql2/promise';
import { HttpProblem } from '../http/problem.js';

export interface FailureScope {
  principal: Buffer;
  source: Buffer;
}

export async function checkThrottle(
  connection: PoolConnection,
  scope: FailureScope,
): Promise<void> {
  const [rows] = await connection.execute<RowDataPacket[]>(
    `SELECT CEIL(TIMESTAMPDIFF(MICROSECOND, UTC_TIMESTAMP(3), blocked_until) / 1000000) AS remaining
     FROM auth_failures WHERE principal_digest = ? AND source_digest = ? AND blocked_until > UTC_TIMESTAMP(3)`,
    [scope.principal, scope.source],
  );
  if (rows.length)
    throw new HttpProblem(
      429,
      'AUTH_THROTTLED',
      Math.max(1, Number(rows[0]?.remaining)),
    );
}

export async function recordFailure(
  connection: PoolConnection,
  scope: FailureScope,
): Promise<void> {
  await connection.execute(
    `DELETE FROM auth_failures WHERE principal_digest = ? AND source_digest = ?
    AND window_start <= UTC_TIMESTAMP(3) - INTERVAL 15 MINUTE
    AND (blocked_until IS NULL OR blocked_until <= UTC_TIMESTAMP(3))`,
    [scope.principal, scope.source],
  );
  await connection.execute(
    `INSERT INTO auth_failures (principal_digest, source_digest, window_start, count)
    VALUES (?, ?, UTC_TIMESTAMP(3), 1) ON DUPLICATE KEY UPDATE count = count + 1`,
    [scope.principal, scope.source],
  );
  await connection.execute(
    `UPDATE auth_failures SET blocked_until = UTC_TIMESTAMP(3) + INTERVAL 15 MINUTE
    WHERE principal_digest = ? AND source_digest = ? AND count >= 5`,
    [scope.principal, scope.source],
  );
}
