import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { PoolConnection, RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction, withConnection } from '../db/pool.js';
import {
  actorScope,
  fingerprint,
  type JsonValue,
} from '../security/fingerprint.js';
import { encodeCursor, decodeCursor } from '../security/cursor.js';
import { HttpProblem } from '../http/problem.js';

export interface DocumentMedia {
  id: string;
  mediaType: string;
  sizeBytes: number;
  durationMs: number | null;
}

export interface Document {
  id: string;
  displayName: string;
  version: number;
  media: DocumentMedia;
  createdAt: string;
  activeKtp: boolean;
}

export interface DocumentPage {
  items: Document[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface Cleanup {
  id: string;
  objectId: string;
  state: 'PENDING' | 'RUNNING' | 'FAILED' | 'SUCCEEDED';
  attempt: number;
  updatedAt: string;
  errorCode: string | null;
}

export interface CleanupPage {
  items: Cleanup[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface KtpState {
  version: number;
  activeDocumentId: string | null;
  satisfied: boolean;
  latestJobId: string | null;
}

export interface Job {
  id: string;
  kind: 'REPORT_ANALYSIS' | 'KTP_CHECK' | 'FAMILY_EXTRACTION';
  state:
    'QUEUED' | 'RUNNING' | 'SUCCEEDED' | 'FAILED' | 'CANCELLED' | 'EXPIRED';
  sourceId: string;
  attempt: number;
  completedUnits: number;
  totalUnits: number;
  updatedAt: string;
  errorCode: string | null;
}

export interface FamilyMember {
  id: string;
  displayName: string;
  ageGroup: 'TODDLER' | 'CHILD' | 'TEEN' | 'ADULT' | 'OLDER_ADULT' | 'UNKNOWN';
  specialNeeds: ('MOBILITY' | 'SENSORY' | 'PERSONAL_CARE' | 'OTHER')[];
}

export interface Family {
  version: number;
  members: FamilyMember[];
}

export interface MemberAdd {
  op: 'ADD';
  clientMemberId: string;
  displayName: string;
  ageGroup: FamilyMember['ageGroup'];
  specialNeeds: FamilyMember['specialNeeds'];
}

export interface MemberUpdate {
  op: 'UPDATE';
  memberId: string;
  displayName: string;
  ageGroup: FamilyMember['ageGroup'];
  specialNeeds: FamilyMember['specialNeeds'];
}

export interface MemberDelete {
  op: 'DELETE';
  memberId: string;
}

export type MemberOperation = MemberAdd | MemberUpdate | MemberDelete;

interface DocumentRow extends RowDataPacket {
  id: string;
  owner_id: string;
  display_name: string;
  upload_id: string;
  version: number;
  created_at: string;
  deleted_at: string | null;
  mime: string;
  bytes: number;
  duration_ms: number | null;
}

interface KtpRow extends RowDataPacket {
  account_id: string;
  active_document_id: string | null;
  version: number;
  latest_job_id: string | null;
}

interface JobRow extends RowDataPacket {
  id: string;
  kind: Job['kind'];
  owner_id: string;
  source_id: string | null;
  state: Job['state'];
  attempt: number;
  completed_units: number;
  total_units: number;
  updated_at: string;
  safe_error: string | null;
}

interface CleanupRow extends RowDataPacket {
  id: string;
  object_id: string;
  state: Cleanup['state'];
  attempt: number;
  updated_at: string;
  error_code: string | null;
}

interface FamilyMemberRow extends RowDataPacket {
  id: string;
  account_id: string;
  display_name: string;
  age_group: FamilyMember['ageGroup'];
  special_needs:
    string | ('MOBILITY' | 'SENSORY' | 'PERSONAL_CARE' | 'OTHER')[];
}

// 1. DOKUMEN PRIVAT
export async function createDocument(
  deps: AuthDependencies,
  accountId: string,
  clientKey: string,
  input: { uploadId: string; displayName: string },
): Promise<Document> {
  const name = input.displayName.normalize('NFC').trim();
  if (!name || name.length < 1 || name.length > 120) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'createDocument',
    displayName: name,
    uploadId: input.uploadId,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // Cek idempotensi
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint, object_id FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'createDocument' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return getDocument(deps, accountId, previousCmd[0].object_id as string);
    }

    // Periksa upload
    const [uploadRows] = await connection.execute<RowDataPacket[]>(
      'SELECT id, purpose, state, bytes, mime, duration_ms FROM uploads WHERE id = ? AND owner_id = ? FOR UPDATE',
      [input.uploadId, accountId],
    );
    const upload = uploadRows[0];
    if (!upload || upload.purpose !== 'DOCUMENT' || upload.state !== 'READY') {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    // Periksa kuota dokumen (maks 20 dokumen, maks 100 MiB)
    const [countRows] = await connection.execute<RowDataPacket[]>(
      'SELECT COUNT(*) as doc_count, COALESCE(SUM(u.bytes), 0) as total_bytes FROM documents d JOIN uploads u ON d.upload_id = u.id WHERE d.owner_id = ? AND d.deleted_at IS NULL',
      [accountId],
    );
    const docCount = Number(countRows[0]?.doc_count ?? 0);
    const totalBytes = Number(countRows[0]?.total_bytes ?? 0);
    if (
      docCount >= 20 ||
      totalBytes + Number(upload.bytes) > 100 * 1024 * 1024
    ) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    const docId = randomUUID();
    await connection.execute(
      `INSERT INTO documents (id, owner_id, display_name, upload_id, version, created_at, updated_at)
       VALUES (?, ?, ?, ?, 1, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [docId, accountId, name, input.uploadId],
    );

    await connection.execute(
      "UPDATE uploads SET state = 'ATTACHED', updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
      [input.uploadId],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'createDocument', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, docId],
    );

    return {
      id: docId,
      displayName: name,
      version: 1,
      media: {
        id: upload.id as string,
        mediaType: upload.mime as string,
        sizeBytes: Number(upload.bytes),
        durationMs:
          upload.duration_ms !== null ? Number(upload.duration_ms) : null,
      },
      createdAt: new Date().toISOString(),
      activeKtp: false,
    };
  });
}

export async function listDocuments(
  deps: AuthDependencies,
  accountId: string,
  query: { cursor?: string; q?: string },
): Promise<DocumentPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      accountId,
      'documents',
      filter,
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const [ktpRows] = await connection.execute<KtpRow[]>(
      'SELECT active_document_id FROM ktp_states WHERE account_id = ?',
      [accountId],
    );
    const activeDocId = ktpRows[0]?.active_document_id;

    let sql =
      'SELECT d.*, u.mime, u.bytes, u.duration_ms FROM documents d JOIN uploads u ON d.upload_id = u.id WHERE d.owner_id = ? AND d.deleted_at IS NULL';
    const params: (string | number)[] = [accountId];

    if (filter) {
      const escaped = filter.replace(/([%_\\])/g, '\\$1');
      sql += ' AND d.display_name LIKE ?';
      params.push(`%${escaped}%`);
    }

    if (lastId) {
      sql += ' AND d.id > ?';
      params.push(lastId);
    }

    sql += ' ORDER BY d.id ASC LIMIT 21';

    const [rows] = await connection.execute<DocumentRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const itemRows = hasMore ? rows.slice(0, 20) : rows;

    const items: Document[] = itemRows.map((r) => ({
      id: r.id,
      displayName: r.display_name,
      version: r.version,
      media: {
        id: r.upload_id,
        mediaType: r.mime,
        sizeBytes: Number(r.bytes),
        durationMs: r.duration_ms !== null ? Number(r.duration_ms) : null,
      },
      createdAt: new Date(r.created_at).toISOString(),
      activeKtp: r.id === activeDocId,
    }));

    let nextCursor: string | null = null;
    if (hasMore && itemRows.length > 0) {
      const last = itemRows[itemRows.length - 1];
      if (last) {
        nextCursor = encodeCursor(deps.keys.cursor, {
          actorId: accountId,
          domain: 'documents',
          filter,
          lastId: last.id,
        });
      }
    }

    return {
      items,
      nextCursor,
      revision: null,
      serverTime: new Date().toISOString(),
    };
  });
}

export async function getDocument(
  deps: AuthDependencies,
  accountId: string,
  documentId: string,
): Promise<Document> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<DocumentRow[]>(
      'SELECT d.*, u.mime, u.bytes, u.duration_ms FROM documents d JOIN uploads u ON d.upload_id = u.id WHERE d.id = ? AND d.owner_id = ?',
      [documentId, accountId],
    );
    const r = rows[0];
    if (!r) throw new HttpProblem(404, 'NOT_FOUND');
    if (r.deleted_at) throw new HttpProblem(410, 'GONE');

    const [ktpRows] = await connection.execute<KtpRow[]>(
      'SELECT active_document_id FROM ktp_states WHERE account_id = ?',
      [accountId],
    );

    return {
      id: r.id,
      displayName: r.display_name,
      version: r.version,
      media: {
        id: r.upload_id,
        mediaType: r.mime,
        sizeBytes: Number(r.bytes),
        durationMs: r.duration_ms !== null ? Number(r.duration_ms) : null,
      },
      createdAt: new Date(r.created_at).toISOString(),
      activeKtp: r.id === ktpRows[0]?.active_document_id,
    };
  });
}

export async function deleteDocument(
  deps: AuthDependencies,
  accountId: string,
  documentId: string,
  clientKey: string,
): Promise<{ success: boolean }> {
  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'deleteDocument',
    documentId,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'deleteDocument' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return { success: true };
    }

    const [rows] = await connection.execute<DocumentRow[]>(
      'SELECT id, deleted_at FROM documents WHERE id = ? AND owner_id = ? FOR UPDATE',
      [documentId, accountId],
    );
    const doc = rows[0];
    if (!doc) throw new HttpProblem(404, 'NOT_FOUND');

    if (!doc.deleted_at) {
      await connection.execute(
        'UPDATE documents SET deleted_at = UTC_TIMESTAMP(3), updated_at = UTC_TIMESTAMP(3) WHERE id = ?',
        [documentId],
      );

      // Jika ini active KTP, lepaskan
      await connection.execute(
        'UPDATE ktp_states SET active_document_id = NULL, version = version + 1, updated_at = UTC_TIMESTAMP(3) WHERE account_id = ? AND active_document_id = ?',
        [accountId, documentId],
      );

      // Buat cleanup job
      const cleanupId = randomUUID();
      await connection.execute(
        `INSERT INTO cleanup_jobs (id, object_type, object_id, owner_id, state, attempt, created_at, updated_at)
         VALUES (?, 'DOCUMENT', ?, ?, 'PENDING', 0, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
        [cleanupId, documentId, accountId],
      );
    }

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'deleteDocument', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, documentId],
    );

    return { success: true };
  });
}

