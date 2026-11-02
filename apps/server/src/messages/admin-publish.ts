/**
 * Logika Penerbitan Pesan Siaran Admin SiagaBanjir
 * Menangani validasi konten, fingerprint idempotensi, dan penyimpanan data pesan ke database.
 */
import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction } from '../db/pool.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { HttpProblem } from '../http/problem.js';
import {
  formatMessage,
  type Message,
  type MessageCreate,
  type MessageRow,
} from './types.js';

/**
 * Menerbitkan pesan siaran baru oleh admin dengan jaminan idempotensi.
 */
export async function publishMessage(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  input: MessageCreate,
): Promise<Message> {
  const title = input.title.normalize('NFC').trim();
  const body = input.body.normalize('NFC').trim();
  const severity = input.severity ?? 'INFO';

  // Validasi batas panjang teks judul dan isi pesan
  if (!title || title.length < 1 || title.length > 120) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (!body || body.length < 1 || body.length > 3000) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (!['INFO', 'WARNING', 'CRITICAL'].includes(severity)) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (input.endsAt) {
    const d = new Date(input.endsAt);
    if (Number.isNaN(d.getTime())) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }

  // Hitung fingerprint idempotensi perintah
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'publishMessage',
    title,
    body,
    severity,
    endsAt: input.endsAt ?? null,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // 1. Periksa riwayat idempotensi sebelumnya
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint, object_id FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'publishMessage' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<MessageRow[]>(
        'SELECT * FROM messages WHERE id = ?',
        [previousCmd[0].object_id as string],
      );
      if (existing[0]) return formatMessage(existing[0]);
    }

    // 2. Simpan pesan baru ke dalam tabel messages
    const messageId = randomUUID();
    const endsAtSql = input.endsAt
      ? new Date(input.endsAt).toISOString().slice(0, 23).replace('T', ' ')
      : null;

    await connection.execute(
      `INSERT INTO messages (id, title, body, severity, published_at, ends_at, state, content_version, version, created_at, updated_at)
        VALUES (?, ?, ?, ?, UTC_TIMESTAMP(3), ?, 'ACTIVE', 1, 1, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [messageId, title, body, severity, endsAtSql],
    );

    // 3. Catat bukti transaksi ke tabel commands
    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'publishMessage', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, messageId],
    );

    const [rows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ?',
      [messageId],
    );
    return formatMessage(rows[0]!);
  });
}
