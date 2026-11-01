import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { RowDataPacket } from 'mysql2/promise';
import type { AuthDependencies } from '../auth/signup.js';
import { withBusinessTransaction, withConnection } from '../db/pool.js';
import { actorScope, fingerprint } from '../security/fingerprint.js';
import { encodeCursor, decodeCursor } from '../security/cursor.js';
import {
  detectMediaType,
  saveMediaBlob,
  readMediaBlob,
} from '../storage/vault.js';
import { getSettings, getAccountQuotaState } from './quota.js';
import { HttpProblem } from '../http/problem.js';

export interface UploadInput {
  purpose: 'REPORT' | 'DOCUMENT';
  origin: 'CAMERA' | 'GALLERY' | 'FILE';
}

export interface Upload {
  id: string;
  purpose: 'REPORT' | 'DOCUMENT';
  origin: 'CAMERA' | 'GALLERY' | 'FILE';
  state: 'READY' | 'ATTACHED' | 'EXPIRED' | 'DELETED';
  mediaType: string;
  sizeBytes: number;
  sha256: string;
  durationMs: number | null;
  pageCount: number | null;
  expiresAt: string;
}

export interface Point {
  latitude: number;
  longitude: number;
  source: 'GPS' | 'MANUAL';
}

export interface DeviceSignals {
  mockLocation: 'DETECTED' | 'NOT_DETECTED' | 'UNKNOWN';
  developerMode: 'DETECTED' | 'NOT_DETECTED' | 'UNKNOWN';
  observedAt: string;
  buildId: string;
}

export interface SubmissionInput {
  uploadIds: string[];
  description: string;
  point: Point;
  occurredAt?: string | null;
  deviceSignals: DeviceSignals;
}

export interface SubmissionState {
  id: string;
  state: 'ACCEPTED' | 'REJECTED_CLOSED' | 'CLOSED' | 'DELETED';
  reportId: string | null;
  acceptedAt: string | null;
  errorCode: string | null;
}

export interface Assessment {
  source: 'AI' | 'ADMIN' | 'NONE';
  relevance: 'MATCH' | 'MISMATCH' | 'INSUFFICIENT' | 'UNASSESSED';
  level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
  explanation: string;
  resultVersion: number;
  eligible: boolean;
}

export interface ReviewState {
  evidenceVersion: number;
  resultVersion: number;
  reviewed: boolean;
  needsReviewSince: string | null;
}

export interface ReportSummary {
  id: string;
  acceptedAt: string;
  groupId: string;
  analysisState: 'QUEUED' | 'RUNNING' | 'SUCCEEDED' | 'FAILED' | 'CANCELLED';
  assessment: Assessment;
  review: ReviewState;
  version: number;
}

export interface MediaItem {
  id: string;
  mediaType: string;
  sizeBytes: number;
  durationMs: number | null;
}

export interface NoteItem {
  id: string;
  reportId: string;
  body: string;
  createdAt: string;
  authorId: string;
  correctionOf: string | null;
  correctionReason: string | null;
}

export interface ReportDetail {
  summary: ReportSummary;
  description: string;
  point: Point;
  occurredAt: string | null;
  media: MediaItem[];
  notes: NoteItem[];
  nextNoteCursor: string | null;
  groupState: 'ACTIVE' | 'COMPLETED';
  aiAssessment: Assessment | null;
}

