import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { withBusinessTransaction } from '../src/db/pool.js';
import { actorScope } from '../src/security/fingerprint.js';
import { readSecurityKeys } from '../src/security/keys.js';
import { hashPassword } from '../src/security/password.js';
import type {
  ReportSummaryPage,
  ReportDetail,
  ReviewState,
  Note,
  Deletion,
  GroupPage,
  GroupDetail,
  Group,
  AuditPage,
} from '../src/reporting/admin.js';
import type { Job, CleanupPage, Cleanup } from '../src/vault/documents.js';

export async function verifyAdminReporting(
  app: FastifyInstance,
  pool: Pool,
): Promise<void> {
  const keys = readSecurityKeys(process.env);
  const adminEmail = `${randomUUID()}@example.invalid`;
  const citizenEmail = `${randomUUID()}@example.invalid`;
  const password = 'sandi admin reporting 123';

  // 1. Signup & login Citizen
  const citizenSignupRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/signup',
    headers: { 'idempotency-key': randomUUID() },
    payload: {
      displayName: 'Warga Pelapor Admin Test',
      email: citizenEmail,
      password,
    },
  });
  assert.equal(citizenSignupRes.statusCode, 201);
  const citizenId = citizenSignupRes.json<{
    data: { account: { id: string } };
  }>().data.account.id;

  const citizenLoginRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/login',
    headers: { 'idempotency-key': randomUUID() },
    payload: { email: citizenEmail, password, client: 'ANDROID' },
  });
  assert.equal(citizenLoginRes.statusCode, 200);
  const citizenToken = citizenLoginRes.json<{
    data: { accessToken: string };
  }>().data.accessToken;

  // 2. Buat akun Admin & login ADMIN_WEB
  const adminId = randomUUID();
  const { salt, hash } = await hashPassword(password);
  await withBusinessTransaction(pool, async (connection) => {
    await connection.execute(
      `INSERT INTO accounts (id, email_normalized, display_name, role, password_salt, password_hash, credential_epoch, version, created_at)
        VALUES (?, ?, 'Admin Pelapor Test', 'ADMIN', ?, ?, 1, 1, UTC_TIMESTAMP(3))`,
      [adminId, adminEmail.toLowerCase(), salt, hash],
    );
  });

  const adminLoginRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/login',
    headers: { 'idempotency-key': randomUUID() },
    payload: { email: adminEmail, password, client: 'ADMIN_WEB' },
  });
  assert.equal(adminLoginRes.statusCode, 200);
  const adminToken = adminLoginRes.json<{
    data: { accessToken: string };
  }>().data.accessToken;

  const groupId1 = randomUUID();
  const reportId = randomUUID();
  const uploadId = randomUUID();

  // Setup data test
  await withBusinessTransaction(pool, async (connection) => {
    // 3. Group awal
    await connection.execute(
      `INSERT INTO \`groups\` (id, code, state, location_label, level, created_at, updated_at, version)
        VALUES (?, 'GRP-ADMIN-TEST-1', 'ACTIVE', 'Kecamatan Kuranji', 'LOW', UTC_TIMESTAMP(3), UTC_TIMESTAMP(3), 1)`,
      [groupId1],
    );

    // 4. Upload awal
    await connection.execute(
      `INSERT INTO uploads (id, owner_id, purpose, origin, blob_key, digest, mime, bytes, state, expires_at, created_at, updated_at)
        VALUES (?, ?, 'REPORT', 'CAMERA', ?, 'dummy-digest', 'image/jpeg', 1024, 'ATTACHED', DATE_ADD(UTC_TIMESTAMP(3), INTERVAL 1 DAY), UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [uploadId, citizenId, `uploads/${uploadId}.jpg`],
    );

    // 5. Report awal
    await connection.execute(
      `INSERT INTO reports (id, owner_id, group_id, description, latitude, longitude, location_source, occurred_at, accepted_at, applied_time, time_source, accept_seq, version, evidence_version, result_version, needs_review_since, created_at, updated_at)
        VALUES (?, ?, ?, 'Banjir setinggi 40cm merendam jalan utama', -0.924, 100.362, 'GPS', UTC_TIMESTAMP(3), UTC_TIMESTAMP(3), UTC_TIMESTAMP(3), 'ACCEPTED', 1, 1, 1, 1, UTC_TIMESTAMP(3), UTC_TIMESTAMP(3), UTC_TIMESTAMP(3))`,
      [reportId, citizenId, groupId1],
    );

    // 6. Report media
    await connection.execute(
      `INSERT INTO report_media (report_id, upload_id, order_index)
        VALUES (?, ?, 0)`,
      [reportId, uploadId],
    );

    // 7. Assessment awal
    await connection.execute(
      `INSERT INTO assessments (id, report_id, source, relevance, level, explanation, result_version, eligible, created_at)
        VALUES (?, ?, 'AI', 'MATCH', 'LOW', 'Genangan air terdeteksi setinggi lutut', 1, 1, UTC_TIMESTAMP(3))`,
      [randomUUID(), reportId],
    );
  });

  let createdNewGroupId: string | null = null;
  let reportCleanupId: string | null = null;
  let reportJobId: string | null = null;

  try {
    // 1. GET /api/v1/admin/reports
    const listReportsRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/reports',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(listReportsRes.statusCode, 200);
    const reportsPage = listReportsRes.json<{ data: ReportSummaryPage }>().data;
    assert.ok(reportsPage.items.length >= 1);
    const foundReport = reportsPage.items.find((r) => r.id === reportId);
    assert.ok(foundReport);
    assert.equal(foundReport.groupId, groupId1);
    assert.equal(foundReport.version, 1);

    // 2. GET /api/v1/admin/reports/:reportId
    const getReportRes = await app.inject({
      method: 'GET',
      url: `/api/v1/admin/reports/${reportId}`,
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(getReportRes.statusCode, 200);
    assert.equal(getReportRes.headers.etag, '"1"');
    const reportDetail = getReportRes.json<{ data: ReportDetail }>().data;
    assert.equal(reportDetail.summary.id, reportId);
    assert.equal(reportDetail.media.length, 1);
    assert.equal(reportDetail.media[0]?.id, uploadId);
    assert.equal(reportDetail.aiAssessment?.source, 'AI');

    // 3. PATCH /api/v1/admin/reports/:reportId/assessment (Koreksi asesmen jadi MEDIUM)
    const patchAssessRes = await app.inject({
      method: 'PATCH',
      url: `/api/v1/admin/reports/${reportId}/assessment`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"1"',
      },
      payload: {
        relevance: 'MATCH',
        level: 'MEDIUM',
        reason: 'Kedalaman air mencapai 70cm menurut rambu lalu lintas',
      },
    });
    assert.equal(patchAssessRes.statusCode, 200);
    assert.equal(patchAssessRes.headers.etag, '"2"');
    const patchedDetail = patchAssessRes.json<{ data: ReportDetail }>().data;
    assert.equal(patchedDetail.summary.version, 2);
    assert.equal(patchedDetail.summary.assessment.level, 'MEDIUM');
    assert.equal(patchedDetail.summary.assessment.source, 'ADMIN');

    // 4. PUT /api/v1/admin/reports/:reportId/review (Tandai review selesai)
    const reviewRes = await app.inject({
      method: 'PUT',
      url: `/api/v1/admin/reports/${reportId}/review`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        evidenceVersion: 1,
        resultVersion: 2,
      },
    });
    assert.equal(reviewRes.statusCode, 200);
    const reviewData = reviewRes.json<{ data: ReviewState }>().data;
    assert.equal(reviewData.reviewed, true);
    assert.equal(reviewData.needsReviewSince, null);

    // 5. POST /api/v1/admin/reports/:reportId/notes (Tambah catatan tindak lanjut admin)
    const noteRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/reports/${reportId}/notes`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        body: 'Tim BPBD regu 2 telah diterjunkan ke lokasi dengan perahu karet.',
      },
    });
    assert.equal(noteRes.statusCode, 201);
    const noteData = noteRes.json<{ data: Note }>().data;
    assert.ok(noteData.id);
    assert.equal(noteData.authorId, adminId);
    assert.ok(noteData.body.includes('BPBD regu 2'));

    // 6. POST /api/v1/admin/reports/:reportId/moves (Pindahkan ke kelompok baru NEW_ACTIVE)
    const moveRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/reports/${reportId}/moves`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"3"', // version naik setelah patch(2) dan review(3)
      },
      payload: {
        sourceGroupVersion: 1,
        destination: { kind: 'NEW_ACTIVE' },
        reason: 'Titik genangan berada di DAS berbeda dari kelompok awal',
      },
    });
    assert.equal(moveRes.statusCode, 200);
    const movedDetail = moveRes.json<{ data: ReportDetail }>().data;
    assert.notEqual(movedDetail.summary.groupId, groupId1);
    createdNewGroupId = movedDetail.summary.groupId;
    assert.equal(movedDetail.summary.version, 4);

    // 7. GET /api/v1/admin/groups
    const listGroupsRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/groups',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(listGroupsRes.statusCode, 200);
    const groupsPage = listGroupsRes.json<{ data: GroupPage }>().data;
    assert.ok(groupsPage.items.length >= 2);

    // 8. GET /api/v1/admin/groups/:groupId
    const getGroupRes = await app.inject({
      method: 'GET',
      url: `/api/v1/admin/groups/${createdNewGroupId}`,
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(getGroupRes.statusCode, 200);
    const groupDetail = getGroupRes.json<{ data: GroupDetail }>().data;
    assert.equal(groupDetail.group.id, createdNewGroupId);
    assert.equal(groupDetail.group.reportCount, 1);
    assert.equal(groupDetail.reports.length, 1);

    // 9. GET /api/v1/admin/groups/:groupId/reports
    const listGroupReportsRes = await app.inject({
      method: 'GET',
      url: `/api/v1/admin/groups/${createdNewGroupId}/reports`,
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(listGroupReportsRes.statusCode, 200);
    const gReportsPage = listGroupReportsRes.json<{ data: ReportSummaryPage }>()
      .data;
    assert.equal(gReportsPage.items.length, 1);
    assert.equal(gReportsPage.items[0]?.id, reportId);

    // 10. POST /api/v1/admin/groups/:groupId/complete (Tandai kelompok kejadian selesai)
    const completeGroupRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/groups/${createdNewGroupId}/complete`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': `"${groupDetail.group.version}"`,
      },
    });
    assert.equal(completeGroupRes.statusCode, 200);
    const completedGroup = completeGroupRes.json<{ data: Group }>().data;
    assert.equal(completedGroup.state, 'COMPLETED');
    assert.ok(completedGroup.completedAt);

    // 11. POST /api/v1/reports/:reportId/analysis-retries (Retry analisis asinkron)
    const retryAnalysisRes = await app.inject({
      method: 'POST',
      url: `/api/v1/reports/${reportId}/analysis-retries`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
    });
    assert.equal(retryAnalysisRes.statusCode, 202);
    const retryJob = retryAnalysisRes.json<{ data: Job }>().data;
    assert.equal(retryJob.kind, 'REPORT_ANALYSIS');
    assert.equal(retryJob.state, 'QUEUED');
    reportJobId = retryJob.id;

    // 12. GET /api/v1/jobs/:jobId
    const getJobRes = await app.inject({
      method: 'GET',
      url: `/api/v1/jobs/${reportJobId}`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(getJobRes.statusCode, 200);
    assert.equal(getJobRes.json<{ data: Job }>().data.id, reportJobId);

    // 13. POST /api/v1/admin/reports/:reportId/deletions (Hapus laporan & jadwalkan pembersihan)
    const deleteReportRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/reports/${reportId}/deletions`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"4"', // version saat ini 4
      },
      payload: {
        reason: 'Laporan duplikat diverifikasi oleh tim posko.',
      },
    });
    assert.equal(deleteReportRes.statusCode, 202);
    const deletionData = deleteReportRes.json<{ data: Deletion }>().data;
    assert.ok(deletionData.cleanup.id);
    assert.equal(deletionData.cleanup.objectId, reportId);
    reportCleanupId = deletionData.cleanup.id;

    // 14. GET /api/v1/admin/cleanup
    const listCleanupRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/cleanup',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(listCleanupRes.statusCode, 200);
    const cleanupPage = listCleanupRes.json<{ data: CleanupPage }>().data;
    assert.ok(cleanupPage.items.some((c) => c.id === reportCleanupId));

    // 15. POST /api/v1/admin/cleanup/:cleanupId/retry
    const retryCleanupRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/cleanup/${reportCleanupId}/retry`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
    });
    assert.equal(retryCleanupRes.statusCode, 202);
    assert.equal(
      retryCleanupRes.json<{ data: Cleanup }>().data.state,
      'RUNNING',
    );

    // 16. GET /api/v1/admin/audit
    const listAuditRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/audit',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(listAuditRes.statusCode, 200);
    const auditPage = listAuditRes.json<{ data: AuditPage }>().data;
    assert.ok(auditPage.items.length >= 4);
    assert.ok(auditPage.items.some((a) => a.action === 'CORRECT_ASSESSMENT'));
    assert.ok(auditPage.items.some((a) => a.action === 'REVIEW_REPORT'));
    assert.ok(auditPage.items.some((a) => a.action === 'MOVE_REPORT'));
    assert.ok(auditPage.items.some((a) => a.action === 'DELETE_REPORT'));
  } finally {
    // Cleanup DB test
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute('DELETE FROM audit_logs WHERE actor_id = ?', [
        adminId,
      ]);
      await connection.execute(
        "DELETE FROM cleanup_jobs WHERE object_id = ? AND object_type = 'REPORT'",
        [reportId],
      );
      if (reportJobId) {
        await connection.execute('DELETE FROM jobs WHERE id = ?', [
          reportJobId,
        ]);
      }
      await connection.execute('DELETE FROM notes WHERE report_id = ?', [
        reportId,
      ]);
      await connection.execute('DELETE FROM assessments WHERE report_id = ?', [
        reportId,
      ]);
      await connection.execute('DELETE FROM report_media WHERE report_id = ?', [
        reportId,
      ]);
      await connection.execute('DELETE FROM reports WHERE id = ?', [reportId]);
      if (createdNewGroupId) {
        await connection.execute('DELETE FROM `groups` WHERE id = ?', [
          createdNewGroupId,
        ]);
      }
      await connection.execute('DELETE FROM `groups` WHERE id = ?', [groupId1]);
      await connection.execute('DELETE FROM uploads WHERE id = ?', [uploadId]);
      await connection.execute(
        'DELETE FROM sessions WHERE account_id IN (?, ?)',
        [adminId, citizenId],
      );
      await connection.execute(
        'DELETE FROM commands WHERE actor_scope IN (?, ?)',
        [
          actorScope(keys.journal, 'account', adminId),
          actorScope(keys.journal, 'account', citizenId),
        ],
      );
      await connection.execute(
        'DELETE FROM recovery_verifiers WHERE account_id = ?',
        [citizenId],
      );
      await connection.execute('DELETE FROM accounts WHERE id IN (?, ?)', [
        adminId,
        citizenId,
      ]);
    });
  }
}
