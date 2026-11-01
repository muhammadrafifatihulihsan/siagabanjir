/**
 * CRUD Konten Edukasi Admin SiagaBanjir
 * Menangani pembacaan daftar konten untuk admin, pembuatan draf, pembaruan draf,
 * serta penghapusan draf (tidak diizinkan menghapus konten yang sedang berstatus PUBLISHED).
 */
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
import {
  normalizeKind,
  normalizeAdminKindEnum,
  parseJsonField,
  type ContentAdmin,
  type ContentAdminPage,
  type ContentInput,
  type ContentItem,
  type ContentItemRow,
} from './types.js';

/**
 * Membaca daftar item konten untuk admin berdasarkan jenis (contacts, guides, catalog).
 */
export async function listContentAdmin(
  deps: AuthDependencies,
  adminId: string,
  rawKind: string,
  query: { cursor?: string; q?: string },
): Promise<ContentAdminPage> {
  const kind = normalizeKind(rawKind);
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      adminId,
      `admin-content-${kind}`,
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const params: string[] = [kind];
    let sql = 'SELECT * FROM content_items WHERE kind = ?';

    if (lastId) {
      sql += ' AND id < ?';
      params.push(lastId);
    }

    sql += ' ORDER BY created_at DESC, id DESC LIMIT 21';

    const [rows] = await connection.execute<ContentItemRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items: ContentAdmin[] = pageRows.map((r) => ({
      id: r.id,
      kind: normalizeAdminKindEnum(r.kind),
      version: Number(r.version),
      state: r.state,
      draft: parseJsonField<ContentInput>(r.draft_json),
      published: r.published_json
        ? parseJsonField<ContentItem>(r.published_json)
        : null,
    }));

    let nextCursor: string | null = null;
    const lastItem = items[items.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: adminId,
        domain: `admin-content-${kind}`,
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
 * Membuat draf konten baru oleh admin dengan jaminan idempotensi.
 */
export async function createContentDraft(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  rawKind: string,
  input: ContentInput,
): Promise<ContentAdmin> {
  const kind = normalizeKind(rawKind);
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'createContentDraft',
    kind,
    input: input as unknown as JsonValue,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint, object_id FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'createContentDraft' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<ContentItemRow[]>(
        'SELECT * FROM content_items WHERE id = ?',
        [previousCmd[0].object_id as string],
      );
      if (existing[0]) {
        return {
          id: existing[0].id,
          kind: normalizeAdminKindEnum(existing[0].kind),
          version: Number(existing[0].version),
          state: existing[0].state,
          draft: parseJsonField<ContentInput>(existing[0].draft_json),
          published: existing[0].published_json
            ? parseJsonField<ContentItem>(existing[0].published_json)
            : null,
        };
      }
    }

    const contentId = randomUUID();
    await connection.execute(
      `INSERT INTO content_items (id, kind, draft_json, published_json, state, version, created_at, updated_at)
       VALUES (?, ?, ?, NULL, 'DRAFT', 1, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [contentId, kind, JSON.stringify(input)],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'createContentDraft', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, contentId],
    );

    return {
      id: contentId,
      kind: normalizeAdminKindEnum(kind),
      version: 1,
      state: 'DRAFT',
      draft: input,
      published: null,
    };
  });
}

/**
 * Memperbarui data draf konten dengan kontrol versi optimistik If-Match.
 */
export async function updateContentDraft(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  rawKind: string,
  contentId: string,
  expectedVersion: number,
  input: ContentInput,
): Promise<ContentAdmin> {
  const kind = normalizeKind(rawKind);
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'updateContentDraft',
    kind,
    contentId,
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
        previousCmd[0].operation !== 'updateContentDraft' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<ContentItemRow[]>(
        'SELECT * FROM content_items WHERE id = ?',
        [contentId],
      );
      if (existing[0]) {
        return {
          id: existing[0].id,
          kind: normalizeAdminKindEnum(existing[0].kind),
          version: Number(existing[0].version),
          state: existing[0].state,
          draft: parseJsonField<ContentInput>(existing[0].draft_json),
          published: existing[0].published_json
            ? parseJsonField<ContentItem>(existing[0].published_json)
            : null,
        };
      }
    }

    const [rows] = await connection.execute<ContentItemRow[]>(
      'SELECT * FROM content_items WHERE id = ? AND kind = ? FOR UPDATE',
      [contentId, kind],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    if (Number(row.version) !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, Number(row.version));
    }

    const newVersion = Number(row.version) + 1;
    await connection.execute(
      'UPDATE content_items SET draft_json = ?, version = ?, updated_at = UTC_TIMESTAMP(3) WHERE id = ?',
      [JSON.stringify(input), newVersion, contentId],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'updateContentDraft', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, contentId],
    );

    return {
      id: contentId,
      kind: normalizeAdminKindEnum(kind),
      version: newVersion,
      state: row.state,
      draft: input,
      published: row.published_json
        ? parseJsonField<ContentItem>(row.published_json)
        : null,
    };
  });
}

/**
 * Menghapus draf konten. Ditolak jika item sedang berstatus PUBLISHED.
 */
export async function deleteContentDraft(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  rawKind: string,
  contentId: string,
  expectedVersion: number,
): Promise<{ success: boolean }> {
  const kind = normalizeKind(rawKind);
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'deleteContentDraft',
    kind,
    contentId,
    ifMatch: expectedVersion,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'deleteContentDraft' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return { success: true };
    }

    const [rows] = await connection.execute<ContentItemRow[]>(
      'SELECT * FROM content_items WHERE id = ? AND kind = ? FOR UPDATE',
      [contentId, kind],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    if (Number(row.version) !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, Number(row.version));
    }

    if (row.state === 'PUBLISHED') {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    await connection.execute('DELETE FROM content_items WHERE id = ?', [
      contentId,
    ]);

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'deleteContentDraft', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, contentId],
    );

    return { success: true };
  });
}