export interface HistoryItemPage {
  items: (
    | ReportSummary
    | { id: string; state: 'DELETED'; deletedAt: string; visibleUntil: string }
  )[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface NotePage {
  items: NoteItem[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

interface UploadRow extends RowDataPacket {
  id: string;
  owner_id: string;
  purpose: 'REPORT' | 'DOCUMENT';
  origin: 'CAMERA' | 'GALLERY' | 'FILE';
  blob_key: string;
  digest: string;
  mime: string;
  bytes: number;
  duration_ms: number | null;
  page_count: number | null;
  state: 'READY' | 'ATTACHED' | 'EXPIRED' | 'DELETED';
  expires_at: string;
  created_at: string;
  updated_at: string;
}

interface SubmissionRow extends RowDataPacket {
  id: string;
  owner_id: string;
  report_id: string | null;
  state: 'ACCEPTED' | 'REJECTED_CLOSED' | 'CLOSED' | 'DELETED';
  accepted_at: string | null;
  error_code: string | null;
}

interface ReportRow extends RowDataPacket {
  id: string;
  owner_id: string;
  group_id: string;
  description: string;
  latitude: number | string;
  longitude: number | string;
  location_source: 'GPS' | 'MANUAL';
  occurred_at: string | null;
  accepted_at: string;
  version: number;
  evidence_version: number;
  result_version: number;
  needs_review_since: string | null;
  deleted_at: string | null;
  group_state: 'ACTIVE' | 'COMPLETED';
}

interface AssessmentRow extends RowDataPacket {
  id: string;
  report_id: string;
  source: 'AI' | 'ADMIN' | 'NONE';
  relevance: 'MATCH' | 'MISMATCH' | 'INSUFFICIENT' | 'UNASSESSED';
  level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
  explanation: string;
  result_version: number;
  eligible: number | boolean;
}

interface NoteRow extends RowDataPacket {
  id: string;
  report_id: string;
  author_id: string;
  body: string;
  correction_of: string | null;
  correction_reason: string | null;
  created_at: string;
}

function rowToUpload(row: UploadRow): Upload {
  return {
    id: row.id,
    purpose: row.purpose,
    origin: row.origin,
    state: row.state,
    mediaType: row.mime,
    sizeBytes: Number(row.bytes),
    sha256: row.digest,
    durationMs: row.duration_ms !== null ? Number(row.duration_ms) : null,
    pageCount: row.page_count !== null ? Number(row.page_count) : null,
    expiresAt: new Date(row.expires_at).toISOString(),
  };
}

export async function createUpload(
  deps: AuthDependencies,
  accountId: string,
  uploadId: string,
  input: UploadInput,
  fileData: Buffer,
): Promise<{ upload: Upload; isReplay: boolean }> {
  if (input.purpose !== 'REPORT' && input.purpose !== 'DOCUMENT') {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (!['CAMERA', 'GALLERY', 'FILE'].includes(input.origin)) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }
  if (input.purpose === 'REPORT' && input.origin === 'FILE') {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const detected = detectMediaType(fileData);

  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'uploadMedia',
    origin: input.origin,
    purpose: input.purpose,
    sizeBytes: fileData.length,
    uploadId,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, uploadId],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'uploadMedia' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [rows] = await connection.execute<UploadRow[]>(
        'SELECT * FROM uploads WHERE id = ? AND owner_id = ?',
        [uploadId, accountId],
      );
      if (!rows[0]) throw new HttpProblem(404, 'NOT_FOUND');
      return { upload: rowToUpload(rows[0]), isReplay: true };
    }

    const { digest, blobKey } = await saveMediaBlob(uploadId, fileData);

    await connection.execute(
      `INSERT INTO uploads
         (id, owner_id, purpose, origin, blob_key, digest, mime, bytes, duration_ms, page_count, state, expires_at, created_at, updated_at)
       VALUES
         (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'READY', UTC_TIMESTAMP(3) + INTERVAL 24 HOUR, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [
        uploadId,
        accountId,
        input.purpose,
        input.origin,
        blobKey,
        digest,
        detected.mime,
        fileData.length,
        detected.durationMs,
        detected.pageCount,
      ],
    );

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'uploadMedia', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, uploadId, hash, uploadId],
    );

    const [createdRows] = await connection.execute<UploadRow[]>(
      'SELECT * FROM uploads WHERE id = ?',
      [uploadId],
    );
    const created = createdRows[0];
    if (!created) throw new Error('Gagal menyimpan upload.');

    return { upload: rowToUpload(created), isReplay: false };
  });
}

export async function getUpload(
  deps: AuthDependencies,
  accountId: string,
  uploadId: string,
): Promise<Upload> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<UploadRow[]>(
      'SELECT * FROM uploads WHERE id = ? AND owner_id = ?',
      [uploadId, accountId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    return rowToUpload(row);
  });
}

export async function submitReport(
  deps: AuthDependencies,
  accountId: string,
  submissionId: string,
  payload: SubmissionInput,
): Promise<{ state: SubmissionState; isReplay: boolean }> {
  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'submitReport',
    description: payload.description.normalize('NFC').trim(),
    point: {
      latitude: payload.point.latitude,
      longitude: payload.point.longitude,
      source: payload.point.source,
    },
    submissionId,
    uploadIds: [...payload.uploadIds].sort(),
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    // 1. Cek idempotensi perintah replay
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, submissionId],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'submitReport' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [subs] = await connection.execute<SubmissionRow[]>(
        'SELECT * FROM submissions WHERE id = ? AND owner_id = ?',
        [submissionId, accountId],
      );
      const s = subs[0];
      if (!s) throw new HttpProblem(404, 'NOT_FOUND');
      return {
        state: {
          id: s.id,
          state: s.state,
          reportId: s.report_id,
          acceptedAt: s.accepted_at
            ? new Date(s.accepted_at).toISOString()
            : null,
          errorCode: s.error_code,
        },
        isReplay: true,
      };
    }

    // 2. Cek apakah submissionId sudah pernah ditutup
    const [existingSubs] = await connection.execute<SubmissionRow[]>(
      'SELECT state FROM submissions WHERE id = ? AND owner_id = ?',
      [submissionId, accountId],
    );
    if (existingSubs[0] && existingSubs[0].state !== 'ACCEPTED') {
      throw new HttpProblem(409, 'CONFLICT');
    }

    // 3. Validasi input deskripsi dan titik
    const desc = payload.description.normalize('NFC').trim();
    if (!desc || desc.length < 1 || desc.length > 2000) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    const { latitude, longitude, source } = payload.point;
    if (
      typeof latitude !== 'number' ||
      latitude < -90 ||
      latitude > 90 ||
      typeof longitude !== 'number' ||
      longitude < -180 ||
      longitude > 180 ||
      (source !== 'GPS' && source !== 'MANUAL')
    ) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    // Waktu kejadian: jika ada, tidak boleh sebelum 30 hari yang lalu atau lebih dari 5 menit ke depan
    if (payload.occurredAt) {
      const occurred = new Date(payload.occurredAt).getTime();
      const now = Date.now();
      const thirtyDaysMs = 30 * 24 * 60 * 60 * 1000;
      const fiveMinMs = 5 * 60 * 1000;
      if (
        Number.isNaN(occurred) ||
        occurred < now - thirtyDaysMs ||
        occurred > now + fiveMinMs
      ) {
        throw new HttpProblem(422, 'VALIDATION_FAILED');
      }
    }

    // 4. Validasi media upload
    if (
      !Array.isArray(payload.uploadIds) ||
      payload.uploadIds.length < 1 ||
      payload.uploadIds.length > 2
    ) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    const [uploadRows] = await connection.execute<UploadRow[]>(
      `SELECT * FROM uploads WHERE id IN (${payload.uploadIds.map(() => '?').join(',')}) AND owner_id = ? FOR UPDATE`,
      [...payload.uploadIds, accountId],
    );

    if (uploadRows.length !== payload.uploadIds.length) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    for (const u of uploadRows) {
      if (u.purpose !== 'REPORT' || u.state !== 'READY') {
        throw new HttpProblem(422, 'VALIDATION_FAILED');
      }
    }

    // Tidak boleh campur foto dan video:
    const hasVideo = uploadRows.some((u) => u.mime === 'video/mp4');
    const hasPhoto = uploadRows.some((u) => u.mime.startsWith('image/'));
    if (hasVideo && hasPhoto) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }
    if (hasVideo && uploadRows.length > 1) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    // 5. Periksa KTP terverifikasi
    const [ktpRows] = await connection.execute<RowDataPacket[]>(
      'SELECT active_document_id FROM ktp_states WHERE account_id = ?',
      [accountId],
    );
    if (!ktpRows[0] || !ktpRows[0].active_document_id) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    // 6. Periksa aturan galeri
    const settings = await getSettings(connection);
    const hasGallery = uploadRows.some((u) => u.origin === 'GALLERY');
    if (!settings.galleryEnabled && hasGallery) {
      throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    // 7. Periksa kuota
    const quotaState = await getAccountQuotaState(
      connection,
      accountId,
      settings,
    );
    if (quotaState.remaining <= 0) {
      throw new HttpProblem(
        429,
        'AUTH_THROTTLED',
        quotaState.nextReleaseAt
          ? Math.max(
              1,
              Math.ceil(
                (new Date(quotaState.nextReleaseAt).getTime() - Date.now()) /
                  1000,
              ),
            )
          : 3600,
      );
    }

    // 8. Simpan laporan satu kali
    const reportId = randomUUID();
    let groupId: string;
    const [groupRows] = await connection.execute<RowDataPacket[]>(
      "SELECT id FROM `groups` WHERE state = 'ACTIVE' ORDER BY created_at DESC LIMIT 1",
    );
    if (groupRows[0]) {
      groupId = groupRows[0].id as string;
    } else {
      groupId = randomUUID();
      const code = `GR-${randomUUID().slice(0, 8).toUpperCase()}`;
      await connection.execute(
        `INSERT INTO \`groups\` (id, code, state, level, created_at, updated_at, version)
         VALUES (?, ?, 'ACTIVE', 'UNRATED', UTC_TIMESTAMP(3), UTC_TIMESTAMP(3), 1)`,
        [groupId, code],
      );
    }

    // Insert ke quota_ledger untuk memotong kuota
    const [ledgerResult] = await connection.execute<
      { insertId: number } & RowDataPacket[]
    >(
      `INSERT INTO quota_ledger (account_id, report_id, accepted_at)
       VALUES (?, ?, UTC_TIMESTAMP(3))`,
      [accountId, reportId],
    );
    const acceptSeq = ledgerResult.insertId;

    const occurredAtVal = payload.occurredAt
      ? new Date(payload.occurredAt)
      : null;
    const timeSource = occurredAtVal ? 'OCCURRED' : 'ACCEPTED';

    await connection.execute(
      `INSERT INTO reports
         (id, owner_id, group_id, description, latitude, longitude, location_source, occurred_at, accepted_at, applied_time, time_source, accept_seq, version, evidence_version, result_version, created_at, updated_at)
       VALUES
         (?, ?, ?, ?, ?, ?, ?, ?, UTC_TIMESTAMP(3), COALESCE(?, UTC_TIMESTAMP(3)), ?, ?, 1, 1, 1, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [
        reportId,
        accountId,
        groupId,
        desc,
        latitude,
        longitude,
        source,
        occurredAtVal,
        occurredAtVal,
        timeSource,
        acceptSeq,
      ],
    );

    // Hubungkan media dan ubah status upload menjadi ATTACHED
    for (let i = 0; i < payload.uploadIds.length; i++) {
      const uId = payload.uploadIds[i];
      if (!uId) continue;
      await connection.execute(
        `INSERT INTO report_media (report_id, upload_id, order_index)
         VALUES (?, ?, ?)`,
        [reportId, uId, i],
      );
      await connection.execute(
        "UPDATE uploads SET state = 'ATTACHED', updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
        [uId],
      );
    }

    // Default AI assessment
    const assessmentId = randomUUID();
    await connection.execute(
      `INSERT INTO assessments (id, report_id, source, relevance, level, explanation, result_version, eligible, created_at)
       VALUES (?, ?, 'AI', 'UNASSESSED', 'UNRATED', 'Menunggu pemrosesan analisis', 1, 1, UTC_TIMESTAMP(3))`,
      [assessmentId, reportId],
    );

    // Simpan submission state
    await connection.execute(
      `INSERT INTO submissions (id, owner_id, report_id, state, accepted_at, error_code, created_at, updated_at)
       VALUES (?, ?, ?, 'ACCEPTED', UTC_TIMESTAMP(3), NULL, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [submissionId, accountId, reportId],
    );

    // Catat command idempotensi
    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'submitReport', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, submissionId, hash, submissionId],
    );

    const [subRows] = await connection.execute<SubmissionRow[]>(
      'SELECT * FROM submissions WHERE id = ?',
      [submissionId],
    );
    const sub = subRows[0];
    if (!sub) throw new Error('Gagal membuat submission.');

    return {
      state: {
        id: sub.id,
        state: sub.state,
        reportId: sub.report_id,
        acceptedAt: sub.accepted_at
          ? new Date(sub.accepted_at).toISOString()
          : null,
        errorCode: sub.error_code,
      },
      isReplay: false,
    };
  });
}

