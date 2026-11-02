import { refreshGroup } from './group-state.js';
import { formatJob, retryJob, type JobRow } from '../ai/jobs.js';
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
import type { Job, Cleanup, CleanupPage } from '../vault/documents.js';

export interface Point {
  latitude: number;
  longitude: number;
  locationName: string;
}

export interface MediaItem {
  id: string;
  mediaType: string;
  sizeBytes: number;
  durationMs: number | null;
}

export interface Assessment {
  source: 'AI' | 'ADMIN' | 'NONE';
  relevance: 'MATCH' | 'MISMATCH' | 'INSUFFICIENT' | 'UNASSESSED';
  level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
  explanation: string;
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

export interface ReportSummaryPage {
  items: ReportSummary[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface Note {
  id: string;
  authorId: string;
  body: string;
  createdAt: string;
  correctionOf: string | null;
  correctionReason: string | null;
}

export interface ReportDetail {
  summary: ReportSummary;
  description: string;
  point: Point;
  occurredAt: string | null;
  media: MediaItem[];
  notes: Note[];
  nextNoteCursor: string | null;
  groupState: 'ACTIVE' | 'COMPLETED';
  aiAssessment: Assessment | null;
}

export interface Group {
  id: string;
  code: string;
  state: 'ACTIVE' | 'COMPLETED';
  locationName: string;
  level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
  reviewState: 'NEEDS_REVIEW' | 'REVIEWED';
  needsReviewSince: string | null;
  updatedAt: string;
  version: number;
  reportCount: number;
  completedAt: string | null;
}

export interface GroupDetail {
  group: Group;
  reports: ReportSummary[];
  nextReportCursor: string | null;
}

export interface GroupPage {
  items: Group[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

export interface Deletion {
  actionId: string;
  deletedAt: string;
  cleanup: Cleanup;
}

export interface Audit {
  id: string;
  actorId: string;
  action: string;
  objectId: string;
  createdAt: string;
  reason: string | null;
  outcome: string;
  version: number | null;
  cleanupState: 'PENDING' | 'RUNNING' | 'FAILED' | 'SUCCEEDED' | null;
}

export interface AuditPage {
  items: Audit[];
  nextCursor: string | null;
  serverTime: string;
  revision: number | null;
}

interface ReportRow extends RowDataPacket {
  id: string;
  owner_id: string;
  group_id: string;
  description: string;
  latitude: number | string;
  longitude: number | string;
  occurred_at: string | Date | null;
  accepted_at: string | Date;
  version: number;
  evidence_version: number;
  result_version: number;
  needs_review_since: string | Date | null;
  deleted_at: string | Date | null;
  location_label: string | null;
  group_state: 'ACTIVE' | 'COMPLETED';
  group_level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
}

interface AssessmentRow extends RowDataPacket {
  id: string;
  report_id: string;
  source: 'AI' | 'ADMIN' | 'NONE';
  relevance: 'MATCH' | 'MISMATCH' | 'INSUFFICIENT' | 'UNASSESSED';
  level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
  explanation: string;
  result_version: number;
}

interface CleanupRow extends RowDataPacket {
  id: string;
  object_id: string;
  state: 'PENDING' | 'RUNNING' | 'FAILED' | 'SUCCEEDED';
  attempt: number;
  updated_at: string | Date;
  error_code: string | null;
}

interface AuditRow extends RowDataPacket {
  id: string;
  actor_id: string;
  action: string;
  object_id: string;
  created_at: string | Date;
  reason: string | null;
  outcome: string;
  version: number | null;
  cleanup_state: 'PENDING' | 'RUNNING' | 'FAILED' | 'SUCCEEDED' | null;
}

function formatDate(val: string | Date | null | undefined): string | null {
  if (!val) return null;
  return new Date(val).toISOString();
}

function formatCleanup(row: CleanupRow): Cleanup {
  return {
    id: row.id,
    objectId: row.object_id,
    state: row.state,
    attempt: Number(row.attempt),
    updatedAt: new Date(row.updated_at).toISOString(),
    errorCode: row.error_code,
  };
}

async function recordAudit(
  connection: PoolConnection,
  entry: {
    actorId: string;
    action: string;
    objectId: string;
    reason?: string | null;
    outcome: string;
    version?: number | null;
    cleanupState?: 'PENDING' | 'RUNNING' | 'FAILED' | 'SUCCEEDED' | null;
  },
): Promise<string> {
  const auditId = randomUUID();
  await connection.execute(
    `INSERT INTO audit_logs (id, actor_id, action, object_id, created_at, reason, outcome, version, cleanup_state)
      VALUES (?, ?, ?, ?, UTC_TIMESTAMP(3), ?, ?, ?, ?)`,
    [
      auditId,
      entry.actorId,
      entry.action,
      entry.objectId,
      entry.reason ?? null,
      entry.outcome,
      entry.version ?? null,
      entry.cleanupState ?? null,
    ],
  );
  return auditId;
}

// 1. GET JOB & RETRY REPORT ANALYSIS
export async function getJob(
  deps: AuthDependencies,
  userId: string,
  userRole: string,
  jobId: string,
): Promise<Job> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<JobRow[]>(
      'SELECT * FROM jobs WHERE id = ?',
      [jobId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');
    if (
      row.owner_id !== userId &&
      !(userRole === 'ADMIN' && row.kind === 'REPORT_ANALYSIS')
    ) {
      throw new HttpProblem(403, 'FORBIDDEN');
    }
    return formatJob(row);
  });
}

export async function retryReportAnalysis(
  deps: AuthDependencies,
  userId: string,
  userRole: string,
  clientKey: string,
  reportId: string,
): Promise<Job> {
  const scope = actorScope(deps.keys.journal, 'account', userId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'retryReportAnalysis',
    reportId,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint, object_id FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'retryReportAnalysis' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<JobRow[]>(
        'SELECT * FROM jobs WHERE id = ?',
        [previousCmd[0].object_id as string],
      );
      if (existing[0]) return formatJob(existing[0]);
    }

    const [reports] = await connection.execute<ReportRow[]>(
      'SELECT * FROM reports WHERE id = ? AND deleted_at IS NULL FOR UPDATE',
      [reportId],
    );
    const report = reports[0];
    if (!report) throw new HttpProblem(404, 'NOT_FOUND');
    if (userRole !== 'ADMIN' && report.owner_id !== userId) {
      throw new HttpProblem(403, 'FORBIDDEN');
    }

    const [latest] = await connection.execute<JobRow[]>(
      "SELECT * FROM jobs WHERE source_id=? AND kind='REPORT_ANALYSIS' ORDER BY created_at DESC LIMIT 1",
      [reportId],
    );
    if (!latest[0]) throw new HttpProblem(409, 'CONFLICT');
    const jobId = latest[0].id;
    await retryJob(connection, report.owner_id, jobId, 'REPORT_ANALYSIS');

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'retryReportAnalysis', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, jobId],
    );

    const [jobRows] = await connection.execute<JobRow[]>(
      'SELECT * FROM jobs WHERE id = ?',
      [jobId],
    );
    return formatJob(jobRows[0]!);
  });
}

