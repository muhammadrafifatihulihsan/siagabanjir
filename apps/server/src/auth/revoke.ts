import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from './signup.js';
import { requireSession } from './session.js';
import { withBusinessTransaction } from '../db/pool.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { tokenDigest } from '../security/secrets.js';
import { HttpProblem } from '../http/problem.js';

export async function revokeSession(
  deps: AuthDependencies,
  key: string,
  proof:
    | { authorization: string | undefined }
    | { sessionId: string; revokeSecret: string },
) {
  return withBusinessTransaction(deps.pool, async (connection) => {
    let sessionId: string;
    let accountId: string;
    const operation =
      'authorization' in proof ? 'logout' : 'revokeOfflineSession';
    if ('authorization' in proof) {
      const session = await requireSession(connection, proof.authorization);
      sessionId = session.session_id;
      accountId = session.id;
    } else {
      let digest: Buffer;
      try {
        digest = tokenDigest(proof.revokeSecret);
      } catch {
        throw new HttpProblem(401, 'INVALID_SESSION');
      }
      const [rows] = await connection.execute<RowDataPacket[]>(
        'SELECT account_id FROM sessions WHERE id = ? AND revoke_digest = ?',
        [proof.sessionId.toLowerCase(), digest],
      );
      if (!rows[0]) throw new HttpProblem(401, 'INVALID_SESSION');
      sessionId = proof.sessionId.toLowerCase();
      accountId = rows[0].account_id as string;
    }
    const scope = actorScope(deps.keys.journal, 'account', accountId);
    const hash = fingerprint(deps.keys.journal, { sessionId, operation });
    const [previous] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, key],
    );
    if (previous[0]) {
      if (
        previous[0].operation !== operation ||
        !timingSafeEqual(previous[0].fingerprint as Buffer, hash)
      )
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      return {
        actionId: previous[0].id as string,
        state: 'ALREADY_COMMITTED',
        version: null,
      };
    }
    const actionId = randomUUID();
    await connection.execute(
      'UPDATE sessions SET revoked_at = COALESCE(revoked_at, UTC_TIMESTAMP(3)) WHERE id = ?',
      [sessionId],
    );
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
      VALUES (?, ?, ?, ?, ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, key, operation, hash, sessionId],
    );
    return { actionId, state: 'COMMITTED', version: null };
  });
}