export async function listOwnCleanup(
  deps: AuthDependencies,
  accountId: string,
  query: { cursor?: string; q?: string },
): Promise<CleanupPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      accountId,
      'cleanup',
      filter,
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    let sql =
      "SELECT * FROM cleanup_jobs WHERE owner_id = ? AND object_type = 'DOCUMENT'";
    const params: (string | number)[] = [accountId];

    if (lastId) {
      sql += ' AND id > ?';
      params.push(lastId);
    }

    sql += ' ORDER BY id ASC LIMIT 21';

    const [rows] = await connection.execute<CleanupRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const itemRows = hasMore ? rows.slice(0, 20) : rows;

    const items: Cleanup[] = itemRows.map((c) => ({
      id: c.id,
      objectId: c.object_id,
      state: c.state,
      attempt: c.attempt,
      updatedAt: new Date(c.updated_at).toISOString(),
      errorCode: c.error_code,
    }));

    let nextCursor: string | null = null;
    if (hasMore && itemRows.length > 0) {
      const last = itemRows[itemRows.length - 1];
      if (last) {
        nextCursor = encodeCursor(deps.keys.cursor, {
          actorId: accountId,
          domain: 'cleanup',
          filter,
          lastId: last.id,
        });
      }
    }

    return {
      items,
      nextCursor,
      revision: null,
      serverTime: new Date().toISOString(),
    };
  });
}

