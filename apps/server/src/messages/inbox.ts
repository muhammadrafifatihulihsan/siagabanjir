import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction, withConnection } from '../db/pool.js';
import {
  actorScope,
  fingerprint,
  type JsonValue,
} from '../security/fingerprint.js';
import { encodeCursor, decodeCursor } from '../security/cursor.js';
import { HttpProblem } from '../http/problem.js';

export interface Message {
  id: string;
  title: string;
  body: string;
  publishedAt: string;
  updatedAt: string;
  endsAt: string | null;
  state: 'ACTIVE' | 'REVOKED' | 'EXPIRED';
  contentVersion: number;
  version: number;
}

export interface MessageCreate {
  title: string;
  body: string;
  endsAt: string | null;
}

export interface MessageUpdate {
  title?: string;
  body?: string;
  endsAt?: string | null;
}

export interface MessagePage {
  items: Message[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface InboxItem {
  message: Message;
  read: boolean;
}

export interface InboxItemPage {
  items: InboxItem[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface ReadResult {
  messageId: string;
  recordedVersion: number;
  currentContentVersion: number;
  readCurrent: boolean;
}

interface MessageRow extends RowDataPacket {
  id: string;
  title: string;
  body: string;
  published_at: string | Date;
  ends_at: string | Date | null;
  state: 'ACTIVE' | 'REVOKED' | 'EXPIRED';
  content_version: number;
  version: number;
  created_at: string | Date;
  updated_at: string | Date;
  read_account_id?: string | null;
}

function formatDate(val: string | Date | null | undefined): string | null {
  if (!val) return null;
  return new Date(val).toISOString();
}

function formatMessage(row: MessageRow): Message {
  return {
    id: row.id,
    title: row.title,
    body: row.body,
    publishedAt: new Date(row.published_at).toISOString(),
    updatedAt: new Date(row.updated_at).toISOString(),
    endsAt: formatDate(row.ends_at),
    state: row.state,
    contentVersion: Number(row.content_version),
    version: Number(row.version),
  };
}

// 1. POST /admin/messages (publishMessage)
export async function publishMessage(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  input: MessageCreate,
): Promise<Message> {
  const title = input.title.normalize('NFC').trim();
  const body = input.body.normalize('NFC').trim();
  if (!title || title.length < 1 || title.length > 120) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (!body || body.length < 1 || body.length > 3000) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (input.endsAt) {
    const d = new Date(input.endsAt);
    if (Number.isNaN(d.getTime())) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }

  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'publishMessage',
    title,
    body,
    endsAt: input.endsAt ?? null,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
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

    const messageId = randomUUID();
    const endsAtSql = input.endsAt
      ? new Date(input.endsAt).toISOString().slice(0, 23).replace('T', ' ')
      : null;

    await connection.execute(
      `INSERT INTO messages (id, title, body, published_at, ends_at, state, content_version, version, created_at, updated_at)
       VALUES (?, ?, ?, UTC_TIMESTAMP(3), ?, 'ACTIVE', 1, 1, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [messageId, title, body, endsAtSql],
    );

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

// 2. GET /admin/messages (listMessagesAdmin)
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

// 3. GET /admin/messages/:messageId (getMessageAdmin)
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

// 4. PATCH /admin/messages/:messageId (editMessage)
export async function editMessage(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  messageId: string,
  expectedVersion: number,
  input: MessageUpdate,
): Promise<Message> {
  if (input.title !== undefined) {
    const t = input.title.normalize('NFC').trim();
    if (!t || t.length < 1 || t.length > 120) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }
  if (input.body !== undefined) {
    const b = input.body.normalize('NFC').trim();
    if (!b || b.length < 1 || b.length > 3000) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }
  if (input.endsAt) {
    const d = new Date(input.endsAt);
    if (Number.isNaN(d.getTime())) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
  }

  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'editMessage',
    messageId,
    ifMatch: expectedVersion,
    input: input as unknown as JsonValue,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'editMessage' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<MessageRow[]>(
        'SELECT * FROM messages WHERE id = ?',
        [messageId],
      );
      if (existing[0]) return formatMessage(existing[0]);
    }

    const [rows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ? FOR UPDATE',
      [messageId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    if (Number(row.version) !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, Number(row.version));
    }

    const newTitle =
      input.title !== undefined
        ? input.title.normalize('NFC').trim()
        : row.title;
    const newBody =
      input.body !== undefined ? input.body.normalize('NFC').trim() : row.body;
    const isContentChanged = newTitle !== row.title || newBody !== row.body;

    const newContentVersion = isContentChanged
      ? Number(row.content_version) + 1
      : Number(row.content_version);
    const newVersion = Number(row.version) + 1;

    const endsAtSql =
      input.endsAt !== undefined
        ? input.endsAt
          ? new Date(input.endsAt).toISOString().slice(0, 23).replace('T', ' ')
          : null
        : row.ends_at
          ? new Date(row.ends_at).toISOString().slice(0, 23).replace('T', ' ')
          : null;

    await connection.execute(
      `UPDATE messages
       SET title = ?, body = ?, ends_at = ?, content_version = ?, version = ?, updated_at = UTC_TIMESTAMP(3)
       WHERE id = ?`,
      [newTitle, newBody, endsAtSql, newContentVersion, newVersion, messageId],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'editMessage', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, messageId],
    );

    const [updatedRows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ?',
      [messageId],
    );
    return formatMessage(updatedRows[0]!);
  });
}

// 5. POST /admin/messages/:messageId/revoke (revokeMessage)
export async function revokeMessage(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  messageId: string,
  expectedVersion: number,
): Promise<Message> {
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'revokeMessage',
    messageId,
    ifMatch: expectedVersion,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'revokeMessage' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<MessageRow[]>(
        'SELECT * FROM messages WHERE id = ?',
        [messageId],
      );
      if (existing[0]) return formatMessage(existing[0]);
    }

    const [rows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ? FOR UPDATE',
      [messageId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    if (Number(row.version) !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, Number(row.version));
    }

    const newVersion = Number(row.version) + 1;
    await connection.execute(
      "UPDATE messages SET state = 'REVOKED', version = ?, updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
      [newVersion, messageId],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'revokeMessage', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, messageId],
    );

    const [updatedRows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ?',
      [messageId],
    );
    return formatMessage(updatedRows[0]!);
  });
}

// 6. POST /admin/messages/:messageId/expire (expireMessage)
export async function expireMessage(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  messageId: string,
  expectedVersion: number,
): Promise<Message> {
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'expireMessage',
    messageId,
    ifMatch: expectedVersion,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'expireMessage' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<MessageRow[]>(
        'SELECT * FROM messages WHERE id = ?',
        [messageId],
      );
      if (existing[0]) return formatMessage(existing[0]);
    }

    const [rows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ? FOR UPDATE',
      [messageId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    if (Number(row.version) !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, Number(row.version));
    }

    const newVersion = Number(row.version) + 1;
    await connection.execute(
      "UPDATE messages SET state = 'EXPIRED', ends_at = UTC_TIMESTAMP(3), version = ?, updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
      [newVersion, messageId],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'expireMessage', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, messageId],
    );

    const [updatedRows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ?',
      [messageId],
    );
    return formatMessage(updatedRows[0]!);
  });
}

// 7. GET /me/inbox (listInbox)
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

// 8. PUT /me/inbox/:messageId/read (markRead)
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

    const [rows] = await connection.execute<MessageRow[]>(
      'SELECT id, content_version FROM messages WHERE id = ?',
      [messageId],
    );
    const message = rows[0];
    if (!message) throw new HttpProblem(404, 'NOT_FOUND');

    await connection.execute(
      `INSERT INTO message_reads (account_id, message_id, content_version, read_at)
       VALUES (?, ?, ?, UTC_TIMESTAMP(3))
       ON DUPLICATE KEY UPDATE read_at = UTC_TIMESTAMP(3)`,
      [userId, messageId, input.contentVersion],
    );

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
