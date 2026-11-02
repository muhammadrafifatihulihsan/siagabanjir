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
  // 5 Akun Petugas Admin BPBD / Posko Lapangan
  {
    displayName: 'Admin BPBD Utama',
    email: 'admin.bpbd@padang.go.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Petugas Posko Kuranji',
    email: 'admin.kuranji@padang.go.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Petugas Posko Koto Tangah',
    email: 'admin.koto@padang.go.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Petugas Posko Nanggalo',
    email: 'admin.nanggalo@padang.go.id',
    role: 'ADMIN',
    password: 'Password123!',
  },
  {
    displayName: 'Operator Pusdalops PB',
    email: 'admin.pusdalops@padang.go.id',
    role: 'ADMIN',
    password: 'Password123!',
  },

  // 10 Akun Warga Terdaftar
  {
    displayName: 'Budi Santoso',
    email: 'warga1@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Siti Rahmawati',
    email: 'warga2@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Ahmad Fauzi',
    email: 'warga3@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Dewi Lestari',
    email: 'warga4@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Rizky Pratama',
    email: 'warga5@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Nurul Hidayah',
    email: 'warga6@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Hendra Wijaya',
    email: 'warga7@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Fitri Handayani',
    email: 'warga8@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Eko Prasetyo',
    email: 'warga9@siagabanjir.id',
    role: 'CITIZEN',
    password: 'Password123!',
  },
  {
    displayName: 'Rina Marlina',
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
        `Menyiapkan ${SEED_ACCOUNTS.length} akun pengujian (10 Warga & 5 Admin)...\n`,
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
        '\nBerhasil melakukan seeding seluruh 15 akun pengujian!\n',
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
