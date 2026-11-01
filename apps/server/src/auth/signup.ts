import { randomUUID } from 'node:crypto';
import type { Pool } from 'mysql2/promise';
import { runSecretCommand } from '../db/secret-command.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { hashPassword } from '../security/password.js';
import { generateRecoveryCode, recoveryVerifier } from '../security/secrets.js';
import type { readSecurityKeys } from '../security/keys.js';
import { HttpProblem } from '../http/problem.js';

export interface SignupInput {
  displayName: string;
  email: string;
  password: string;
}
export interface AuthDependencies {
  pool: Pool;
  keys: ReturnType<typeof readSecurityKeys>;
}

export async function signup(
  deps: AuthDependencies,
  input: SignupInput,
  clientKey: string,
) {
  const normalized = {
    ...input,
    displayName: input.displayName.trim(),
    email: input.email.trim().toLowerCase(),
  };
  if ([...normalized.displayName].length < 2)
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  const identity = {
    actorScope: actorScope(deps.keys.journal, 'public', normalized.email),
    clientKey,
    operation: 'signup' as const,
    fingerprint: fingerprint(deps.keys.journal, normalized),
  };
  const password = await hashPassword(input.password);
  const recoveryCode = generateRecoveryCode();
  const account = {
    id: randomUUID(),
    displayName: normalized.displayName,
    email: normalized.email,
    role: 'CITIZEN' as const,
    version: 1,
  };
  try {
    return await runSecretCommand(
      deps.pool,
      identity,
      () => Promise.resolve(),
      async (connection) => {
        await connection.execute(
          `INSERT INTO accounts (id, email_normalized, display_name, password_hash, password_salt, created_at)
          VALUES (?, ?, ?, ?, ?, UTC_TIMESTAMP(3))`,
          [
            account.id,
            account.email,
            account.displayName,
            password.hash,
            password.salt,
          ],
        );
        await connection.execute(
          'INSERT INTO recovery_verifiers (account_id, verifier) VALUES (?, ?)',
          [account.id, recoveryVerifier(recoveryCode, deps.keys.recovery)],
        );
        return { value: { account, recoveryCode }, objectId: account.id };
      },
    );
  } catch (error) {
    if (
      error instanceof Error &&
      'code' in error &&
      error.code === 'ER_DUP_ENTRY'
    ) {
      throw new HttpProblem(409, 'EMAIL_ALREADY_EXISTS');
    }
    throw error;
  } finally {
    password.hash.fill(0);
  }
}