// Helper perakit ReportSummary
async function loadReportSummary(
  connection: PoolConnection,
  report: ReportRow,
): Promise<ReportSummary> {
  const [assessRows] = await connection.execute<AssessmentRow[]>(
    'SELECT * FROM assessments WHERE report_id = ? ORDER BY result_version DESC, created_at DESC LIMIT 1',
    [report.id],
  );
  const activeAssess = assessRows[0];
  const assessment: Assessment = activeAssess
    ? {
        source: activeAssess.source,
        relevance: activeAssess.relevance,
        level: activeAssess.level,
        explanation: activeAssess.explanation,
      }
    : {
        source: 'NONE',
        relevance: 'UNASSESSED',
        level: 'UNRATED',
        explanation: '',
      };

  const [jobRows] = await connection.execute<JobRow[]>(
    "SELECT state FROM jobs WHERE source_id = ? AND kind = 'REPORT_ANALYSIS' ORDER BY created_at DESC LIMIT 1",
    [report.id],
  );
  const jobState = (jobRows[0]?.state ??
    'QUEUED') as ReportSummary['analysisState'];

  const review: ReviewState = {
    evidenceVersion: report.evidence_version,
    resultVersion: report.result_version,
    reviewed: report.needs_review_since === null,
    needsReviewSince: formatDate(report.needs_review_since),
  };

  return {
    id: report.id,
    acceptedAt: new Date(report.accepted_at).toISOString(),
    groupId: report.group_id,
    analysisState: jobState,
    assessment,
    review,
    version: report.version,
  };
}

