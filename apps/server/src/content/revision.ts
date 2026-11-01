/**
 * Pembangun Snapshot dan Manifest Revisi Konten SiagaBanjir
 * Menghasilkan snapshot JSON seluruh konten PUBLISHED yang diurutkan leksikografis,
 * menghitung hash SHA-256 kanonik untuk masing-masing bagian, dan menerbitkan revisi baru atomik.
 */
import type { PoolConnection, RowDataPacket } from 'mysql2/promise';
import type { JsonValue } from '../security/fingerprint.js';
import {
  calculateSha256,
  parseJsonField,
  type Catalog,
  type Contact,
  type ContentItem,
  type ContentItemRow,
  type ContentManifest,
  type Guide,
} from './types.js';

/**
 * Membangun ulang snapshot seluruh item terbitan dan menyimpannya sebagai revisi baru dalam transaksi.
 */
export async function rebuildSnapshotAndPublish(
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

  // Pengurutan leksikografis sesuai SRS
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

  const snapshot = { contacts, guides, catalog };

  await connection.execute(
    `INSERT INTO content_revisions (revision, published_at, manifest_json, snapshot_json)
     VALUES (?, UTC_TIMESTAMP(3), ?, ?)`,
    [nextRev, JSON.stringify(manifest), JSON.stringify(snapshot)],
  );

  return nextRev;
}
