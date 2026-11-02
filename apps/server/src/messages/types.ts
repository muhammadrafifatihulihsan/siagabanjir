/**
 * Definisi Tipe dan Struktur Data Pesan SiagaBanjir
 * Menyediakan antarmuka domain untuk pesan siaran admin dan kotak masuk warga.
 */
import type { RowDataPacket } from 'mysql2/promise';

export type MessageSeverity = 'INFO' | 'WARNING' | 'CRITICAL';

export interface Message {
  id: string;
  title: string;
  body: string;
  severity: MessageSeverity;
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
  severity?: MessageSeverity;
  endsAt: string | null;
}

export interface MessageUpdate {
  title?: string;
  body?: string;
  severity?: MessageSeverity;
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

export interface MessageRow extends RowDataPacket {
  id: string;
  title: string;
  body: string;
  severity: MessageSeverity;
  published_at: string | Date;
  ends_at: string | Date | null;
  state: 'ACTIVE' | 'REVOKED' | 'EXPIRED';
  content_version: number;
  version: number;
  created_at: string | Date;
  updated_at: string | Date;
  read_account_id?: string | null;
}

/**
 * Format timestamp database menjadi string ISO 8601 UTC.
 */
export function formatDate(
  val: string | Date | null | undefined,
): string | null {
  if (!val) return null;
  return new Date(val).toISOString();
}

/**
 * Memetakan baris basis data tabel messages menjadi objek domain Message.
 */
export function formatMessage(row: MessageRow): Message {
  return {
    id: row.id,
    title: row.title,
    body: row.body,
    severity: row.severity,
    publishedAt: new Date(row.published_at).toISOString(),
    updatedAt: new Date(row.updated_at).toISOString(),
    endsAt: formatDate(row.ends_at),
    state: row.state,
    contentVersion: Number(row.content_version),
    version: Number(row.version),
  };
}
