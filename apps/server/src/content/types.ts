/**
 * Tipe dan Definisi Struktur Data Konten Edukasi & Pantau Publik SiagaBanjir
 * Menyediakan antarmuka domain untuk kontak darurat, panduan siaga, katalog logistik,
 * manifest revisi, dan item pemantauan publik.
 */
import { createHash } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import { canonicalJson, type JsonValue } from '../security/fingerprint.js';
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

export interface ContentItemRow extends RowDataPacket {
  id: string;
  kind: 'contacts' | 'guides' | 'catalog';
  draft_json: string | ContentInput;
  published_json: string | ContentItem | null;
  state: 'DRAFT' | 'PUBLISHED' | 'WITHDRAWN';
  version: number;
  created_at: string | Date;
  updated_at: string | Date;
}

export interface ContentRevisionRow extends RowDataPacket {
  revision: number;
  published_at: string | Date;
  manifest_json: string | ContentManifest;
  snapshot_json:
    string | { contacts: Contact[]; guides: Guide[]; catalog: Catalog[] };
}

/**
 * Menormalisasi jenis konten edukasi publik.
 */
export function normalizeKind(kind: string): 'contacts' | 'guides' | 'catalog' {
  const lower = kind.toLowerCase().trim();
  if (lower === 'contacts' || lower === 'guides' || lower === 'catalog') {
    return lower;
  }
  throw new HttpProblem(400, 'BAD_REQUEST');
}

/**
 * Menormalisasi nilai jenis konten untuk respons OpenAPI admin.
 */
export function normalizeAdminKindEnum(
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

/**
 * Mem-parsing string JSON dari basis data menjadi tipe objek target.
 */
export function parseJsonField<T>(val: string | T): T {
  if (typeof val === 'string') {
    return JSON.parse(val) as T;
  }
  return val;
}

/**
 * Menghitung digest SHA-256 kanonik dari nilai JSON untuk verifikasi integritas manifest.
 */
export function calculateSha256(value: JsonValue): string {
  const canonical = canonicalJson(value);
  return createHash('sha256').update(canonical, 'utf8').digest('hex');
}
