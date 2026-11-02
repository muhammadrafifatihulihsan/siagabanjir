import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { hashPassword } from '../src/security/password.js';
import { readSecurityKeys } from '../src/security/keys.js';
import { actorScope } from '../src/security/fingerprint.js';
import { withBusinessTransaction } from '../src/db/pool.js';
import type {
  Upload,
  SubmissionState,
  ReportDetail,
  HistoryItemPage,
  NotePage,
} from '../src/reporting/submissions.js';

function buildMultipartBody(
  boundary: string,
  fields: Record<string, string>,
  file?: { name: string; filename: string; mime: string; data: Buffer },
): Buffer {
  const parts: Buffer[] = [];
  for (const [key, val] of Object.entries(fields)) {
    parts.push(
      Buffer.from(
        `--${boundary}\r\nContent-Disposition: form-data; name="${key}"\r\n\r\n${val}\r\n`,
      ),
    );
  }
  if (file) {
    parts.push(
      Buffer.from(
        `--${boundary}\r\nContent-Disposition: form-data; name="${file.name}"; filename="${file.filename}"\r\nContent-Type: ${file.mime}\r\n\r\n`,
      ),
    );
    parts.push(file.data);
    parts.push(Buffer.from('\r\n'));
  }
  parts.push(Buffer.from(`--${boundary}--\r\n`));
  return Buffer.concat(parts);
}