// 2. LIST ADMIN REPORTS
export async function listAdminReports(
  deps: AuthDependencies,
  adminId: string,
  query: {
    cursor?: string;
    q?: string;
    from?: string;
    to?: string;
    status?: string;
  },
): Promise<ReportSummaryPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      adminId,
      'admin-reports',
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const params: (string | number)[] = [];
    let sql = `
      SELECT r.*, g.location_label, g.state as group_state, g.level as group_level
      FROM reports r
      JOIN \`groups\` g ON r.group_id = g.id
      WHERE r.deleted_at IS NULL
    `;

    if (filter) {
      sql += ' AND (r.description LIKE ? OR g.code LIKE ?)';
      params.push(`%${filter}%`, `%${filter}%`);
    }

    if (query.from) {
      sql += ' AND r.accepted_at >= ?';
      params.push(
        new Date(query.from).toISOString().slice(0, 23).replace('T', ' '),
      );
    }
    if (query.to) {
      sql += ' AND r.accepted_at <= ?';
      params.push(
        new Date(query.to).toISOString().slice(0, 23).replace('T', ' '),
      );
    }

    if (query.status === 'NEEDS_REVIEW') {
      sql += ' AND r.needs_review_since IS NOT NULL';
    } else if (query.status === 'REVIEWED') {
      sql += ' AND r.needs_review_since IS NULL';
    }

    if (lastId) {
      sql += ' AND r.id < ?';
      params.push(lastId);
    }

    sql += ' ORDER BY r.accepted_at DESC, r.id DESC LIMIT 21';

    const [rows] = await connection.execute<ReportRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items: ReportSummary[] = [];
    for (const row of pageRows) {
      items.push(await loadReportSummary(connection, row));
    }

    let nextCursor: string | null = null;
    const lastItem = items[items.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: adminId,
        domain: 'admin-reports',
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

// 3. GET ADMIN REPORT DETAIL
export async function getAdminReport(
  deps: AuthDependencies,
  reportId: string,
): Promise<ReportDetail> {
  return withConnection(deps.pool, async (connection) => {
    return loadReportDetail(connection, reportId);
  });
}

async function loadReportDetail(
  connection: PoolConnection,
  reportId: string,
): Promise<ReportDetail> {
  const [rows] = await connection.execute<ReportRow[]>(
    `SELECT r.*, g.location_label, g.state as group_state, g.level as group_level
      FROM reports r
      JOIN \`groups\` g ON r.group_id = g.id
      WHERE r.id = ? AND r.deleted_at IS NULL`,
    [reportId],
  );
  const report = rows[0];
  if (!report) throw new HttpProblem(404, 'NOT_FOUND');

  const summary = await loadReportSummary(connection, report);

  // Ambil Media
  const [mediaRows] = await connection.execute<RowDataPacket[]>(
    `SELECT u.id, u.mime, u.bytes, u.duration_ms
      FROM report_media rm
      JOIN uploads u ON rm.upload_id = u.id
      WHERE rm.report_id = ?
      ORDER BY rm.order_index ASC`,
    [reportId],
  );
  const media: MediaItem[] = mediaRows.map((m) => ({
    id: m.id as string,
    mediaType: m.mime as string,
    sizeBytes: Number(m.bytes),
    durationMs: m.duration_ms !== null ? Number(m.duration_ms) : null,
  }));

  // Ambil Notes
  const [noteRows] = await connection.execute<RowDataPacket[]>(
    'SELECT * FROM notes WHERE report_id = ? ORDER BY created_at DESC LIMIT 20',
    [reportId],
  );
  const notes: Note[] = noteRows.map((n) => ({
    id: n.id as string,
    authorId: n.author_id as string,
    body: n.body as string,
    createdAt: new Date(n.created_at as string).toISOString(),
    correctionOf: (n.correction_of as string) || null,
    correctionReason: (n.correction_reason as string) || null,
  }));

  // Ambil AI Assessment
  const [aiRows] = await connection.execute<AssessmentRow[]>(
    "SELECT * FROM assessments WHERE report_id = ? AND source = 'AI' ORDER BY created_at DESC LIMIT 1",
    [reportId],
  );
  const aiAssess = aiRows[0];
  const aiAssessment: Assessment | null = aiAssess
    ? {
        source: 'AI',
        relevance: aiAssess.relevance,
        level: aiAssess.level,
        explanation: aiAssess.explanation,
      }
    : null;

  return {
    summary,
    description: report.description,
    point: {
      latitude: Number(report.latitude),
      longitude: Number(report.longitude),
      locationName: report.location_label || 'Lokasi Laporan',
    },
    occurredAt: formatDate(report.occurred_at),
    media,
    notes,
    nextNoteCursor: null,
    groupState: report.group_state,
    aiAssessment,
  };
}

// 4. PATCH /admin/reports/{reportId}/assessment
export async function correctAssessment(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  reportId: string,
  expectedVersion: number,
  input: {
    relevance: 'MATCH' | 'MISMATCH' | 'INSUFFICIENT';
    level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
    reason: string;
  },
): Promise<ReportDetail> {
  const reason = input.reason.normalize('NFC').trim();
  if (!reason || reason.length < 1 || reason.length > 500) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'correctAssessment',
    reportId,
    ifMatch: expectedVersion,
    relevance: input.relevance,
    level: input.level,
    reason,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'correctAssessment' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return loadReportDetail(connection, reportId);
    }

    const [reports] = await connection.execute<ReportRow[]>(
      'SELECT * FROM reports WHERE id = ? AND deleted_at IS NULL FOR UPDATE',
      [reportId],
    );
    const report = reports[0];
    if (!report) throw new HttpProblem(404, 'NOT_FOUND');
    if (report.version !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, report.version);
    }

    const newResultVersion = report.result_version + 1;
    const newVersion = report.version + 1;
    const assessId = randomUUID();

    await connection.execute(
      `INSERT INTO assessments (id, report_id, source, relevance, level, explanation, result_version, eligible, created_at)
        VALUES (?, ?, 'ADMIN', ?, ?, ?, ?, ?, UTC_TIMESTAMP(3))`,
      [
        assessId,
        reportId,
        input.relevance,
        input.level,
        reason,
        newResultVersion,
        input.relevance === 'MATCH' ? 1 : 0,
      ],
    );

    await connection.execute(
      'UPDATE reports SET result_version = ?, version = ?, updated_at = UTC_TIMESTAMP(3) WHERE id = ?',
      [newResultVersion, newVersion, reportId],
    );

    await refreshGroup(connection, report.group_id);

    await recordAudit(connection, {
      actorId: adminId,
      action: 'CORRECT_ASSESSMENT',
      objectId: reportId,
      reason,
      outcome: 'SUCCESS',
      version: newVersion,
    });

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'correctAssessment', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, reportId],
    );

    return loadReportDetail(connection, reportId);
  });
}

