import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from './signup.js';
import { withBusinessTransaction, withConnection } from '../db/pool.js';
import { runSecretCommand } from '../db/secret-command.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { hashPassword, verifyPassword } from '../security/password.js';
import { generateRecoveryCode, recoveryVerifier } from '../security/secrets.js';
import { HttpProblem } from '../http/problem.js';

interface AccountRow extends RowDataPacket {
  id: string;
  email_normalized: string;
  display_name: string;
  role: 'CITIZEN' | 'ADMIN';
  password_hash: Buffer;
  password_salt: Buffer;
  credential_epoch: number;
  version: number;
}

export interface ProfileUpdateInput {
  displayName: string;
}

export interface CredentialsUpdateInput {
  currentPassword: string;
  email?: string;
  newPassword?: string;
}

export async function updateProfile(
  deps: AuthDependencies,
  accountId: string,
  input: ProfileUpdateInput,
  expectedVersion: number,
  clientKey: string,
) {
  const displayName = input.displayName.trim();
  const charCount = [...displayName].length;
  if (charCount < 2 || charCount > 80) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    displayName,
    ifMatch: expectedVersion,
    operation: 'updateProfile',
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previous] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previous[0]) {
      if (
        previous[0].operation !== 'updateProfile' ||
        !timingSafeEqual(previous[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [accounts] = await connection.execute<AccountRow[]>(
        'SELECT id, display_name, email_normalized, role, version FROM accounts WHERE id = ?',
        [accountId],
      );
      if (!accounts[0]) throw new HttpProblem(404, 'NOT_FOUND');
      return {
        id: accounts[0].id,
        displayName: accounts[0].display_name,
        email: accounts[0].email_normalized,
        role: accounts[0].role,
        version: accounts[0].version,
      };
    }

    const [rows] = await connection.execute<AccountRow[]>(
      'SELECT id, display_name, email_normalized, role, version FROM accounts WHERE id = ? FOR UPDATE',
      [accountId],
    );
    const current = rows[0];
    if (!current) throw new HttpProblem(404, 'NOT_FOUND');
    if (current.version !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, current.version);
    }

    await connection.execute(
      'UPDATE accounts SET display_name = ?, version = version + 1 WHERE id = ? AND version = ?',
      [displayName, accountId, expectedVersion],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'updateProfile', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, accountId],
    );

    return {
      id: current.id,
      displayName,
      email: current.email_normalized,
      role: current.role,
      version: current.version + 1,
    };
  });
}

