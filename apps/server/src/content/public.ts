/**
 * Modul Konten Publik & Pantau SiagaBanjir
 * Menyediakan endpoint publik untuk ringkasan Pantau banjir (GET /public/monitor),
 * manifest revisi edukasi (GET /public/content/manifest), dan bagian konten (GET /public/content/:rev/:kind).
 */
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withConnection } from '../db/pool.js';
import { encodeCursor, decodeCursor } from '../security/cursor.js';
import { HttpProblem } from '../http/problem.js';
import {
  calculateSha256,
  normalizeKind,
  parseJsonField,
  type Catalog,
  type Contact,
  type ContentItem,
  type ContentItemPage,
  type ContentManifest,
  type ContentRevisionRow,
  type Guide,
  type MonitorItem,
  type MonitorItemPage,
} from './types.js';

/**
 * Membaca data ringkasan Pantau publik.
 * Membatasi hanya 4 atribut publik (locationName, level, updatedAt, reviewState).
 */
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
        g.summary, g.ai_summary, g.latitude, g.longitude,
        MIN(r.needs_review_since) as min_needs_review_since,
        COUNT(r.id) as report_count
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
        id: String(r.id),
        locationName: (r.location_label as string) || 'Lokasi Kejadian',
        level: r.level as MonitorItem['level'],
        updatedAt: new Date(r.updated_at as string).toISOString(),
        reviewState: needsReview ? 'NEEDS_REVIEW' : 'REVIEWED',
        reportCount: Number(r.report_count ?? 0),
        summary: (r.summary as string) ?? null,
        aiSummary: (r.ai_summary as string) ?? null,
        latitude: r.latitude == null ? null : Number(r.latitude),
        longitude: r.longitude == null ? null : Number(r.longitude),
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

/**
 * Membaca manifest konten edukasi publik revisi termutakhir.
 */
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

/**
 * Membaca bagian konten edukasi publik pada revisi tertentu (kontak, panduan, katalog).
 */
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
        if ('name' in item) return item.name.toLowerCase().includes(filter);
        if ('title' in item) return item.title.toLowerCase().includes(filter);
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
      if (idx !== -1) startIndex = idx + 1;
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