export async function retryOwnCleanup(
  deps: AuthDependencies,
  accountId: string,
  cleanupId: string,
): Promise<Cleanup> {
  return withBusinessTransaction(deps.pool, async (connection) => {
    const [rows] = await connection.execute<CleanupRow[]>(
      "SELECT * FROM cleanup_jobs WHERE id = ? AND owner_id = ? AND object_type = 'DOCUMENT' FOR UPDATE",
      [cleanupId, accountId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');

    await connection.execute(
      "UPDATE cleanup_jobs SET state = 'RUNNING', attempt = attempt + 1, updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
      [cleanupId],
    );

    return {
      id: row.id,
      objectId: row.object_id,
      state: 'RUNNING',
      attempt: row.attempt + 1,
      updatedAt: new Date().toISOString(),
      errorCode: null,
    };
  });
}

// 2. KTP
export async function getKtpState(
  deps: AuthDependencies,
  accountId: string,
): Promise<KtpState> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<KtpRow[]>(
      'SELECT * FROM ktp_states WHERE account_id = ?',
      [accountId],
    );
    const r = rows[0];
    if (!r) {
      return {
        version: 1,
        activeDocumentId: null,
        satisfied: false,
        latestJobId: null,
      };
    }
    return {
      version: Number(r.version),
      activeDocumentId: r.active_document_id,
      satisfied: Boolean(r.active_document_id),
      latestJobId: r.latest_job_id,
    };
  });
}