export async function verifySubmissions(app: FastifyInstance, pool: Pool) {
  const keys = readSecurityKeys(process.env);
  const citizenEmail = `${randomUUID()}@example.invalid`;
  const adminEmail = `${randomUUID()}@example.invalid`;
  const password = 'sandi pelaporan submissions 123';

  // 1. Buat akun warga via signup
  const signupRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/signup',
    headers: { 'idempotency-key': randomUUID() },
    payload: {
      displayName: 'Warga Pelapor Dua',
      email: citizenEmail,
      password,
    },
  });
  assert.equal(signupRes.statusCode, 201);
  const citizenId = signupRes.json<{
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

  // 2. Buat akun admin di database
  const adminId = randomUUID();
  const { salt, hash } = await hashPassword(password);
  await withBusinessTransaction(pool, async (connection) => {
    await connection.execute(
      `INSERT INTO accounts (id, email_normalized, display_name, role, password_salt, password_hash, credential_epoch, version, created_at)
        VALUES (?, ?, 'Admin Peninjau', 'ADMIN', ?, ?, 1, 1, UTC_TIMESTAMP(3))`,
      [adminId, adminEmail.toLowerCase(), salt, hash],
    );
    // Aktifkan KTP untuk warga
    await connection.execute(
      `INSERT INTO ktp_states (account_id, active_document_id, version, updated_at)
        VALUES (?, ?, 1, UTC_TIMESTAMP(3))`,
      [citizenId, randomUUID()],
    );
    // Pastikan quota settings galleryEnabled = true untuk testing
    await connection.execute(
      `UPDATE quota_settings
        SET gallery_enabled = 1, quota_count = 5, quota_hours = 12, version = version + 1, updated_at = UTC_TIMESTAMP(3)
        WHERE id = 1`,
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

  const uploadId1 = randomUUID();
  const uploadId2 = randomUUID();
  let createdReportId: string | null = null;
  const boundary = '----SiagaBanjirBoundaryTest123456';

  try {
    // 3. PUT /api/v1/me/uploads/:uploadId
    // Dummy JPEG: FF D8 FF E0 00 10 4A 46 49 46 ...
    const dummyJpeg = Buffer.from([
      0xff, 0xd8, 0xff, 0xe0, 0x00, 0x10, 0x4a, 0x46, 0x49, 0x46, 0x00, 0x01,
      0x01, 0x01, 0x00, 0x48, 0x00, 0x48, 0x00, 0x00, 0xff, 0xdb, 0x00, 0x43,
      0x00, 0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0xff, 0xd9,
    ]);

    const multipartPayload1 = buildMultipartBody(
      boundary,
      { purpose: 'REPORT', origin: 'CAMERA' },
      {
        name: 'file',
        filename: 'foto1.jpg',
        mime: 'image/jpeg',
        data: dummyJpeg,
      },
    );

    // Tanpa auth -> 401
    const noAuthUpload = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/uploads/${uploadId1}`,
      headers: {
        'idempotency-key': uploadId1,
        'content-type': `multipart/form-data; boundary=${boundary}`,
      },
      payload: multipartPayload1,
    });
    assert.equal(noAuthUpload.statusCode, 401);

    // Dengan token admin (role != CITIZEN) -> 403
    const adminUpload = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/uploads/${uploadId1}`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': uploadId1,
        'content-type': `multipart/form-data; boundary=${boundary}`,
      },
      payload: multipartPayload1,
    });
    assert.equal(adminUpload.statusCode, 403);

    // Idempotency-Key tidak cocok dengan path uploadId -> 400
    const mismatchUpload = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/uploads/${uploadId1}`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
        'content-type': `multipart/form-data; boundary=${boundary}`,
      },
      payload: multipartPayload1,
    });
    assert.equal(mismatchUpload.statusCode, 400);

    // Upload 1 berhasil -> 201 Created
    const validUpload1 = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/uploads/${uploadId1}`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': uploadId1,
        'content-type': `multipart/form-data; boundary=${boundary}`,
      },
      payload: multipartPayload1,
    });
    assert.equal(validUpload1.statusCode, 201);
    const uploadData1 = validUpload1.json<{ data: Upload }>().data;
    assert.equal(uploadData1.id, uploadId1);
    assert.equal(uploadData1.purpose, 'REPORT');
    assert.equal(uploadData1.origin, 'CAMERA');
    assert.equal(uploadData1.state, 'READY');
    assert.equal(uploadData1.mediaType, 'image/jpeg');
    assert.equal(uploadData1.sizeBytes, dummyJpeg.length);

    // Replay upload 1 -> 200 OK idempotent replay
    const replayUpload1 = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/uploads/${uploadId1}`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': uploadId1,
        'content-type': `multipart/form-data; boundary=${boundary}`,
      },
      payload: multipartPayload1,
    });
    assert.equal(replayUpload1.statusCode, 200);

    // Upload 2 (PNG): 89 50 4E 47 0D 0A 1A 0A ...
    const dummyPng = Buffer.from([
      0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
      0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1f, 0x15, 0xc4, 0x89, 0x00, 0x00, 0x00,
      0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82,
    ]);
    const multipartPayload2 = buildMultipartBody(
      boundary,
      { purpose: 'REPORT', origin: 'GALLERY' },
      {
        name: 'file',
        filename: 'foto2.png',
        mime: 'image/png',
        data: dummyPng,
      },
    );

    const validUpload2 = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/uploads/${uploadId2}`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': uploadId2,
        'content-type': `multipart/form-data; boundary=${boundary}`,
      },
      payload: multipartPayload2,
    });
    assert.equal(validUpload2.statusCode, 201);
    assert.equal(
      validUpload2.json<{ data: Upload }>().data.mediaType,
      'image/png',
    );

    // 4. GET /api/v1/me/uploads/:uploadId
    const getUploadRes = await app.inject({
      method: 'GET',
      url: `/api/v1/me/uploads/${uploadId1}`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(getUploadRes.statusCode, 200);
    assert.equal(getUploadRes.json<{ data: Upload }>().data.id, uploadId1);

    // 5. PUT /api/v1/me/submissions/:submissionId
    const submissionId = randomUUID();
    const submissionBody = {
      uploadIds: [uploadId1, uploadId2],
      description: 'Air banjir mencapai ketinggian 60 cm di jalan utama.',
      point: {
        latitude: -0.9471,
        longitude: 100.3543,
        source: 'GPS',
      },
      occurredAt: new Date().toISOString(),
      deviceSignals: {
        mockLocation: 'NOT_DETECTED',
        developerMode: 'NOT_DETECTED',
        observedAt: new Date().toISOString(),
        buildId: 'BUILD-TEST-123',
      },
    };

    // Tanpa auth -> 401
    const noAuthSub = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/submissions/${submissionId}`,
      headers: {
        'idempotency-key': submissionId,
      },
      payload: submissionBody,
    });
    assert.equal(noAuthSub.statusCode, 401);

    // Idempotency-Key mismatch -> 400
    const mismatchSub = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/submissions/${submissionId}`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: submissionBody,
    });
    assert.equal(mismatchSub.statusCode, 400);

    // Sukses kirim laporan -> 201 Created
    const validSub = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/submissions/${submissionId}`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': submissionId,
      },
      payload: submissionBody,
    });
    assert.equal(validSub.statusCode, 201);
    const subState = validSub.json<{ data: SubmissionState }>().data;
    assert.equal(subState.id, submissionId);
    assert.equal(subState.state, 'ACCEPTED');
    assert.ok(subState.reportId);
    createdReportId = subState.reportId;

    // Replay submission yang sama -> 200 OK idempotent replay
    const replaySub = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/submissions/${submissionId}`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': submissionId,
      },
      payload: submissionBody,
    });
    assert.equal(replaySub.statusCode, 200);

    // Status upload harus sudah menjadi ATTACHED
    const attachedUploadRes = await app.inject({
      method: 'GET',
      url: `/api/v1/me/uploads/${uploadId1}`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(
      attachedUploadRes.json<{ data: Upload }>().data.state,
      'ATTACHED',
    );

    // 6. GET /api/v1/me/submissions/:submissionId
    const getSubRes = await app.inject({
      method: 'GET',
      url: `/api/v1/me/submissions/${submissionId}`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(getSubRes.statusCode, 200);
    assert.equal(
      getSubRes.json<{ data: SubmissionState }>().data.id,
      submissionId,
    );

    // 7. POST /api/v1/me/submissions/:submissionId/close
    const closeSubRes = await app.inject({
      method: 'POST',
      url: `/api/v1/me/submissions/${submissionId}/close`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
    });
    assert.equal(closeSubRes.statusCode, 200);
    assert.equal(
      closeSubRes.json<{ data: SubmissionState }>().data.state,
      'CLOSED',
    );

    // 8. GET /api/v1/me/reports
    const listReportsRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/reports',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(listReportsRes.statusCode, 200);
    const reportsPage = listReportsRes.json<{ data: HistoryItemPage }>().data;
    const listedReport = reportsPage.items.find(
      (i: { id: string }) => i.id === createdReportId,
    );
    assert.ok(listedReport);
    assert.ok(
      typeof (listedReport as { description?: unknown }).description ===
        'string',
    );

    // 9. GET /api/v1/me/reports/:reportId
    const getReportRes = await app.inject({
      method: 'GET',
      url: `/api/v1/me/reports/${createdReportId}`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(getReportRes.statusCode, 200);
    const reportDetail = getReportRes.json<{ data: ReportDetail }>().data;
    assert.equal(reportDetail.summary.id, createdReportId);
    assert.equal(reportDetail.media.length, 2);
    assert.equal(reportDetail.media[0]?.id, uploadId1);
    assert.equal(reportDetail.media[1]?.id, uploadId2);

    // 10. Tambah catatan tindak lanjut dan baca GET /api/v1/reports/:reportId/notes
    const noteId = randomUUID();
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute(
        `INSERT INTO notes (id, report_id, author_id, body, correction_of, correction_reason, created_at)
          VALUES (?, ?, ?, 'Tim BPBD telah meninjau lokasi kejadian.', NULL, NULL, UTC_TIMESTAMP(3))`,
        [noteId, createdReportId, adminId],
      );
    });

    const citizenNotesRes = await app.inject({
      method: 'GET',
      url: `/api/v1/reports/${createdReportId}/notes`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(citizenNotesRes.statusCode, 200);
    const notePage = citizenNotesRes.json<{ data: NotePage }>().data;
    assert.ok(notePage.items.some((n: { id: string }) => n.id === noteId));

    // Admin juga berhak membaca catatan laporan warga
    const adminNotesRes = await app.inject({
      method: 'GET',
      url: `/api/v1/reports/${createdReportId}/notes`,
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(adminNotesRes.statusCode, 200);

    // 11. GET /api/v1/media/:mediaId
    // Warga mengunduh media miliknya sendiri
    const citizenMediaRes = await app.inject({
      method: 'GET',
      url: `/api/v1/media/${uploadId1}`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(citizenMediaRes.statusCode, 200);
    assert.equal(citizenMediaRes.headers['content-type'], 'image/jpeg');
    assert.deepEqual(citizenMediaRes.rawPayload, dummyJpeg);

    // Admin mengunduh media laporan warga
    const adminMediaRes = await app.inject({
      method: 'GET',
      url: `/api/v1/media/${uploadId1}`,
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(adminMediaRes.statusCode, 200);
    assert.deepEqual(adminMediaRes.rawPayload, dummyJpeg);

    // Range request: bytes=0-3
    const rangeMediaRes = await app.inject({
      method: 'GET',
      url: `/api/v1/media/${uploadId1}`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        range: 'bytes=0-3',
      },
    });
    assert.equal(rangeMediaRes.statusCode, 206);
    assert.equal(
      rangeMediaRes.headers['content-range'],
      `bytes 0-3/${dummyJpeg.length}`,
    );
    assert.deepEqual(rangeMediaRes.rawPayload, dummyJpeg.subarray(0, 4));
  } finally {
    // Cleanup data test
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute('DELETE FROM jobs WHERE owner_id=?', [
        citizenId,
      ]);
      await connection.execute('DELETE FROM submissions WHERE owner_id = ?', [
        citizenId,
      ]);
      if (createdReportId) {
        await connection.execute('DELETE FROM notes WHERE report_id = ?', [
          createdReportId,
        ]);
        await connection.execute(
          'DELETE FROM assessments WHERE report_id = ?',
          [createdReportId],
        );
        await connection.execute(
          'DELETE FROM report_media WHERE report_id = ?',
          [createdReportId],
        );
        await connection.execute(
          'DELETE FROM quota_ledger WHERE report_id = ?',
          [createdReportId],
        );
        await connection.execute('DELETE FROM reports WHERE id = ?', [
          createdReportId,
        ]);
      }
      await connection.execute('DELETE FROM uploads WHERE id IN (?, ?)', [
        uploadId1,
        uploadId2,
      ]);
      await connection.execute('DELETE FROM ktp_states WHERE account_id = ?', [
        citizenId,
      ]);
      await connection.execute(
        'DELETE FROM sessions WHERE account_id IN (?, ?)',
        [citizenId, adminId],
      );
      await connection.execute('DELETE FROM commands WHERE actor_scope = ?', [
        actorScope(keys.journal, 'account', citizenId),
      ]);
      await connection.execute('DELETE FROM commands WHERE actor_scope = ?', [
        actorScope(keys.journal, 'account', adminId),
      ]);
      await connection.execute(
        'DELETE FROM recovery_verifiers WHERE account_id IN (?, ?)',
        [citizenId, adminId],
      );
      await connection.execute('DELETE FROM accounts WHERE id IN (?, ?)', [
        citizenId,
        adminId,
      ]);
    });
  }
}
