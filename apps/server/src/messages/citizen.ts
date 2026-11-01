/**
 * Logika Kotak Masuk (Inbox) Warga SiagaBanjir
 * Menangani pembacaan inbox dengan filter pesan aktif, perhitungan status baca/belum baca
 * berdasarkan versi konten (SRS-FR-INBOX-002), dan penandaan pesan dibaca (markRead).
 */
import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction, withConnection } from '../db/pool.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { encodeCursor, decodeCursor } from '../security/cursor.js';
import { HttpProblem } from '../http/problem.js';
import {
  formatMessage,
  type InboxItem,
  type InboxItemPage,
  type MessageRow,
  type ReadResult,
} from './types.js';

/**
 * Membaca daftar pesan kotak masuk warga yang aktif dan belum kedaluwarsa.
 * Status read dihitung true jika warga sudah membaca content_version yang sama atau lebih baru.
 */
export async function listInbox(
  deps: AuthDependencies,
  userId: string,
  query: { cursor?: string; q?: string },
): Promise<InboxItemPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      userId,
      'user-inbox',
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const params: (string | number)[] = [userId];
    let sql = `
      SELECT m.*,
        r.account_id as read_account_id
      FROM messages m
      LEFT JOIN message_reads r ON m.id = r.message_id AND r.account_id = ? AND r.content_version >= m.content_version
      WHERE m.state = 'ACTIVE' AND (m.ends_at IS NULL OR m.ends_at > UTC_TIMESTAMP(3))
    `;

    if (filter) {
      sql += ' AND (m.title LIKE ? OR m.body LIKE ?)';
      params.push(`%${filter}%`, `%${filter}%`);
    }

    if (lastId) {
      sql += ' AND m.id < ?';
      params.push(lastId);
    }

    sql += ' ORDER BY m.published_at DESC, m.id DESC LIMIT 21';

    const [rows] = await connection.execute<MessageRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items: InboxItem[] = pageRows.map((r) => ({
      message: formatMessage(r),
      read: Boolean(r.read_account_id),
    }));

    let nextCursor: string | null = null;
    const lastItem = items[items.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: userId,
        domain: 'user-inbox',
        filter: filter || 'default',
        lastId: lastItem.message.id,
      });
    }

    return {
      items,
      nextCursor,
      serverTime: new Date().toISOString(),
      revision: null,
    };
  });
}

/**
 * Menandai pesan telah dibaca oleh akun warga pada versi konten tertentu (Idempotent).
 */
export async function markRead(
  deps: AuthDependencies,
  userId: string,
  clientKey: string,
  messageId: string,
  input: { contentVersion: number },
): Promise<ReadResult> {
  if (input.contentVersion < 1) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', userId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'markRead',
    messageId,
    contentVersion: input.contentVersion,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // 1. Cek replay idempotensi
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'markRead' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [msgRows] = await connection.execute<MessageRow[]>(
        'SELECT * FROM messages WHERE id = ?',
        [messageId],
      );
      const curr = msgRows[0] ? Number(msgRows[0].content_version) : 1;
      return {
        messageId,
        recordedVersion: input.contentVersion,
        currentContentVersion: curr,
        readCurrent: input.contentVersion >= curr,
      };
    }

    // 2. Validasi keberadaan pesan
    const [rows] = await connection.execute<MessageRow[]>(
      'SELECT id, content_version FROM messages WHERE id = ?',
      [messageId],
    );
    const message = rows[0];
    if (!message) throw new HttpProblem(404, 'NOT_FOUND');

    // 3. Catat versi baca ke tabel message_reads
    await connection.execute(
      `INSERT INTO message_reads (account_id, message_id, content_version, read_at)
        VALUES (?, ?, ?, UTC_TIMESTAMP(3))
        ON DUPLICATE KEY UPDATE read_at = UTC_TIMESTAMP(3)`,
      [userId, messageId, input.contentVersion],
    );

    // 4. Catat riwayat perintah idempotensi
    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'markRead', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, messageId],
    );

    const curr = Number(message.content_version);
    return {
      messageId,
      recordedVersion: input.contentVersion,
      currentContentVersion: curr,
      readCurrent: input.contentVersion >= curr,
    };
  });
}