export async function getSubmission(
  deps: AuthDependencies,
  accountId: string,
  submissionId: string,
): Promise<SubmissionState> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<SubmissionRow[]>(
      'SELECT * FROM submissions WHERE id = ? AND owner_id = ?',
      [submissionId, accountId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    return {
      id: row.id,
      state: row.state,
      reportId: row.report_id,
      acceptedAt: row.accepted_at
        ? new Date(row.accepted_at).toISOString()
        : null,
      errorCode: row.error_code,
    };
  });
}

export async function closeSubmission(
  deps: AuthDependencies,
  accountId: string,
  submissionId: string,
  clientKey: string,
): Promise<SubmissionState> {
  const scope = actorScope(deps.keys.journal, 'account', accountId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'closeSubmission',
    submissionId,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'closeSubmission' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [subs] = await connection.execute<SubmissionRow[]>(
        'SELECT * FROM submissions WHERE id = ? AND owner_id = ?',
        [submissionId, accountId],
      );
      const s = subs[0];
      if (!s) throw new HttpProblem(404, 'NOT_FOUND');
      return {
        id: s.id,
        state: s.state,
        reportId: s.report_id,
        acceptedAt: s.accepted_at
          ? new Date(s.accepted_at).toISOString()
          : null,
        errorCode: s.error_code,
      };
    }

    const [rows] = await connection.execute<SubmissionRow[]>(
      'SELECT * FROM submissions WHERE id = ? AND owner_id = ? FOR UPDATE',
      [submissionId, accountId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');

    if (row.state !== 'CLOSED') {
      await connection.execute(
        "UPDATE submissions SET state = 'CLOSED', updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
        [submissionId],
      );
    }

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
       VALUES (?, ?, ?, 'closeSubmission', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, submissionId],
    );

    return {
      id: row.id,
      state: 'CLOSED',
      reportId: row.report_id,
      acceptedAt: row.accepted_at
        ? new Date(row.accepted_at).toISOString()
        : null,
      errorCode: row.error_code,
    };
  });
}