// 5. PUT /admin/reports/{reportId}/review
export async function reviewReport(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  reportId: string,
  input: {
    evidenceVersion: number;
    resultVersion: number;
  },
): Promise<ReviewState> {
  if (input.evidenceVersion < 1 || input.resultVersion < 1) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'reviewReport',
    reportId,
    evidenceVersion: input.evidenceVersion,
    resultVersion: input.resultVersion,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'reviewReport' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return {
        evidenceVersion: input.evidenceVersion,
        resultVersion: input.resultVersion,
        reviewed: true,
        needsReviewSince: null,
      };
    }

    const [reports] = await connection.execute<ReportRow[]>(
      'SELECT * FROM reports WHERE id = ? AND deleted_at IS NULL FOR UPDATE',
      [reportId],
    );
    const report = reports[0];
    if (!report) throw new HttpProblem(404, 'NOT_FOUND');

    const satisfies =
      input.evidenceVersion >= report.evidence_version &&
      input.resultVersion >= report.result_version;

    if (satisfies) {
      await connection.execute(
        'UPDATE reports SET needs_review_since = NULL, version = version + 1, updated_at = UTC_TIMESTAMP(3) WHERE id = ?',
        [reportId],
      );

      await recordAudit(connection, {
        actorId: adminId,
        action: 'REVIEW_REPORT',
        objectId: reportId,
        outcome: 'REVIEWED',
        version: report.version + 1,
      });
    }

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'reviewReport', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, reportId],
    );

    return {
      evidenceVersion: input.evidenceVersion,
      resultVersion: input.resultVersion,
      reviewed: satisfies,
      needsReviewSince: satisfies
        ? null
        : formatDate(report.needs_review_since),
    };
  });
}

// 6. POST /admin/reports/{reportId}/moves
export async function moveReport(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  reportId: string,
  expectedVersion: number,
  input: {
    sourceGroupVersion: number;
    destination:
      | { kind: 'EXISTING'; groupId: string; groupVersion: number }
      | { kind: 'NEW_ACTIVE' };
    reason: string;
  },
): Promise<ReportDetail> {
  const reason = input.reason.normalize('NFC').trim();
  if (!reason || reason.length < 1 || reason.length > 500) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'moveReport',
    reportId,
    ifMatch: expectedVersion,
    sourceGroupVersion: input.sourceGroupVersion,
    destination: input.destination as unknown as JsonValue,
    reason,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'moveReport' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      return loadReportDetail(connection, reportId);
    }

    const [reports] = await connection.execute<ReportRow[]>(
      'SELECT * FROM reports WHERE id = ? AND deleted_at IS NULL FOR UPDATE',
      [reportId],
    );
    const report = reports[0];
    if (!report) throw new HttpProblem(404, 'NOT_FOUND');
    if (report.version !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, report.version);
    }

    const [srcGroups] = await connection.execute<RowDataPacket[]>(
      'SELECT * FROM `groups` WHERE id = ? FOR UPDATE',
      [report.group_id],
    );
    const srcGroup = srcGroups[0];
    if (!srcGroup || Number(srcGroup.version) !== input.sourceGroupVersion) {
      throw new HttpProblem(
        409,
        'VERSION_CONFLICT',
        null,
        srcGroup ? Number(srcGroup.version) : 1,
      );
    }

    let targetGroupId: string;
    if (input.destination.kind === 'EXISTING') {
      const [destGroups] = await connection.execute<RowDataPacket[]>(
        "SELECT * FROM `groups` WHERE id = ? AND state = 'ACTIVE' FOR UPDATE",
        [input.destination.groupId],
      );
      const destGroup = destGroups[0];
      if (!destGroup) throw new HttpProblem(404, 'NOT_FOUND');
      if (Number(destGroup.version) !== input.destination.groupVersion) {
        throw new HttpProblem(
          409,
          'VERSION_CONFLICT',
          null,
          Number(destGroup.version),
        );
      }
      await connection.execute(
        'UPDATE `groups` SET version = version + 1, updated_at = UTC_TIMESTAMP(3) WHERE id = ?',
        [input.destination.groupId],
      );
      targetGroupId = input.destination.groupId;
    } else {
      // NEW_ACTIVE
      targetGroupId = randomUUID();
      const code = `GRP-${Date.now().toString(36).toUpperCase()}-${Math.floor(Math.random() * 1000)}`;
      await connection.execute(
        `INSERT INTO \`groups\` (id, code, state, location_label, source_report_id, level, created_at, updated_at, version)
          VALUES (?, ?, 'ACTIVE', ?, ?, 'UNRATED', UTC_TIMESTAMP(3), UTC_TIMESTAMP(3), 1)`,
        [
          targetGroupId,
          code,
          (srcGroup.location_label as string) || 'Lokasi Baru',
          reportId,
        ],
      );
    }

    await connection.execute(
      'UPDATE `groups` SET version = version + 1, updated_at = UTC_TIMESTAMP(3) WHERE id = ?',
      [report.group_id],
    );

    const newVersion = report.version + 1;
    await connection.execute(
      'UPDATE reports SET group_id = ?, version = ?, updated_at = UTC_TIMESTAMP(3) WHERE id = ?',
      [targetGroupId, newVersion, reportId],
    );

    await recordAudit(connection, {
      actorId: adminId,
      action: 'MOVE_REPORT',
      objectId: reportId,
      reason,
      outcome: 'MOVED',
      version: newVersion,
    });

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'moveReport', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, reportId],
    );

    return loadReportDetail(connection, reportId);
  });
}

