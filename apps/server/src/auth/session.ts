import type { PoolConnection, RowDataPacket } from 'mysql2/promise';
import { tokenDigest } from '../security/secrets.js';
import { HttpProblem } from '../http/problem.js';

export interface SessionRow extends RowDataPacket {
  session_id: string;
  id: string;
  display_name: string;
  email_normalized: string;
  role: 'CITIZEN' | 'ADMIN';
  version: number;
}

export async function requireSession(
  connection: PoolConnection,
  authorization: string | undefined,
): Promise<SessionRow> {
  let digest: Buffer;
  try {
    if (!authorization?.startsWith('Bearer ')) throw new Error();
    digest = tokenDigest(authorization.slice(7));
  } catch {
    throw new HttpProblem(401, 'INVALID_SESSION');
  }
  const [rows] = await connection.execute<SessionRow[]>(
    `SELECT s.id AS session_id, a.id, a.display_name, a.email_normalized, a.role, a.version
      FROM sessions s JOIN accounts a ON a.id = s.account_id
      WHERE s.token_digest = ? AND s.revoked_at IS NULL AND s.expires_at > UTC_TIMESTAMP(3)
        AND s.epoch = a.credential_epoch`,
    [digest],
  );
  if (!rows[0]) throw new HttpProblem(401, 'INVALID_SESSION');
  return rows[0];
}

export function accountView(account: SessionRow) {
  return {
    id: account.id,
    displayName: account.display_name,
    email: account.email_normalized,
    role: account.role,
    version: account.version,
  };
}
