import { randomBytes, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from './signup.js';
import { withConnection, withBusinessTransaction } from '../db/pool.js';
import { CommandConflict, runSecretCommand } from '../db/secret-command.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { hashPassword } from '../security/password.js';
import {
  generateRecoveryCode,
  recoveryVerifier,
  matchesVerifier,
} from '../security/secrets.js';
import { checkThrottle, recordFailure } from './throttle.js';
import { HttpProblem } from '../http/problem.js';

export interface ResetPasswordInput {
  email: string;
  code: string;
  newPassword: string;
}

interface AccountRecoveryRow extends RowDataPacket {
  id: string;
  credential_epoch: number;
  version: number;
  verifier: Buffer;
  generation: number;
  used_at: string | null;
}

const dummyCode = 'A'.repeat(32);
const dummyTarget = randomBytes(32);

export async function resetPassword(
  deps: AuthDependencies,
  input: ResetPasswordInput,
  clientKey: string,
  source: string,
) {
  const normalizedEmail = input.email.trim().toLowerCase();
  const normalizedCode = input.code.trim().toUpperCase();

  if (!/^[A-Z2-7]{32}$/.test(normalizedCode)) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (
    typeof input.newPassword !== 'string' ||
    input.newPassword.length < 12 ||
    input.newPassword.length > 128
  ) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = {
    principal: actorScope(deps.keys.journal, 'public', normalizedEmail),
    source: fingerprint(deps.keys.journal, ['auth-source', source]),
  };
  const identity = {
    actorScope: scope.principal,
    clientKey,
    operation: 'resetPassword' as const,
    fingerprint: fingerprint(deps.keys.journal, {
      email: normalizedEmail,
      operation: 'resetPassword',
    }),
  };

  const row = await withConnection(deps.pool, async (connection) => {
    await checkThrottle(connection, scope);
    const [previous] = await connection.execute<RowDataPacket[]>(
      'SELECT operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [identity.actorScope, clientKey.toLowerCase()],
    );
    if (previous[0]) {
      if (
        previous[0].operation !== identity.operation ||
        !timingSafeEqual(
          previous[0].fingerprint as Buffer,
          identity.fingerprint,
        )
      ) {
        throw new CommandConflict('IDEMPOTENCY_CONFLICT');
      }
      throw new CommandConflict('RESULT_ALREADY_COMMITTED');
    }

    const [rows] = await connection.execute<AccountRecoveryRow[]>(
      `SELECT a.id, a.credential_epoch, a.version, r.verifier, r.generation, r.used_at
       FROM accounts a
       JOIN recovery_verifiers r ON r.account_id = a.id
       WHERE a.email_normalized = ?`,
      [normalizedEmail],
    );
    return rows[0];
  });

  const dummyCandidate = recoveryVerifier(dummyCode, deps.keys.recovery);
  const candidateVerifier = row
    ? recoveryVerifier(normalizedCode, deps.keys.recovery)
    : dummyCandidate;

  const valid =
    row && !row.used_at && matchesVerifier(candidateVerifier, row.verifier);

  if (!valid || !row) {
    matchesVerifier(dummyCandidate, dummyTarget);
    await withBusinessTransaction(deps.pool, async (connection) => {
      await checkThrottle(connection, scope);
      await recordFailure(connection, scope);
    });
    throw new HttpProblem(401, 'INVALID_CREDENTIALS');
  }

  const nextRecoveryCode = generateRecoveryCode();
  const nextVerifier = recoveryVerifier(nextRecoveryCode, deps.keys.recovery);
  const newHashed = await hashPassword(input.newPassword);

  return runSecretCommand(
    deps.pool,
    identity,
    async (connection) => {
      await checkThrottle(connection, scope);
      const [rows] = await connection.execute<AccountRecoveryRow[]>(
        `SELECT a.id, a.credential_epoch, r.generation, r.used_at
         FROM accounts a
         JOIN recovery_verifiers r ON r.account_id = a.id
         WHERE a.id = ? FOR UPDATE`,
        [row.id],
      );
      const current = rows[0];
      if (
        !current ||
        current.generation !== row.generation ||
        current.used_at !== null ||
        current.credential_epoch !== row.credential_epoch
      ) {
        throw new HttpProblem(401, 'INVALID_CREDENTIALS');
      }
    },
    async (connection) => {
      await connection.execute(
        `UPDATE accounts
         SET password_hash = ?, password_salt = ?,
             credential_epoch = credential_epoch + 1, version = version + 1
         WHERE id = ?`,
        [newHashed.hash, newHashed.salt, row.id],
      );
      await connection.execute(
        'UPDATE recovery_verifiers SET verifier = ?, generation = generation + 1, used_at = NULL WHERE account_id = ?',
        [nextVerifier, row.id],
      );
      await connection.execute(
        'UPDATE sessions SET revoked_at = COALESCE(revoked_at, UTC_TIMESTAMP(3)) WHERE account_id = ?',
        [row.id],
      );
      return { value: { recoveryCode: nextRecoveryCode }, objectId: row.id };
    },
  );
}