export async function listOwnReports(
  deps: AuthDependencies,
  accountId: string,
  query: { cursor?: string; q?: string },
): Promise<HistoryItemPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      accountId,
      'reports',
      filter,
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    let sql =
      'SELECT r.*, g.state as group_state FROM reports r JOIN `groups` g ON r.group_id = g.id WHERE r.owner_id = ?';
    const params: (string | number)[] = [accountId];

    if (filter) {
      const escaped = filter.replace(/([%_\\])/g, '\\$1');
      sql += ' AND r.description LIKE ?';
      params.push(`%${escaped}%`);
    }

    if (lastId) {
      sql += ' AND r.id > ?';
      params.push(lastId);
    }

    sql += ' ORDER BY r.id ASC LIMIT 21';

    const [rows] = await connection.execute<ReportRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const itemsRows = hasMore ? rows.slice(0, 20) : rows;

    const items: HistoryItemPage['items'] = [];
    for (const r of itemsRows) {
      if (r.deleted_at) {
        items.push({
          id: r.id,
          state: 'DELETED',
          deletedAt: new Date(r.deleted_at).toISOString(),
          visibleUntil: new Date(
            new Date(r.deleted_at).getTime() + 7 * 24 * 3600 * 1000,
          ).toISOString(),
        });
        continue;
      }

      // Ambil assessment aktif
      const [asmRows] = await connection.execute<AssessmentRow[]>(
        'SELECT * FROM assessments WHERE report_id = ? ORDER BY result_version DESC LIMIT 1',
        [r.id],
      );
      const asm = asmRows[0];
      const assessment: Assessment = asm
        ? {
            source: asm.source,
            relevance: asm.relevance,
            level: asm.level,
            explanation: asm.explanation,
            resultVersion: asm.result_version,
            eligible: Boolean(asm.eligible),
          }
        : {
            source: 'NONE',
            relevance: 'UNASSESSED',
            level: 'UNRATED',
            explanation: '',
            resultVersion: 1,
            eligible: true,
          };

      items.push({
        id: r.id,
        acceptedAt: new Date(r.accepted_at).toISOString(),
        groupId: r.group_id,
        analysisState: 'QUEUED',
        assessment,
        review: {
          evidenceVersion: r.evidence_version,
          resultVersion: r.result_version,
          reviewed: false,
          needsReviewSince: r.needs_review_since
            ? new Date(r.needs_review_since).toISOString()
            : null,
        },
        version: r.version,
      });
    }

    let nextCursor: string | null = null;
    if (hasMore && itemsRows.length > 0) {
      const last = itemsRows[itemsRows.length - 1];
      if (last) {
        nextCursor = encodeCursor(deps.keys.cursor, {
          actorId: accountId,
          domain: 'reports',
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

export async function getOwnReport(
  deps: AuthDependencies,
  accountId: string,
  reportId: string,
): Promise<ReportDetail> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<ReportRow[]>(
      'SELECT r.*, g.state as group_state FROM reports r JOIN `groups` g ON r.group_id = g.id WHERE r.id = ? AND r.owner_id = ?',
      [reportId, accountId],
    );
    const r = rows[0];
    if (!r) throw new HttpProblem(404, 'NOT_FOUND');
    if (r.deleted_at) throw new HttpProblem(410, 'GONE');

    // Ambil media
    const [mediaRows] = await connection.execute<RowDataPacket[]>(
      `SELECT u.id, u.mime as mediaType, u.bytes as sizeBytes, u.duration_ms as durationMs
       FROM report_media rm
       JOIN uploads u ON rm.upload_id = u.id
       WHERE rm.report_id = ?
       ORDER BY rm.order_index ASC`,
      [reportId],
    );

    const media: MediaItem[] = mediaRows.map((m) => ({
      id: m.id as string,
      mediaType: m.mediaType as string,
      sizeBytes: Number(m.sizeBytes),
      durationMs: m.durationMs !== null ? Number(m.durationMs) : null,
    }));

    // Ambil notes
    const [noteRows] = await connection.execute<NoteRow[]>(
      'SELECT * FROM notes WHERE report_id = ? ORDER BY created_at ASC LIMIT 20',
      [reportId],
    );
    const notes: NoteItem[] = noteRows.map((n) => ({
      id: n.id,
      reportId: n.report_id,
      body: n.body,
      createdAt: new Date(n.created_at).toISOString(),
      authorId: n.author_id,
      correctionOf: n.correction_of,
      correctionReason: n.correction_reason,
    }));

    // Ambil assessment
    const [asmRows] = await connection.execute<AssessmentRow[]>(
      'SELECT * FROM assessments WHERE report_id = ? ORDER BY result_version DESC LIMIT 1',
      [reportId],
    );
    const asm = asmRows[0];
    const assessment: Assessment = asm
      ? {
          source: asm.source,
          relevance: asm.relevance,
          level: asm.level,
          explanation: asm.explanation,
          resultVersion: asm.result_version,
          eligible: Boolean(asm.eligible),
        }
      : {
          source: 'NONE',
          relevance: 'UNASSESSED',
          level: 'UNRATED',
          explanation: '',
          resultVersion: 1,
          eligible: true,
        };

    return {
      summary: {
        id: r.id,
        acceptedAt: new Date(r.accepted_at).toISOString(),
        groupId: r.group_id,
        analysisState: 'QUEUED',
        assessment,
        review: {
          evidenceVersion: r.evidence_version,
          resultVersion: r.result_version,
          reviewed: false,
          needsReviewSince: r.needs_review_since
            ? new Date(r.needs_review_since).toISOString()
            : null,
        },
        version: r.version,
      },
      description: r.description,
      point: {
        latitude: Number(r.latitude),
        longitude: Number(r.longitude),
        source: r.location_source,
      },
      occurredAt: r.occurred_at ? new Date(r.occurred_at).toISOString() : null,
      media,
      notes,
      nextNoteCursor: null,
      groupState: r.group_state,
      aiAssessment: assessment.source === 'AI' ? assessment : null,
    };
  });
}

export async function listReportNotes(
  deps: AuthDependencies,
  accountId: string,
  userRole: string,
  reportId: string,
  query: { cursor?: string; q?: string },
): Promise<NotePage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      accountId,
      `report_notes:${reportId}`,
      filter,
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    // Periksa izin: pemilik atau admin
    const [repRows] = await connection.execute<RowDataPacket[]>(
      'SELECT owner_id FROM reports WHERE id = ?',
      [reportId],
    );
    const rep = repRows[0];
    if (!rep) throw new HttpProblem(404, 'NOT_FOUND');
    if (rep.owner_id !== accountId && userRole !== 'ADMIN') {
      throw new HttpProblem(404, 'NOT_FOUND');
    }

    let sql = 'SELECT * FROM notes WHERE report_id = ?';
    const params: (string | number)[] = [reportId];

    if (filter) {
      const escaped = filter.replace(/([%_\\])/g, '\\$1');
      sql += ' AND body LIKE ?';
      params.push(`%${escaped}%`);
    }

    if (lastId) {
      sql += ' AND id > ?';
      params.push(lastId);
    }

    sql += ' ORDER BY id ASC LIMIT 21';

    const [rows] = await connection.execute<NoteRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const itemRows = hasMore ? rows.slice(0, 20) : rows;

    const items: NoteItem[] = itemRows.map((n) => ({
      id: n.id,
      reportId: n.report_id,
      body: n.body,
      createdAt: new Date(n.created_at).toISOString(),
      authorId: n.author_id,
      correctionOf: n.correction_of,
      correctionReason: n.correction_reason,
    }));

    let nextCursor: string | null = null;
    if (hasMore && itemRows.length > 0) {
      const last = itemRows[itemRows.length - 1];
      if (last) {
        nextCursor = encodeCursor(deps.keys.cursor, {
          actorId: accountId,
          domain: `report_notes:${reportId}`,
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

export async function getMediaStream(
  deps: AuthDependencies,
  accountId: string,
  userRole: string,
  mediaId: string,
  rangeHeader?: string,
): Promise<{
  data: Buffer;
  mime: string;
  totalSize: number;
  isRange: boolean;
  rangeStart?: number;
  rangeEnd?: number;
}> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<UploadRow[]>(
      'SELECT * FROM uploads WHERE id = ?',
      [mediaId],
    );
    const upload = rows[0];
    if (!upload) throw new HttpProblem(404, 'NOT_FOUND');
    if (upload.state === 'DELETED') throw new HttpProblem(410, 'GONE');

    // Hak akses
    if (upload.purpose === 'DOCUMENT') {
      if (upload.owner_id !== accountId) {
        throw new HttpProblem(404, 'NOT_FOUND');
      }
    } else {
      if (upload.owner_id !== accountId && userRole !== 'ADMIN') {
        throw new HttpProblem(404, 'NOT_FOUND');
      }
    }

    let range: { start: number; end: number } | undefined;
    if (rangeHeader && /^bytes=([0-9]+-[0-9]*|-[0-9]+)$/.test(rangeHeader)) {
      const parts = rangeHeader.slice(6).split('-');
      const startStr = parts[0];
      const endStr = parts[1];
      const total = Number(upload.bytes);

      let start = startStr
        ? Number.parseInt(startStr, 10)
        : total - Number.parseInt(endStr!, 10);
      let end = endStr ? Number.parseInt(endStr, 10) : total - 1;

      if (start < 0) start = 0;
      if (end >= total) end = total - 1;
      if (start <= end) {
        range = { start, end };
      }
    }

    const blob = await readMediaBlob(upload.blob_key, range);
    return {
      data: blob.data,
      mime: upload.mime,
      totalSize: blob.totalSize,
      isRange: Boolean(range),
      ...(range ? { rangeStart: range.start, rangeEnd: range.end } : {}),
    };
  });
}
