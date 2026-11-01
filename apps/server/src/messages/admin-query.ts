/**
 * Logika Pembacaan Pesan Admin SiagaBanjir
 * Menangani pembacaan daftar pesan siaran admin dengan cursor pagination dan detail pesan.
 */
import type { AuthDependencies } from '../auth/signup.js';
import { withConnection } from '../db/pool.js';
import { encodeCursor, decodeCursor } from '../security/cursor.js';
import { HttpProblem } from '../http/problem.js';
import {
  formatMessage,
  type Message,
  type MessagePage,
  type MessageRow,
} from './types.js';

/**
 * Membaca daftar pesan untuk admin dengan filter pencarian dan pagination cursor.
 */
export async function listMessagesAdmin(
  deps: AuthDependencies,
  adminId: string,
  query: { cursor?: string; q?: string },
): Promise<MessagePage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      adminId,
      'admin-messages',
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const params: string[] = [];
    let sql = 'SELECT * FROM messages WHERE 1=1';

    if (filter) {
      sql += ' AND (title LIKE ? OR body LIKE ?)';
      params.push(`%${filter}%`, `%${filter}%`);
    }

    if (lastId) {
      sql += ' AND id < ?';
      params.push(lastId);
    }

    sql += ' ORDER BY published_at DESC, id DESC LIMIT 21';

    const [rows] = await connection.execute<MessageRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items = pageRows.map(formatMessage);
    let nextCursor: string | null = null;
    const lastItem = items[items.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: adminId,
        domain: 'admin-messages',
        filter: filter || 'default',
        lastId: lastItem.id,
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
 * Membaca detail pesan admin berdasarkan ID pesan.
 */
export async function getMessageAdmin(
  deps: AuthDependencies,
  messageId: string,
): Promise<Message> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ?',
      [messageId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    return formatMessage(row);
  });
}
