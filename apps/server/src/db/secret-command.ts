import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { Pool, PoolConnection, RowDataPacket } from 'mysql2/promise';
import { withBusinessTransaction } from './pool.js';

export class CommandConflict extends Error {
  constructor(
    readonly code: 'IDEMPOTENCY_CONFLICT' | 'RESULT_ALREADY_COMMITTED',
  ) {
    super(code);
  }
}

interface CommandIdentity {
  actorScope: Buffer;
  clientKey: string;
  operation: 'signup' | 'login' | 'resetPassword' | 'rotateRecoveryCode';
  fingerprint: Buffer;
}

interface CommandRow extends RowDataPacket {
  operation: string;
  fingerprint: Buffer;
  state: string;
}

// Helper khusus respons rahasia. Laporan/close memiliki state machine terpisah.
// Hash/provider I/O harus selesai di luar transaksi; authorize hanya cek DB.
export async function runSecretCommand<T>(
  pool: Pool,
  identity: CommandIdentity,
  authorize: (connection: PoolConnection) => Promise<void>,
  mutate: (
    connection: PoolConnection,
  ) => Promise<{ value: T; objectId: string | null }>,
): Promise<T> {
  if (
    identity.actorScope.length !== 32 ||
    identity.fingerprint.length !== 32 ||
    !/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      identity.clientKey,
    )
  ) {
    throw new Error('Identitas command tidak valid.');
  }
  const clientKey = identity.clientKey.toLowerCase();
  return withBusinessTransaction(pool, async (connection) => {
    // Replay tetap wajib melewati autentikasi/izin dan epoch terkini.
    await authorize(connection);
    const [rows] = await connection.execute<CommandRow[]>(
      'SELECT operation, fingerprint, state FROM commands WHERE actor_scope = ? AND client_key = ?',
      [identity.actorScope, clientKey],
    );
    const previous = rows[0];
    if (previous) {
      if (
        previous.operation !== identity.operation ||
        !timingSafeEqual(previous.fingerprint, identity.fingerprint)
      ) {
        throw new CommandConflict('IDEMPOTENCY_CONFLICT');
      }
      if (previous.state !== 'COMMITTED')
        throw new Error('State command tidak didukung.');
      throw new CommandConflict('RESULT_ALREADY_COMMITTED');
    }
    const result = await mutate(connection);
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, ?, ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [
        randomUUID(),
        identity.actorScope,
        clientKey,
        identity.operation,
        identity.fingerprint,
        result.objectId,
      ],
    );
    // Token/kode tidak disimpan di jurnal; hanya dikembalikan setelah COMMIT.
    return result.value;
  });
}
