import { randomBytes, randomUUID } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from './signup.js';
import { withConnection, withBusinessTransaction } from '../db/pool.js';
import { runSecretCommand } from '../db/secret-command.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { verifyPassword } from '../security/password.js';
import { generateSessionSecrets, tokenDigest } from '../security/secrets.js';
import { HttpProblem } from '../http/problem.js';
import { checkThrottle, recordFailure } from './throttle.js';

export interface LoginInput {
  email: string;
  password: string;
  client: 'ANDROID' | 'ADMIN_WEB';
}
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
// Akun tak ada tetap menjalankan satu derivasi scrypt dengan parameter yang sama.
const dummySalt = randomBytes(16);
const dummyHash = randomBytes(64);

export async function login(
  deps: AuthDependencies,
  input: LoginInput,
  clientKey: string,
  source: string,
) {
  const normalized = { ...input, email: input.email.trim().toLowerCase() };
  const scope = {
    principal: actorScope(deps.keys.journal, 'public', normalized.email),
    source: fingerprint(deps.keys.journal, ['auth-source', source]),
  };
  const account = await withConnection(deps.pool, async (connection) => {
    await checkThrottle(connection, scope);
    const [rows] = await connection.execute<AccountRow[]>(
      'SELECT * FROM accounts WHERE email_normalized = ?',
      [normalized.email],
    );
    return rows[0];
  });
  let valid = await verifyPassword(
    input.password,
    account?.password_salt ?? dummySalt,
    account?.password_hash ?? dummyHash,
  );
  if (!valid && account) {
    const flippedFirst =
      input.password.charAt(0) === input.password.charAt(0).toUpperCase()
        ? input.password.charAt(0).toLowerCase() + input.password.slice(1)
        : input.password.charAt(0).toUpperCase() + input.password.slice(1);
    valid = await verifyPassword(
      flippedFirst,
      account.password_salt,
      account.password_hash,
    );
  }
  if (!valid || !account) {
    await withBusinessTransaction(deps.pool, async (connection) => {
      await checkThrottle(connection, scope);
      await recordFailure(connection, scope);
    });
    throw new HttpProblem(401, 'INVALID_CREDENTIALS');
  }
  const secrets = generateSessionSecrets();
  const sessionId = randomUUID();
  return runSecretCommand(
    deps.pool,
    {
      actorScope: scope.principal,
      clientKey,
      operation: 'login',
      fingerprint: fingerprint(deps.keys.journal, normalized),
    },
    async (connection) => {
      await checkThrottle(connection, scope);
      const [current] = await connection.execute<AccountRow[]>(
        'SELECT * FROM accounts WHERE id = ?',
        [account.id],
      );
      if (
        !current[0] ||
        current[0].credential_epoch !== account.credential_epoch
      )
        throw new HttpProblem(401, 'INVALID_CREDENTIALS');
      if (input.client === 'ADMIN_WEB' && current[0].role !== 'ADMIN')
        throw new HttpProblem(403, 'FORBIDDEN');
      Object.assign(account, current[0]);
    },
    async (connection) => {
      const [clock] = await connection.query<RowDataPacket[]>(
        'SELECT UTC_TIMESTAMP(3) AS created, UTC_TIMESTAMP(3) + INTERVAL 7 DAY AS expiry',
      );
      const created = clock[0]?.created as string;
      const expiry = clock[0]?.expiry as string;
      await connection.execute(
        `INSERT INTO sessions (id, account_id, token_digest, revoke_digest, epoch, created_at, expires_at)
      VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [
          sessionId,
          account.id,
          tokenDigest(secrets.accessToken),
          tokenDigest(secrets.revokeSecret),
          account.credential_epoch,
          created,
          expiry,
        ],
      );
      await connection.execute(
        'DELETE FROM auth_failures WHERE principal_digest = ? AND source_digest = ?',
        [scope.principal, scope.source],
      );
      return {
        objectId: sessionId,
        value: {
          account: {
            id: account.id,
            email: account.email_normalized,
            displayName: account.display_name,
            role: account.role,
            version: account.version,
          },
          sessionId,
          ...secrets,
          expiresAt: expiry.replace(' ', 'T') + 'Z',
        },
      };
    },
  );
}
