import { createHash, randomUUID, timingSafeEqual } from 'node:crypto';
import type { PoolConnection, RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction, withConnection } from '../db/pool.js';
import {
  actorScope,
  canonicalJson,
  fingerprint,
  type JsonValue,
} from '../security/fingerprint.js';
import { encodeCursor, decodeCursor } from '../security/cursor.js';
import { HttpProblem } from '../http/problem.js';

export interface SourceInfo {
  label: string;
  url: string | null;
  checkedAt: string | null;
  state: 'EXAMPLE' | 'VERIFIED';
}

export interface Contact {
  id: string;
  version: number;
  name: string;
  description: string;
  phone: string;
  source: SourceInfo;
}

export interface Guide {
  id: string;
  version: number;
  title: string;
  body: string;
  source: SourceInfo;
}

export interface Catalog {
  id: string;
  version: number;
  name: string;
  unit: string;
  quantity: number;
  mode: 'HOUSEHOLD' | 'MEMBER';
  ageGroups: (
    'TODDLER' | 'CHILD' | 'TEEN' | 'ADULT' | 'OLDER_ADULT' | 'UNKNOWN'
  )[];
  specialNeeds: ('MOBILITY' | 'SENSORY' | 'PERSONAL_CARE' | 'OTHER')[];
  general: boolean;
  source: SourceInfo;
}

export type ContentItem = Contact | Guide | Catalog;

export interface ContactInput {
  name: string;
  description: string;
  phone: string;
  source: SourceInfo;
}

export interface GuideInput {
  title: string;
  body: string;
  source: SourceInfo;
}

export interface CatalogInput {
  name: string;
  unit: string;
  quantity: number;
  mode: 'HOUSEHOLD' | 'MEMBER';
  ageGroups: (
    'TODDLER' | 'CHILD' | 'TEEN' | 'ADULT' | 'OLDER_ADULT' | 'UNKNOWN'
  )[];
  specialNeeds: ('MOBILITY' | 'SENSORY' | 'PERSONAL_CARE' | 'OTHER')[];
  general: boolean;
  source: SourceInfo;
}

export type ContentInput = ContactInput | GuideInput | CatalogInput;

export interface ContentAdmin {
  id: string;
  kind: 'CONTACTS' | 'GUIDES' | 'CATALOG';
  version: number;
  state: 'DRAFT' | 'PUBLISHED' | 'WITHDRAWN';
  draft: ContentInput;
  published: ContentItem | null;
}

export interface ContentManifestPart {
  kind: 'contacts' | 'guides' | 'catalog';
  count: number;
  sha256: string;
}

export interface ContentManifest {
  revision: number;
  publishedAt: string;
  parts: [ContentManifestPart, ContentManifestPart, ContentManifestPart];
}

export interface MonitorItem {
  locationName: string;
  level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
  updatedAt: string;
  reviewState: 'NEEDS_REVIEW' | 'REVIEWED';
}