// 7. POST /admin/reports/{reportId}/notes
export async function appendReportNote(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  reportId: string,
  input: {
    body: string;
    correctionOf?: string;
    correctionReason?: string;
  },
): Promise<Note> {
  const body = input.body.normalize('NFC').trim();
  if (!body || body.length < 1 || body.length > 1000) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const correctionOf = input.correctionOf?.trim() || null;
  const correctionReason =
    input.correctionReason?.normalize('NFC').trim() || null;
  if (
    (correctionOf && !correctionReason) ||
    (!correctionOf && correctionReason)
  ) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'appendReportNote',
    reportId,
    body,
    ...(correctionOf ? { correctionOf, correctionReason } : {}),
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint, object_id FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'appendReportNote' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<RowDataPacket[]>(
        'SELECT * FROM notes WHERE id = ?',
        [previousCmd[0].object_id as string],
      );
      if (existing[0]) {
        return {
          id: existing[0].id as string,
          authorId: existing[0].author_id as string,
          body: existing[0].body as string,
          createdAt: new Date(existing[0].created_at as string).toISOString(),
          correctionOf: (existing[0].correction_of as string) || null,
          correctionReason: (existing[0].correction_reason as string) || null,
        };
      }
    }

    const [reports] = await connection.execute<RowDataPacket[]>(
      'SELECT id FROM reports WHERE id = ? AND deleted_at IS NULL',
      [reportId],
    );
    if (!reports[0]) throw new HttpProblem(404, 'NOT_FOUND');

    if (correctionOf) {
      const [prevNotes] = await connection.execute<RowDataPacket[]>(
        'SELECT id FROM notes WHERE id = ? AND report_id = ?',
        [correctionOf, reportId],
      );
      if (!prevNotes[0]) throw new HttpProblem(422, 'VALIDATION_FAILED');
    }

    const noteId = randomUUID();
    await connection.execute(
      `INSERT INTO notes (id, report_id, author_id, body, correction_of, correction_reason, created_at)
        VALUES (?, ?, ?, ?, ?, ?, UTC_TIMESTAMP(3))`,
      [noteId, reportId, adminId, body, correctionOf, correctionReason],
    );

    await recordAudit(connection, {
      actorId: adminId,
      action: 'APPEND_NOTE',
      objectId: noteId,
      outcome: 'SUCCESS',
    });

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'appendReportNote', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, noteId],
    );

    return {
      id: noteId,
      authorId: adminId,
      body,
      createdAt: new Date().toISOString(),
      correctionOf,
      correctionReason,
    };
  });
}

