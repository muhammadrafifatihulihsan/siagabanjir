import { randomUUID } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import { readDatabaseConfig } from './config.js';
import { createDatabasePool, withConnection } from './pool.js';
import { hashPassword } from '../security/password.js';
import { readSecurityKeys } from '../security/keys.js';
import { generateRecoveryCode, recoveryVerifier } from '../security/secrets.js';

export interface SeedAccount {
  displayName: string;
  email: string;
  role: 'CITIZEN' | 'ADMIN';
  password: string;
}

export const SEED_ACCOUNTS: SeedAccount[] = [
  // Akun Petugas Admin (Format Simpel: admin1 s.d. admin5 & admin.bpbd)
  {
    displayName: 'Admin 1',
    email: 'admin1@siagabanjir.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Admin 2',
    email: 'admin2@siagabanjir.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Admin 3',
    email: 'admin3@siagabanjir.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Admin 4',
    email: 'admin4@siagabanjir.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Admin 5',
    email: 'admin5@siagabanjir.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Admin BPBD Utama',
    email: 'admin.bpbd@padang.go.id',
    role: 'ADMIN',
    password: 'Password123!',
  },

  // 10 Akun Warga (Format Simpel: warga1 s.d. warga10)
  {
    displayName: 'Warga 1',
    email: 'warga1@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 2',
    email: 'warga2@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 3',
    email: 'warga3@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 4',
    email: 'warga4@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 5',
    email: 'warga5@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 6',
    email: 'warga6@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 7',
    email: 'warga7@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 8',
    email: 'warga8@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 9',
    email: 'warga9@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Warga 10',
    email: 'warga10@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
];

export async function seedAccounts() {
  const config = readDatabaseConfig(process.env, 'app');
  const pool = createDatabasePool(config);
  const keys = readSecurityKeys(process.env);

  try {
    await withConnection(pool, async (connection) => {
      process.stdout.write(
        `Menyiapkan ${SEED_ACCOUNTS.length} akun pengujian (Warga & Admin)...\n`,
      );
      for (const account of SEED_ACCOUNTS) {
        const emailNormalized = account.email.trim().toLowerCase();
        const [existing] = await connection.execute<RowDataPacket[]>(
          'SELECT id FROM accounts WHERE email_normalized = ?',
          [emailNormalized],
        );

        // Derivasi scrypt berurutan (sequential) agar kapasitas derivasi tidak terlampaui
        const { salt, hash } = await hashPassword(account.password);
        const recoveryCode = generateRecoveryCode();
        const verifier = recoveryVerifier(recoveryCode, keys.recovery);

        if (existing.length > 0) {
          const accountId = existing[0]!.id as string;
          await connection.execute(
            `UPDATE accounts
             SET display_name = ?, role = ?, password_salt = ?, password_hash = ?, credential_epoch = credential_epoch + 1, version = version + 1
             WHERE id = ?`,
            [account.displayName, account.role, salt, hash, accountId],
          );
          await connection.execute(
            `INSERT INTO recovery_verifiers (account_id, verifier, generation)
             VALUES (?, ?, 1)
             ON DUPLICATE KEY UPDATE verifier = VALUES(verifier), generation = generation + 1, used_at = NULL`,
            [accountId, verifier],
          );
          process.stdout.write(
            `  [UPDATE] ${account.role.padEnd(7)} | ${emailNormalized.padEnd(28)} | ${account.displayName}\n`,
          );
        } else {
          const accountId = randomUUID();
          await connection.execute(
            `INSERT INTO accounts (id, email_normalized, display_name, role, password_salt, password_hash, credential_epoch, version, created_at)
             VALUES (?, ?, ?, ?, ?, ?, 1, 1, UTC_TIMESTAMP(3))`,
            [
              accountId,
              emailNormalized,
              account.displayName,
              account.role,
              salt,
              hash,
            ],
          );
          await connection.execute(
            'INSERT INTO recovery_verifiers (account_id, verifier, generation) VALUES (?, ?, 1)',
            [accountId, verifier],
          );
          process.stdout.write(
            `  [CREATE] ${account.role.padEnd(7)} | ${emailNormalized.padEnd(28)} | ${account.displayName}\n`,
          );
        }
      }
      process.stdout.write(
        '\nBerhasil melakukan seeding seluruh akun pengujian!\n',
      );
    });
  } finally {
    await pool.end();
  }
}

void seedAccounts().catch((error) => {
  process.stderr.write(
    `Gagal melakukan seed akun: ${error instanceof Error ? error.message : String(error)}\n`,
  );
  process.exitCode = 1;
});