export interface MonitorItemPage {
  items: MonitorItem[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface ContentItemPage {
  items: ContentItem[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface ContentAdminPage {
  items: ContentAdmin[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

interface ContentItemRow extends RowDataPacket {
  id: string;
  kind: 'contacts' | 'guides' | 'catalog';
  draft_json: string | ContentInput;
  published_json: string | ContentItem | null;
  state: 'DRAFT' | 'PUBLISHED' | 'WITHDRAWN';
  version: number;
  created_at: string | Date;
  updated_at: string | Date;
}

interface ContentRevisionRow extends RowDataPacket {
  revision: number;
  published_at: string | Date;
  manifest_json: string | ContentManifest;
  snapshot_json:
    string | { contacts: Contact[]; guides: Guide[]; catalog: Catalog[] };
}

function normalizeKind(kind: string): 'contacts' | 'guides' | 'catalog' {
  const lower = kind.toLowerCase().trim();
  if (lower === 'contacts' || lower === 'guides' || lower === 'catalog') {
    return lower;
  }
  throw new HttpProblem(400, 'BAD_REQUEST');
}

function normalizeAdminKindEnum(
  kind: 'contacts' | 'guides' | 'catalog',
): 'CONTACTS' | 'GUIDES' | 'CATALOG' {
  switch (kind) {
    case 'contacts':
      return 'CONTACTS';
    case 'guides':
      return 'GUIDES';
    case 'catalog':
      return 'CATALOG';
  }
}

function parseJsonField<T>(val: string | T): T {
  if (typeof val === 'string') {
    return JSON.parse(val) as T;
  }
  return val;
}

function calculateSha256(value: JsonValue): string {
  const canonical = canonicalJson(value);
  return createHash('sha256').update(canonical, 'utf8').digest('hex');
}

// 1. PANTAU PUBLIK (GET /public/monitor)
export async function listMonitor(
  deps: AuthDependencies,
  query: { cursor?: string; q?: string; section?: string },
): Promise<MonitorItemPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      'public',
      'public-monitor',
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const params: (string | number)[] = [];
    let sql = `
      SELECT g.id, g.location_label, g.level, g.updated_at,
        MIN(r.needs_review_since) as min_needs_review_since
      FROM \`groups\` g
      LEFT JOIN reports r ON g.id = r.group_id AND r.deleted_at IS NULL
      WHERE g.state = 'ACTIVE'
    `;

    if (query.section === 'RATED') {
      sql += " AND g.level IN ('LOW', 'MEDIUM', 'HIGH')";
    } else if (query.section === 'UNRATED') {
      sql += " AND g.level = 'UNRATED'";
    }

    if (filter) {
      sql += ' AND g.location_label LIKE ?';
      params.push(`%${filter}%`);
    }

    sql += ' GROUP BY g.id';

    if (lastId) {
      sql += ' HAVING g.id < ?';
      params.push(lastId);
    }

    sql += ` ORDER BY 
      CASE g.level WHEN 'HIGH' THEN 1 WHEN 'MEDIUM' THEN 2 WHEN 'LOW' THEN 3 ELSE 4 END ASC,
      g.updated_at DESC,
      g.id ASC
      LIMIT 21`;

    const [rows] = await connection.execute<RowDataPacket[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items: MonitorItem[] = pageRows.map((r) => {
      const needsReview = r.min_needs_review_since !== null;
      return {
        locationName: (r.location_label as string) || 'Lokasi Kejadian',
        level: r.level as MonitorItem['level'],
        updatedAt: new Date(r.updated_at as string).toISOString(),
        reviewState: needsReview ? 'NEEDS_REVIEW' : 'REVIEWED',
      };
    });

    let nextCursor: string | null = null;
    const lastRow = pageRows[pageRows.length - 1];
    if (hasMore && lastRow) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: 'public',
        domain: 'public-monitor',
        filter: filter || 'default',
        lastId: lastRow.id as string,
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

// 2. KONTEN MANIFEST (GET /public/content/manifest)
export async function getContentManifest(
  deps: AuthDependencies,
): Promise<ContentManifest> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<ContentRevisionRow[]>(
      'SELECT * FROM content_revisions ORDER BY revision DESC LIMIT 1',
    );
    if (rows[0]) {
      const parsed = parseJsonField<ContentManifest>(rows[0].manifest_json);
      return {
        revision: Number(rows[0].revision),
        publishedAt: new Date(rows[0].published_at).toISOString(),
        parts: parsed.parts,
      };
    }

    // Default manifest awal bila belum pernah ada terbitan
    const emptySha = calculateSha256([]);
    return {
      revision: 1,
      publishedAt: new Date().toISOString(),
      parts: [
        { kind: 'contacts', count: 0, sha256: emptySha },
        { kind: 'guides', count: 0, sha256: emptySha },
        { kind: 'catalog', count: 0, sha256: emptySha },
      ],
    };
  });
}

// 3. KONTEN PART (GET /public/content/:revision/:kind)
export async function getContentPart(
  deps: AuthDependencies,
  revision: number,
  rawKind: string,
  query: { cursor?: string; q?: string },
): Promise<ContentItemPage> {
  const kind = normalizeKind(rawKind);
  const filter = query.q ? query.q.normalize('NFC').trim().toLowerCase() : '';

  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<ContentRevisionRow[]>(
      'SELECT * FROM content_revisions WHERE revision = ?',
      [revision],
    );
    const row = rows[0];
    if (!row) {
      // Jika revision 1 dan belum ada di DB, return array kosong
      if (revision === 1) {
        return {
          items: [],
          nextCursor: null,
          serverTime: new Date().toISOString(),
          revision: 1,
        };
      }
      throw new HttpProblem(404, 'NOT_FOUND');
    }

    const snapshot = parseJsonField<{
      contacts: Contact[];
      guides: Guide[];
      catalog: Catalog[];
    }>(row.snapshot_json);

    let allItems: ContentItem[] = snapshot[kind] || [];

    if (filter) {
      allItems = allItems.filter((item) => {
        if ('name' in item) {
          return item.name.toLowerCase().includes(filter);
        }
        if ('title' in item) {
          return item.title.toLowerCase().includes(filter);
        }
        return false;
      });
    }

    let startIndex = 0;
    if (query.cursor) {
      const decoded = decodeCursor(
        deps.keys.cursor,
        query.cursor,
        'public',
        `public-content-${revision}-${kind}`,
        filter || 'default',
      );
      const idx = allItems.findIndex((it) => it.id === decoded.lastId);
      if (idx !== -1) {
        startIndex = idx + 1;
      }
    }

    const paged = allItems.slice(startIndex, startIndex + 20);
    const hasMore = startIndex + 20 < allItems.length;

    let nextCursor: string | null = null;
    const lastItem = paged[paged.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: 'public',
        domain: `public-content-${revision}-${kind}`,
        filter: filter || 'default',
        lastId: lastItem.id,
      });
    }

    return {
      items: paged,
      nextCursor,
      serverTime: new Date().toISOString(),
      revision,
    };
  });
}