export async function updateCredentials(
  deps: AuthDependencies,
  accountId: string,
  input: CredentialsUpdateInput,
  expectedVersion: number,
  clientKey: string,
) {
  if (!input.currentPassword) throw new HttpProblem(422, 'VALIDATION_FAILED');
  if (!input.email && !input.newPassword) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  let normalizedEmail: string | undefined;
  if (input.email !== undefined) {
    normalizedEmail = input.email.trim().toLowerCase();
    if (
      normalizedEmail.length < 3 ||
      normalizedEmail.length > 254 ||
      !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalizedEmail)
    ) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }

  if (input.newPassword !== undefined) {
    if (
      typeof input.newPassword !== 'string' ||
      input.newPassword.length < 12 ||
      input.newPassword.length > 128
    ) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    email: normalizedEmail ?? null,
    hasNewPassword: Boolean(input.newPassword),
    ifMatch: expectedVersion,
    operation: 'updateCredentials',
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previous] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previous[0]) {
      if (
        previous[0].operation !== 'updateCredentials' ||
        !timingSafeEqual(previous[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [currentAccount] = await connection.execute<AccountRow[]>(
        'SELECT version FROM accounts WHERE id = ?',
        [accountId],
      );
      return {
        actionId: previous[0].id as string,
        state: 'ALREADY_COMMITTED' as const,
        version: currentAccount[0]?.version ?? null,
      };
    }

    const [rows] = await connection.execute<AccountRow[]>(
      'SELECT id, password_hash, password_salt, credential_epoch, version FROM accounts WHERE id = ? FOR UPDATE',
      [accountId],
    );
    const current = rows[0];
    if (!current) throw new HttpProblem(404, 'NOT_FOUND');
    if (current.version !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, current.version);
    }

    const valid = await verifyPassword(
      input.currentPassword,
      current.password_salt,
      current.password_hash,
    );
    if (!valid) throw new HttpProblem(401, 'INVALID_CREDENTIALS');

    const newHashed = input.newPassword
      ? await hashPassword(input.newPassword)
      : undefined;

    try {
      if (normalizedEmail && newHashed) {
        await connection.execute(
          `UPDATE accounts
            SET email_normalized = ?, password_hash = ?, password_salt = ?,
                credential_epoch = credential_epoch + 1, version = version + 1
            WHERE id = ? AND version = ?`,
          [
            normalizedEmail,
            newHashed.hash,
            newHashed.salt,
            accountId,
            expectedVersion,
          ],
        );
      } else if (normalizedEmail) {
        await connection.execute(
          `UPDATE accounts
            SET email_normalized = ?,
                credential_epoch = credential_epoch + 1, version = version + 1
            WHERE id = ? AND version = ?`,
          [normalizedEmail, accountId, expectedVersion],
        );
      } else if (newHashed) {
        await connection.execute(
          `UPDATE accounts
            SET password_hash = ?, password_salt = ?,
                credential_epoch = credential_epoch + 1, version = version + 1
            WHERE id = ? AND version = ?`,
          [newHashed.hash, newHashed.salt, accountId, expectedVersion],
        );
      }
    } catch (error) {
      if (
        error instanceof Error &&
        'code' in error &&
        error.code === 'ER_DUP_ENTRY'
      ) {
        throw new HttpProblem(409, 'CONFLICT');
      }
      throw error;
    }

    await connection.execute(
      'UPDATE sessions SET revoked_at = COALESCE(revoked_at, UTC_TIMESTAMP(3)) WHERE account_id = ?',
      [accountId],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'updateCredentials', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, accountId],
    );

    return {
      actionId,
      state: 'COMMITTED' as const,
      version: current.version + 1,
    };
  });
}

export async function rotateRecoveryCode(
  deps: AuthDependencies,
  accountId: string,
  currentPassword: string,
  clientKey: string,
) {
  const account = await withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<AccountRow[]>(
      'SELECT id, password_hash, password_salt, credential_epoch FROM accounts WHERE id = ?',
      [accountId],
    );
    return rows[0];
  });
  if (!account) throw new HttpProblem(404, 'NOT_FOUND');

  const valid = await verifyPassword(
    currentPassword,
    account.password_salt,
    account.password_hash,
  );
  if (!valid) throw new HttpProblem(401, 'INVALID_CREDENTIALS');

  const recoveryCode = generateRecoveryCode();
  const verifier = recoveryVerifier(recoveryCode, deps.keys.recovery);

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const identity = {
    actorScope: scope,
    clientKey,
    operation: 'rotateRecoveryCode' as const,
    fingerprint: fingerprint(deps.keys.journal, {
      operation: 'rotateRecoveryCode',
    }),
  };

  return runSecretCommand(
    deps.pool,
    identity,
    async (connection) => {
      const [rows] = await connection.execute<AccountRow[]>(
        'SELECT credential_epoch FROM accounts WHERE id = ? FOR UPDATE',
        [accountId],
      );
      if (!rows[0] || rows[0].credential_epoch !== account.credential_epoch) {
        throw new HttpProblem(401, 'INVALID_CREDENTIALS');
      }
    },
    async (connection) => {
      await connection.execute(
        'UPDATE recovery_verifiers SET verifier = ?, generation = generation + 1, used_at = NULL WHERE account_id = ?',
        [verifier, accountId],
      );
      return { value: { recoveryCode }, objectId: accountId };
    },
  );
}