// 8. POST /admin/reports/{reportId}/deletions
export async function deleteReport(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  reportId: string,
  expectedVersion: number,
  input: { reason: string },
): Promise<Deletion> {
  const reason = input.reason.normalize('NFC').trim();
  if (!reason || reason.length < 1 || reason.length > 500) {
    throw new HttpProblem(422, 'VALIDATION_FAILED');
  }

  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'deleteReport',
    reportId,
    ifMatch: expectedVersion,
    reason,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint, object_id FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'deleteReport' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existingCleanups] = await connection.execute<CleanupRow[]>(
        "SELECT * FROM cleanup_jobs WHERE object_id = ? AND object_type = 'REPORT' ORDER BY created_at DESC LIMIT 1",
        [reportId],
      );
      return {
        actionId: previousCmd[0].id as string,
        deletedAt: new Date().toISOString(),
        cleanup: existingCleanups[0]
          ? formatCleanup(existingCleanups[0])
          : {
              id: randomUUID(),
              objectId: reportId,
              state: 'PENDING',
              attempt: 0,
              updatedAt: new Date().toISOString(),
              errorCode: null,
            },
      };
    }

    const [reports] = await connection.execute<ReportRow[]>(
      'SELECT * FROM reports WHERE id = ? AND deleted_at IS NULL FOR UPDATE',
      [reportId],
    );
    const report = reports[0];
    if (!report) throw new HttpProblem(404, 'NOT_FOUND');
    if (report.version !== expectedVersion) {
      throw new HttpProblem(409, 'VERSION_CONFLICT', null, report.version);
    }

    const newVersion = report.version + 1;
    await connection.execute(
      'UPDATE reports SET deleted_at = UTC_TIMESTAMP(3), needs_review_since = NULL, version = ?, updated_at = UTC_TIMESTAMP(3) WHERE id = ?',
      [newVersion, reportId],
    );

    await refreshGroup(connection, report.group_id);
    await connection.execute(
      "UPDATE jobs SET state='CANCELLED',generation=generation+1,result_json=NULL,lease_token=NULL,lease_until=NULL WHERE source_id=? AND kind='REPORT_ANALYSIS'",
      [reportId],
    );
    const cleanupId = randomUUID();
    await connection.execute(
      `INSERT INTO cleanup_jobs (id, object_type, object_id, owner_id, state, attempt, created_at, updated_at)
        VALUES (?, 'REPORT', ?, ?, 'PENDING', 0, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [cleanupId, reportId, report.owner_id],
    );

    await recordAudit(connection, {
      actorId: adminId,
      action: 'DELETE_REPORT',
      objectId: reportId,
      reason,
      outcome: 'DELETED',
      version: newVersion,
      cleanupState: 'PENDING',
    });

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'deleteReport', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, reportId],
    );

    return {
      actionId,
      deletedAt: new Date().toISOString(),
      cleanup: {
        id: cleanupId,
        objectId: reportId,
        state: 'PENDING',
        attempt: 0,
        updatedAt: new Date().toISOString(),
        errorCode: null,
      },
    };
  });
}

// 9. GROUPS: listGroups, getGroup, listGroupReports, completeGroup
interface GroupRawRow extends RowDataPacket {
  id: string;
  code: string;
  state: 'ACTIVE' | 'COMPLETED';
  location_label: string | null;
  level: 'LOW' | 'MEDIUM' | 'HIGH' | 'UNRATED';
  created_at: string | Date;
  completed_at: string | Date | null;
  updated_at: string | Date;
  version: number;
  report_count: number | string;
  min_needs_review_since: string | Date | null;
}

function formatGroup(row: GroupRawRow): Group {
  const needsReviewSince = formatDate(row.min_needs_review_since);
  return {
    id: row.id,
    code: row.code,
    state: row.state,
    locationName: row.location_label || 'Lokasi Kejadian',
    level: row.level,
    reviewState: needsReviewSince !== null ? 'NEEDS_REVIEW' : 'REVIEWED',
    needsReviewSince,
    updatedAt: new Date(row.updated_at).toISOString(),
    version: Number(row.version),
    reportCount: Number(row.report_count ?? 0),
    completedAt: formatDate(row.completed_at),
  };
}

export async function listGroups(
  deps: AuthDependencies,
  adminId: string,
  query: {
    cursor?: string;
    q?: string;
    state?: string;
    queue?: string;
  },
): Promise<GroupPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      adminId,
      'admin-groups',
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const params: (string | number)[] = [];
    let sql = `
      SELECT g.*,
        COUNT(r.id) as report_count,
        MIN(r.needs_review_since) as min_needs_review_since
      FROM \`groups\` g
      LEFT JOIN reports r ON g.id = r.group_id AND r.deleted_at IS NULL
      WHERE 1=1
    `;

    if (query.state) {
      sql += ' AND g.state = ?';
      params.push(query.state);
    }

    if (filter) {
      sql += ' AND (g.code LIKE ? OR g.location_label LIKE ?)';
      params.push(`%${filter}%`, `%${filter}%`);
    }

    sql += ' GROUP BY g.id';

    if (query.queue === 'REVIEW_NEEDED') {
      sql +=
        ' HAVING g.state = "ACTIVE" AND min_needs_review_since IS NOT NULL';
    }

    if (lastId) {
      sql += ' AND g.id < ?';
      params.push(lastId);
    }

    if (query.queue === 'REVIEW_NEEDED') {
      sql += ` ORDER BY
        CASE g.level WHEN 'HIGH' THEN 1 WHEN 'MEDIUM' THEN 2 WHEN 'LOW' THEN 3 ELSE 4 END ASC,
        min_needs_review_since ASC,
        g.id ASC
        LIMIT 21`;
    } else {
      sql += ' ORDER BY g.created_at DESC, g.id DESC LIMIT 21';
    }

    const [rows] = await connection.execute<GroupRawRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items = pageRows.map(formatGroup);
    let nextCursor: string | null = null;
    const lastItem = items[items.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: adminId,
        domain: 'admin-groups',
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

export async function getGroup(
  deps: AuthDependencies,
  groupId: string,
): Promise<GroupDetail> {
  return withConnection(deps.pool, async (connection) => {
    const [rows] = await connection.execute<GroupRawRow[]>(
      `SELECT g.*,
        COUNT(r.id) as report_count,
        MIN(r.needs_review_since) as min_needs_review_since
        FROM \`groups\` g
        LEFT JOIN reports r ON g.id = r.group_id AND r.deleted_at IS NULL
        WHERE g.id = ?
        GROUP BY g.id`,
      [groupId],
    );
    const groupRow = rows[0];
    if (!groupRow) throw new HttpProblem(404, 'NOT_FOUND');

    const group = formatGroup(groupRow);

    const [reportRows] = await connection.execute<ReportRow[]>(
      `SELECT r.*, g.location_label, g.state as group_state, g.level as group_level
        FROM reports r
        JOIN \`groups\` g ON r.group_id = g.id
        WHERE r.group_id = ? AND r.deleted_at IS NULL
        ORDER BY r.accepted_at DESC, r.id DESC
        LIMIT 20`,
      [groupId],
    );

    const reports: ReportSummary[] = [];
    for (const r of reportRows) {
      reports.push(await loadReportSummary(connection, r));
    }

    return {
      group,
      reports,
      nextReportCursor: null,
    };
  });
}

export async function listGroupReports(
  deps: AuthDependencies,
  adminId: string,
  groupId: string,
  query: { cursor?: string; q?: string },
): Promise<ReportSummaryPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      adminId,
      'group-reports',
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const [groupCheck] = await connection.execute<RowDataPacket[]>(
      'SELECT id FROM `groups` WHERE id = ?',
      [groupId],
    );
    if (!groupCheck[0]) throw new HttpProblem(404, 'NOT_FOUND');

    const params: (string | number)[] = [groupId];
    let sql = `
      SELECT r.*, g.location_label, g.state as group_state, g.level as group_level
      FROM reports r
      JOIN \`groups\` g ON r.group_id = g.id
      WHERE r.group_id = ? AND r.deleted_at IS NULL
    `;

    if (filter) {
      sql += ' AND r.description LIKE ?';
      params.push(`%${filter}%`);
    }

    if (lastId) {
      sql += ' AND r.id < ?';
      params.push(lastId);
    }

    sql += ' ORDER BY r.accepted_at DESC, r.id DESC LIMIT 21';

    const [rows] = await connection.execute<ReportRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items: ReportSummary[] = [];
    for (const row of pageRows) {
      items.push(await loadReportSummary(connection, row));
    }

    let nextCursor: string | null = null;
    const lastItem = items[items.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: adminId,
        domain: 'group-reports',
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

export async function completeGroup(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  groupId: string,
  expectedVersion: number,
): Promise<Group> {
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'completeGroup',
    groupId,
    ifMatch: expectedVersion,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'completeGroup' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [gRows] = await connection.execute<GroupRawRow[]>(
        `SELECT g.*, COUNT(r.id) as report_count, MIN(r.needs_review_since) as min_needs_review_since
          FROM \`groups\` g
          LEFT JOIN reports r ON g.id = r.group_id AND r.deleted_at IS NULL
          WHERE g.id = ?
          GROUP BY g.id`,
        [groupId],
      );
      if (gRows[0]) return formatGroup(gRows[0]);
    }

    const [groups] = await connection.execute<RowDataPacket[]>(
      'SELECT * FROM `groups` WHERE id = ? FOR UPDATE',
      [groupId],
    );
    const group = groups[0];
    if (!group) throw new HttpProblem(404, 'NOT_FOUND');
    if (Number(group.version) !== expectedVersion) {
      throw new HttpProblem(
        409,
        'VERSION_CONFLICT',
        null,
        Number(group.version),
      );
    }

    const newVersion = Number(group.version) + 1;
    await connection.execute(
      "UPDATE `groups` SET state = 'COMPLETED', completed_at = UTC_TIMESTAMP(3), version = ?, updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
      [newVersion, groupId],
    );

    await recordAudit(connection, {
      actorId: adminId,
      action: 'COMPLETE_GROUP',
      objectId: groupId,
      outcome: 'COMPLETED',
      version: newVersion,
    });

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'completeGroup', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, groupId],
    );

    const [gRows] = await connection.execute<GroupRawRow[]>(
      `SELECT g.*, COUNT(r.id) as report_count, MIN(r.needs_review_since) as min_needs_review_since
        FROM \`groups\` g
        LEFT JOIN reports r ON g.id = r.group_id AND r.deleted_at IS NULL
        WHERE g.id = ?
        GROUP BY g.id`,
      [groupId],
    );
    return formatGroup(gRows[0]!);
  });
}