export async function checkKtp(
  deps: AuthDependencies,
  accountId: string,
  clientKey: string,
  input: {
    documentId: string;
    documentVersion: number;
    consentVersion: 'ktp-v1';
  },
): Promise<Job> {
  if (input.consentVersion !== 'ktp-v1') {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'checkKtp',
    consentVersion: input.consentVersion,
    documentId: input.documentId,
    documentVersion: input.documentVersion,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // Cek idempotensi
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint, object_id FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'checkKtp' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [jobs] = await connection.execute<JobRow[]>(
        'SELECT * FROM jobs WHERE id = ? AND owner_id = ?',
        [previousCmd[0].object_id, accountId],
      );
      const j = jobs[0];
      if (!j) throw new HttpProblem(404, 'NOT_FOUND');
      return {
        id: j.id,
        kind: j.kind,
        state: j.state,
        sourceId: j.source_id ?? input.documentId,
        attempt: j.attempt,
        completedUnits: j.completed_units,
        totalUnits: j.total_units,
        updatedAt: new Date(j.updated_at).toISOString(),
        errorCode: j.safe_error,
      };
    }

    // Verifikasi dokumen
    const [docRows] = await connection.execute<DocumentRow[]>(
      'SELECT id, version FROM documents WHERE id = ? AND owner_id = ? AND deleted_at IS NULL',
      [input.documentId, accountId],
    );
    const doc = docRows[0];
    if (!doc || doc.version !== input.documentVersion) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    // Catat consent
    const consentId = randomUUID();
    await connection.execute(
      `INSERT INTO consents (id, owner_id, purpose, source_id, source_version, text_version, granted_at)
       VALUES (?, ?, 'KTP', ?, ?, 'ktp-v1', UTC_TIMESTAMP(3))`,
      [consentId, accountId, input.documentId, input.documentVersion],
    );

    // Buat Job KTP
    const jobId = randomUUID();
    await connection.execute(
      `INSERT INTO jobs
         (id, kind, owner_id, source_id, source_version, state, attempt, completed_units, total_units, created_at, updated_at)
       VALUES
         (?, 'KTP_CHECK', ?, ?, ?, 'SUCCEEDED', 1, 1, 1, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [jobId, accountId, input.documentId, input.documentVersion],
    );

    // Update latest_job_id pada ktp_states
    await connection.execute(
      `INSERT INTO ktp_states (account_id, active_document_id, version, latest_job_id, updated_at)
       VALUES (?, NULL, 1, ?, UTC_TIMESTAMP(3))
       ON DUPLICATE KEY UPDATE latest_job_id = VALUES(latest_job_id), updated_at = UTC_TIMESTAMP(3)`,
      [accountId, jobId],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'checkKtp', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, jobId],
    );

    return {
      id: jobId,
      kind: 'KTP_CHECK',
      state: 'SUCCEEDED',
      sourceId: input.documentId,
      attempt: 1,
      completedUnits: 1,
      totalUnits: 1,
      updatedAt: new Date().toISOString(),
      errorCode: null,
    };
  });
}

export async function confirmKtp(
  deps: AuthDependencies,
  accountId: string,
  clientKey: string,
  expectedVersion: number,
  input: {
    documentId: string;
    documentVersion: number;
    jobId: string;
    nameConfirmed: true;
  },
): Promise<KtpState> {
  if (!input.nameConfirmed) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'confirmKtp',
    documentId: input.documentId,
    documentVersion: input.documentVersion,
    ifMatch: expectedVersion,
    jobId: input.jobId,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // Cek idempotensi
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'confirmKtp' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return getKtpState(deps, accountId);
    }

    const [ktpRows] = await connection.execute<KtpRow[]>(
      'SELECT * FROM ktp_states WHERE account_id = ? FOR UPDATE',
      [accountId],
    );
    const current = ktpRows[0];
    const currentVersion = current ? Number(current.version) : 1;
    if (currentVersion !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, currentVersion);
    }

    // Verifikasi Job
    const [jobRows] = await connection.execute<JobRow[]>(
      "SELECT * FROM jobs WHERE id = ? AND owner_id = ? AND kind = 'KTP_CHECK'",
      [input.jobId, accountId],
    );
    const job = jobRows[0];
    if (!job || job.state !== 'SUCCEEDED') {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    // Verifikasi Dokumen
    const [docRows] = await connection.execute<DocumentRow[]>(
      'SELECT id, version FROM documents WHERE id = ? AND owner_id = ? AND deleted_at IS NULL',
      [input.documentId, accountId],
    );
    const doc = docRows[0];
    if (!doc || doc.version !== input.documentVersion) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    await connection.execute(
      `INSERT INTO ktp_states (account_id, active_document_id, version, latest_job_id, updated_at)
       VALUES (?, ?, ?, ?, UTC_TIMESTAMP(3))
       ON DUPLICATE KEY UPDATE active_document_id = VALUES(active_document_id), version = version + 1, latest_job_id = VALUES(latest_job_id), updated_at = UTC_TIMESTAMP(3)`,
      [accountId, input.documentId, currentVersion + 1, input.jobId],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'confirmKtp', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, input.documentId],
    );

    return {
      version: currentVersion + 1,
      activeDocumentId: input.documentId,
      satisfied: true,
      latestJobId: input.jobId,
    };
  });
}

export async function retryKtp(
  deps: AuthDependencies,
  accountId: string,
  jobId: string,
): Promise<Job> {
  return withBusinessTransaction(deps.pool, async (connection) => {
    const [rows] = await connection.execute<JobRow[]>(
      "SELECT * FROM jobs WHERE id = ? AND owner_id = ? AND kind = 'KTP_CHECK' FOR UPDATE",
      [jobId, accountId],
    );
    const job = rows[0];
    if (!job) throw new HttpProblem(404, 'NOT_FOUND');

    await connection.execute(
      "UPDATE jobs SET attempt = attempt + 1, state = 'SUCCEEDED', updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
      [jobId],
    );

    return {
      id: job.id,
      kind: job.kind,
      state: 'SUCCEEDED',
      sourceId: job.source_id ?? '',
      attempt: job.attempt + 1,
      completedUnits: job.completed_units,
      totalUnits: job.total_units,
      updatedAt: new Date().toISOString(),
      errorCode: null,
    };
  });
}

// 3. KELUARGA
async function loadFamily(
  connection: PoolConnection,
  accountId: string,
): Promise<Family> {
  const [profileRows] = await connection.execute<RowDataPacket[]>(
    'SELECT version FROM family_profiles WHERE account_id = ?',
    [accountId],
  );
  const version = profileRows[0] ? Number(profileRows[0].version) : 1;

  const [memberRows] = await connection.execute<FamilyMemberRow[]>(
    'SELECT * FROM family_members WHERE account_id = ? ORDER BY created_at ASC',
    [accountId],
  );

  const members: FamilyMember[] = memberRows.map((m) => {
    const needs =
      typeof m.special_needs === 'string'
        ? (JSON.parse(m.special_needs) as FamilyMember['specialNeeds'])
        : m.special_needs;
    return {
      id: m.id,
      displayName: m.display_name,
      ageGroup: m.age_group,
      specialNeeds: Array.isArray(needs) ? needs : [],
    };
  });

  return { version, members };
}

export async function getFamily(
  deps: AuthDependencies,
  accountId: string,
): Promise<Family> {
  return withConnection(deps.pool, async (connection) => {
    return loadFamily(connection, accountId);
  });
}

export async function updateFamily(
  deps: AuthDependencies,
  accountId: string,
  clientKey: string,
  expectedVersion: number,
  operations: MemberOperation[],
): Promise<Family> {
  if (
    !Array.isArray(operations) ||
    operations.length < 1 ||
    operations.length > 40
  ) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'updateFamily',
    ifMatch: expectedVersion,
    operations: operations as unknown as JsonValue,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // Cek idempotensi
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'updateFamily' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return loadFamily(connection, accountId);
    }

    const [profileRows] = await connection.execute<RowDataPacket[]>(
      'SELECT version FROM family_profiles WHERE account_id = ? FOR UPDATE',
      [accountId],
    );
    const currentVersion = profileRows[0] ? Number(profileRows[0].version) : 1;
    if (currentVersion !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, currentVersion);
    }

    for (const op of operations) {
      if (op.op === 'ADD') {
        const [cnt] = await connection.execute<RowDataPacket[]>(
          'SELECT COUNT(*) as member_count FROM family_members WHERE account_id = ?',
          [accountId],
        );
        if (Number(cnt[0]?.member_count ?? 0) >= 20) {
          throw new HttpProblem(422, 'VALIDATION_FAILED');
        }
        await connection.execute(
          `INSERT INTO family_members (id, account_id, display_name, age_group, special_needs, created_at, updated_at)
           VALUES (?, ?, ?, ?, ?, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
          [
            op.clientMemberId,
            accountId,
            op.displayName.trim(),
            op.ageGroup,
            JSON.stringify(op.specialNeeds),
          ],
        );
      } else if (op.op === 'UPDATE') {
        await connection.execute(
          `UPDATE family_members
           SET display_name = ?, age_group = ?, special_needs = ?, updated_at = UTC_TIMESTAMP(3)
           WHERE id = ? AND account_id = ?`,
          [
            op.displayName.trim(),
            op.ageGroup,
            JSON.stringify(op.specialNeeds),
            op.memberId,
            accountId,
          ],
        );
      } else if (op.op === 'DELETE') {
        await connection.execute(
          'DELETE FROM family_members WHERE id = ? AND account_id = ?',
          [op.memberId, accountId],
        );
      }
    }

    await connection.execute(
      `INSERT INTO family_profiles (account_id, version, updated_at)
       VALUES (?, ?, UTC_TIMESTAMP(3))
       ON DUPLICATE KEY UPDATE version = version + 1, updated_at = UTC_TIMESTAMP(3)`,
      [accountId, currentVersion + 1],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'updateFamily', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, accountId],
    );

    return loadFamily(connection, accountId);
  });
}

