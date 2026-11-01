/**
 * Publikasi dan Penarikan Konten Edukasi SiagaBanjir
 * Menangani penerbitan draf menjadi konten publik (publishContent) dan penarikan konten (withdrawContent).
 * Setiap mutasi otomatis memicu pembangunan snapshot revisi baru atomik.
 */
import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction } from '../db/pool.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { HttpProblem } from '../http/problem.js';
import {
  normalizeKind,
  normalizeAdminKindEnum,
  parseJsonField,
  type ContentAdmin,
  type ContentInput,
  type ContentItem,
  type ContentItemRow,
} from './types.js';
import { rebuildSnapshotAndPublish } from './revision.js';

/**
 * Menerbitkan draf konten edukasi menjadi konten publik aktif.
 */
export async function publishContent(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  rawKind: string,
  contentId: string,
  expectedVersion: number,
): Promise<ContentAdmin> {
  const kind = normalizeKind(rawKind);
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'publishContent',
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
        previousCmd[0].operation !== 'publishContent' ||
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

    const draft = parseJsonField<ContentInput>(row.draft_json);
    const newVersion = Number(row.version) + 1;
    const publishedItem: ContentItem = {
      id: contentId,
      version: newVersion,
      ...draft,
    };

    await connection.execute(
      `UPDATE content_items
       SET state = 'PUBLISHED', published_json = ?, version = ?, updated_at = UTC_TIMESTAMP(3)
       WHERE id = ?`,
      [JSON.stringify(publishedItem), newVersion, contentId],
    );

    // Bangun ulang snapshot revisi publik
    await rebuildSnapshotAndPublish(connection);

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'publishContent', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, contentId],
    );

    return {
      id: contentId,
      kind: normalizeAdminKindEnum(kind),
      version: newVersion,
      state: 'PUBLISHED',
      draft,
      published: publishedItem,
    };
  });
}

/**
 * Menarik konten publik (state menjadi WITHDRAWN).
 */
export async function withdrawContent(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  rawKind: string,
  contentId: string,
  expectedVersion: number,
): Promise<ContentAdmin> {
  const kind = normalizeKind(rawKind);
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'withdrawContent',
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
        previousCmd[0].operation !== 'withdrawContent' ||
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

    const draft = parseJsonField<ContentInput>(row.draft_json);
    const newVersion = Number(row.version) + 1;

    await connection.execute(
      `UPDATE content_items
       SET state = 'WITHDRAWN', published_json = NULL, version = ?, updated_at = UTC_TIMESTAMP(3)
       WHERE id = ?`,
      [newVersion, contentId],
    );

    // Bangun ulang snapshot revisi publik
    await rebuildSnapshotAndPublish(connection);

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'withdrawContent', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, contentId],
    );

    return {
      id: contentId,
      kind: normalizeAdminKindEnum(kind),
      version: newVersion,
      state: 'WITHDRAWN',
      draft,
      published: null,
    };
  });
}