// 10. CLEANUP: listReportCleanup, retryReportCleanup
export async function listReportCleanup(
  deps: AuthDependencies,
  adminId: string,
  query: { cursor?: string; q?: string },
): Promise<CleanupPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      adminId,
      'admin-cleanup',
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const params: string[] = [];
    let sql = "SELECT * FROM cleanup_jobs WHERE object_type = 'REPORT'";

    if (filter) {
      sql += ' AND (object_id LIKE ? OR state LIKE ?)';
      params.push(`%${filter}%`, `%${filter}%`);
    }

    if (lastId) {
      sql += ' AND id < ?';
      params.push(lastId);
    }

    sql += ' ORDER BY created_at DESC, id DESC LIMIT 21';

    const [rows] = await connection.execute<CleanupRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items = pageRows.map(formatCleanup);
    let nextCursor: string | null = null;
    const lastItem = items[items.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: adminId,
        domain: 'admin-cleanup',
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

export async function retryReportCleanup(
  deps: AuthDependencies,
  adminId: string,
  clientKey: string,
  cleanupId: string,
): Promise<Cleanup> {
  const scope = actorScope(deps.keys.journal, 'account', adminId);
  const hash = fingerprint(deps.keys.journal, {
    action: 'retryReportCleanup',
    cleanupId,
  });

  return withBusinessTransaction(deps.pool, async (connection) => {
    const [previousCmd] = await connection.execute<RowDataPacket[]>(
      'SELECT id, operation, fingerprint FROM commands WHERE actor_scope = ? AND client_key = ?',
      [scope, clientKey],
    );
    if (previousCmd[0]) {
      if (
        previousCmd[0].operation !== 'retryReportCleanup' ||
        !timingSafeEqual(previousCmd[0].fingerprint as Buffer, hash)
      ) {
        throw new HttpProblem(409, 'IDEMPOTENCY_CONFLICT');
      }
      const [existing] = await connection.execute<CleanupRow[]>(
        'SELECT * FROM cleanup_jobs WHERE id = ?',
        [cleanupId],
      );
      if (existing[0]) return formatCleanup(existing[0]);
    }

    const [rows] = await connection.execute<CleanupRow[]>(
      "SELECT * FROM cleanup_jobs WHERE id = ? AND object_type = 'REPORT' FOR UPDATE",
      [cleanupId],
    );
    const row = rows[0];
    if (!row) throw new HttpProblem(404, 'NOT_FOUND');

    await connection.execute(
      "UPDATE cleanup_jobs SET state = 'RUNNING', attempt = attempt + 1, updated_at = UTC_TIMESTAMP(3) WHERE id = ?",
      [cleanupId],
    );

    await recordAudit(connection, {
      actorId: adminId,
      action: 'RETRY_CLEANUP',
      objectId: cleanupId,
      outcome: 'RUNNING',
    });

    const actionId = randomUUID();
    await connection.execute(
      `INSERT INTO commands (id, actor_scope, client_key, operation, fingerprint, state, object_id, committed_at)
        VALUES (?, ?, ?, 'retryReportCleanup', ?, 'COMMITTED', ?, UTC_TIMESTAMP(3))`,
      [actionId, scope, clientKey, hash, cleanupId],
    );

    const [updatedRows] = await connection.execute<CleanupRow[]>(
      'SELECT * FROM cleanup_jobs WHERE id = ?',
      [cleanupId],
    );
    return formatCleanup(updatedRows[0]!);
  });
}

// 11. AUDIT: listAudit
export async function listAudit(
  deps: AuthDependencies,
  adminId: string,
  query: { cursor?: string; q?: string },
): Promise<AuditPage> {
  const filter = query.q ? query.q.normalize('NFC').trim() : '';

  let lastId: string | null = null;
  if (query.cursor) {
    const decoded = decodeCursor(
      deps.keys.cursor,
      query.cursor,
      adminId,
      'admin-audit',
      filter || 'default',
    );
    lastId = decoded.lastId;
  }

  return withConnection(deps.pool, async (connection) => {
    const params: string[] = [];
    let sql = 'SELECT * FROM audit_logs WHERE 1=1';

    if (filter) {
      sql += ' AND (action LIKE ? OR reason LIKE ? OR object_id LIKE ?)';
      params.push(`%${filter}%`, `%${filter}%`, `%${filter}%`);
    }

    if (lastId) {
      sql += ' AND id < ?';
      params.push(lastId);
    }

    sql += ' ORDER BY created_at DESC, id DESC LIMIT 21';

    const [rows] = await connection.execute<AuditRow[]>(sql, params);
    const hasMore = rows.length > 20;
    const pageRows = rows.slice(0, 20);

    const items: Audit[] = pageRows.map((a) => ({
      id: a.id,
      actorId: a.actor_id,
      action: a.action,
      objectId: a.object_id,
      createdAt: new Date(a.created_at).toISOString(),
      reason: a.reason,
      outcome: a.outcome,
      version: a.version !== null ? Number(a.version) : null,
      cleanupState: a.cleanup_state,
    }));

    let nextCursor: string | null = null;
    const lastItem = items[items.length - 1];
    if (hasMore && lastItem) {
      nextCursor = encodeCursor(deps.keys.cursor, {
        actorId: adminId,
        domain: 'admin-audit',
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
