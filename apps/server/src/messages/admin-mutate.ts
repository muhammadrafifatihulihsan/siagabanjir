/**
 * Logika Mutasi Pesan Admin SiagaBanjir
 * Menangani pembaruan pesan dengan If-Match ETag (aturan SRS-FR-INBOX-002),
 * pencabutan pesan (revoke), dan pengakhiran masa berlaku (expire).
 */
import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction } from '../db/pool.js';
import {
  actorScope,
  fingerprint,
  type JsonValue,
} from '../security/fingerprint.js';
import { HttpProblem } from '../http/problem.js';
import {
  formatMessage,
  type Message,
  type MessageRow,
  type MessageUpdate,
} from './types.js';

/**
 * Memperbarui pesan admin dengan kontrol konkurensi optimistik If-Match.
 * Menaikkan content_version jika title/body berubah (SRS-FR-INBOX-002).
 */
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
    if (!t || t.length < 1 || t.length > 120)
      throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (input.body !== undefined) {
    const b = input.body.normalize('NFC').trim();
    if (!b || b.length < 1 || b.length > 3000)
      throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (input.endsAt) {
    const d = new Date(input.endsAt);
    if (Number.isNaN(d.getTime()))
      throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (
    input.severity !== undefined &&
    !['INFO', 'WARNING', 'CRITICAL'].includes(input.severity)
  ) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'editMessage',
    messageId,
    ifMatch: expectedVersion,
    input: input as unknown as JsonValue,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // 1. Periksa replay idempotensi
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

    // 2. Kunci baris pesan dan validasi If-Match ETag
    const [rows] = await connection.execute<MessageRow[]>(
      'SELECT * FROM messages WHERE id = ? FOR UPDATE',
      [messageId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    if (Number(row.version) !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, Number(row.version));
    }

    // 3. Hitung versi konten baru jika ada perubahan teks judul atau isi
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

    const newSeverity = input.severity ?? row.severity;

    await connection.execute(
      `UPDATE messages
        SET title = ?, body = ?, severity = ?, ends_at = ?, content_version = ?, version = ?, updated_at = UTC_TIMESTAMP(3)
        WHERE id = ?`,
      [
        newTitle,
        newBody,
        newSeverity,
        endsAtSql,
        newContentVersion,
        newVersion,
        messageId,
      ],
    );

    // 4. Catat riwayat perintah idempotensi
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

/**
 * Mencabut pesan siaran admin (state menjadi REVOKED).
 */
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

/**
 * Mengakhiri masa berlaku pesan siaran admin (state menjadi EXPIRED).
 */
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