export async function extractFamily(
  deps: AuthDependencies,
  accountId: string,
  clientKey: string,
  input: {
    documents: { id: string; version: number }[];
    consentVersion: 'family-v1';
  },
): Promise<Job> {
  if (
    input.consentVersion !== 'family-v1' ||
    !Array.isArray(input.documents) ||
    input.documents.length === 0
  ) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'extractFamily',
    consentVersion: input.consentVersion,
    documents: input.documents,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // Cek idempotensi
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint, object_id FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'extractFamily' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [jobs] = await connection.execute<JobRow[]>(
        'SELECT * FROM jobs WHERE id = ? AND owner_id = ?',
        [previousCmd[0].object_id, accountId],
      );
      const j = jobs[0];
      if (!j) throw new HttpProblem(404, 'NOT_FOUND');
      return {
        id: j.id,
        kind: j.kind,
        state: j.state,
        sourceId: j.source_id ?? '',
        attempt: j.attempt,
        completedUnits: j.completed_units,
        totalUnits: j.total_units,
        updatedAt: new Date(j.updated_at).toISOString(),
        errorCode: j.safe_error,
      };
    }

    for (const d of input.documents) {
      const [rows] = await connection.execute<DocumentRow[]>(
        'SELECT id, version FROM documents WHERE id = ? AND owner_id = ? AND deleted_at IS NULL',
        [d.id, accountId],
      );
      if (!rows[0] || rows[0].version !== d.version) {
        throw new HttpProblem(422, 'VALIDATION_FAILED');
      }
    }

    const firstDoc = input.documents[0];
    if (!firstDoc) throw new HttpProblem(422, 'VALIDATION_FAILED');

    // Catat consent
    const consentId = randomUUID();
    await connection.execute(
      `INSERT INTO consents (id, owner_id, purpose, source_id, source_version, text_version, granted_at)
       VALUES (?, ?, 'FAMILY', ?, ?, 'family-v1', UTC_TIMESTAMP(3))`,
      [consentId, accountId, firstDoc.id, firstDoc.version],
    );

    const jobId = randomUUID();
    await connection.execute(
      `INSERT INTO jobs
         (id, kind, owner_id, source_id, source_version, state, attempt, completed_units, total_units, created_at, updated_at)
       VALUES
         (?, 'FAMILY_EXTRACTION', ?, ?, ?, 'SUCCEEDED', 1, ?, ?, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [
        jobId,
        accountId,
        firstDoc.id,
        firstDoc.version,
        input.documents.length,
        input.documents.length,
      ],
    );

    // Buat saran simulasi di extraction_suggestions
    const suggestionId = randomUUID();
    await connection.execute(
      `INSERT INTO extraction_suggestions
         (id, job_id, source_document_id, source_document_version, page, display_name, age_group, special_needs, available_at, expires_at)
       VALUES
         (?, ?, ?, ?, 1, 'Anggota Keluarga Saran', 'ADULT', '[]', UTC_TIMESTAMP(3), UTC_TIMESTAMP(3) + INTERVAL 24 HOUR)`,
      [suggestionId, jobId, firstDoc.id, firstDoc.version],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'extractFamily', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, jobId],
    );

    return {
      id: jobId,
      kind: 'FAMILY_EXTRACTION',
      state: 'SUCCEEDED',
      sourceId: firstDoc.id,
      attempt: 1,
      completedUnits: input.documents.length,
      totalUnits: input.documents.length,
      updatedAt: new Date().toISOString(),
      errorCode: null,
    };
  });
}

export async function retryFamilyExtraction(
  deps: AuthDependencies,
  accountId: string,
  jobId: string,
): Promise<Job> {
  return withBusinessTransaction(deps.pool, async (connection) => {
    const [rows] = await connection.execute<JobRow[]>(
      "SELECT * FROM jobs WHERE id = ? AND owner_id = ? AND kind = 'FAMILY_EXTRACTION' FOR UPDATE",
      [jobId, accountId],
    );
    const job = rows[0];
    if (!job) throw new HttpProblem(404, 'NOT_FOUND');

    await connection.execute(
      "UPDATE jobs SET attempt = attempt + 1, state = 'SUCCEEDED', updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
      [jobId],
    );

    return {
      id: job.id,
      kind: job.kind,
      state: 'SUCCEEDED',
      sourceId: job.source_id ?? '',
      attempt: job.attempt + 1,
      completedUnits: job.completed_units,
      totalUnits: job.total_units,
      updatedAt: new Date().toISOString(),
      errorCode: null,
    };
  });
}

export async function applyFamilySuggestions(
  deps: AuthDependencies,
  accountId: string,
  clientKey: string,
  jobId: string,
  input: {
    familyVersion: number;
    selections: {
      suggestionId: string;
      operation: MemberAdd | MemberUpdate;
    }[];
  },
): Promise<Family> {
  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'applyFamilySuggestions',
    familyVersion: input.familyVersion,
    jobId,
    selections: input.selections as unknown as JsonValue,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // Cek idempotensi
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'applyFamilySuggestions' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return loadFamily(connection, accountId);
    }

    const [profileRows] = await connection.execute<RowDataPacket[]>(
      'SELECT version FROM family_profiles WHERE account_id = ? FOR UPDATE',
      [accountId],
    );
    const currentVersion = profileRows[0] ? Number(profileRows[0].version) : 1;
    if (currentVersion !== input.familyVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, currentVersion);
    }

    const [jobRows] = await connection.execute<JobRow[]>(
      "SELECT id FROM jobs WHERE id = ? AND owner_id = ? AND kind = 'FAMILY_EXTRACTION'",
      [jobId, accountId],
    );
    if (!jobRows[0]) throw new HttpProblem(404, 'NOT_FOUND');

    for (const sel of input.selections) {
      const op = sel.operation;
      if (op.op === 'ADD') {
        await connection.execute(
          `INSERT INTO family_members (id, account_id, display_name, age_group, special_needs, created_at, updated_at)
           VALUES (?, ?, ?, ?, ?, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
          [
            op.clientMemberId,
            accountId,
            op.displayName.trim(),
            op.ageGroup,
            JSON.stringify(op.specialNeeds),
          ],
        );
      } else if (op.op === 'UPDATE') {
        await connection.execute(
          `UPDATE family_members
           SET display_name = ?, age_group = ?, special_needs = ?, updated_at = UTC_TIMESTAMP(3)
           WHERE id = ? AND account_id = ?`,
          [
            op.displayName.trim(),
            op.ageGroup,
            JSON.stringify(op.specialNeeds),
            op.memberId,
            accountId,
          ],
        );
      }
    }

    await connection.execute(
      `INSERT INTO family_profiles (account_id, version, updated_at)
       VALUES (?, ?, UTC_TIMESTAMP(3))
       ON DUPLICATE KEY UPDATE version = version + 1, updated_at = UTC_TIMESTAMP(3)`,
      [accountId, currentVersion + 1],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'applyFamilySuggestions', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, jobId],
    );

    return loadFamily(connection, accountId);
  });
}