// 4. ADMIN CMS: listContentAdmin
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

// Helper publikasi & pembentukan revision baru atomik
async function rebuildSnapshotAndPublish(
  connection: PoolConnection,
): Promise<number> {
  const [publishedRows] = await connection.execute<ContentItemRow[]>(
    "SELECT * FROM content_items WHERE state = 'PUBLISHED' ORDER BY id ASC",
  );

  const contacts: Contact[] = [];
  const guides: Guide[] = [];
  const catalog: Catalog[] = [];

  for (const row of publishedRows) {
    if (!row.published_json) continue;
    const item = parseJsonField<ContentItem>(row.published_json);
    if (row.kind === 'contacts') {
      contacts.push(item as Contact);
    } else if (row.kind === 'guides') {
      guides.push(item as Guide);
    } else if (row.kind === 'catalog') {
      catalog.push(item as Catalog);
    }
  }

  // Urutkan leksikografis sesuai SRS
  contacts.sort(
    (a, b) => a.name.localeCompare(b.name) || a.id.localeCompare(b.id),
  );
  guides.sort(
    (a, b) => a.title.localeCompare(b.title) || a.id.localeCompare(b.id),
  );
  catalog.sort(
    (a, b) => a.name.localeCompare(b.name) || a.id.localeCompare(b.id),
  );

  const contactsSha = calculateSha256(contacts as unknown as JsonValue);
  const guidesSha = calculateSha256(guides as unknown as JsonValue);
  const catalogSha = calculateSha256(catalog as unknown as JsonValue);

  const [revRows] = await connection.execute<RowDataPacket[]>(
    'SELECT COALESCE(MAX(revision), 0) as max_rev FROM content_revisions FOR UPDATE',
  );
  const nextRev = Number(revRows[0]?.max_rev ?? 0) + 1;

  const manifest: ContentManifest = {
    revision: nextRev,
    publishedAt: new Date().toISOString(),
    parts: [
      { kind: 'contacts', count: contacts.length, sha256: contactsSha },
      { kind: 'guides', count: guides.length, sha256: guidesSha },
      { kind: 'catalog', count: catalog.length, sha256: catalogSha },
    ],
  };

  const snapshot = {
    contacts,
    guides,
    catalog,
  };

  await connection.execute(
    `INSERT INTO content_revisions (revision, published_at, manifest_json, snapshot_json)
     VALUES (?, UTC_TIMESTAMP(3), ?, ?)`,
    [nextRev, JSON.stringify(manifest), JSON.stringify(snapshot)],
  );

  return nextRev;
}

// 5. POST /admin/content/:kind (createContentDraft)
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

// 6. PUT /admin/content/:kind/:contentId (updateContentDraft)
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

// 7. DELETE /admin/content/:kind/:contentId (deleteContentDraft)
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

    // Jika sedang PUBLISHED, tidak boleh langsung di-DELETE (harus withdraw dahulu)
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

// 8. POST /admin/content/:kind/:contentId/publish (publishContent)
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

    // Format item yang diterbitkan
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

    // Rebuild snapshot revisi publik
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

// 9. POST /admin/content/:kind/:contentId/withdraw (withdrawContent)
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

    // Rebuild snapshot revisi publik
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
