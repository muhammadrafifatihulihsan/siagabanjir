import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { readSecurityKeys } from '../src/security/keys.js';
import { actorScope } from '../src/security/fingerprint.js';
import { withBusinessTransaction } from '../src/db/pool.js';
import type {
  Document,
  DocumentPage,
  KtpState,
  Job,
  Family,
  CleanupPage,
  Cleanup,
} from '../src/vault/documents.js';

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

export async function verifyVault(app: FastifyInstance, pool: Pool) {
  const keys = readSecurityKeys(process.env);
  const citizenEmail = `${randomUUID()}@example.invalid`;
  const password = 'sandi vault dokumen 123';

  // 1. Signup & login warga
  const signupRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/signup',
    headers: { 'idempotency-key': randomUUID() },
    payload: {
      displayName: 'Warga Pemilik Dokumen',
      email: citizenEmail,
      password,
    },
  });
  assert.equal(signupRes.statusCode, 201);
  const citizenId = signupRes.json<{
    data: { account: { id: string } };
  }>().data.account.id;

  const loginRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/login',
    headers: { 'idempotency-key': randomUUID() },
    payload: { email: citizenEmail, password, client: 'ANDROID' },
  });
  assert.equal(loginRes.statusCode, 200);
  const citizenToken = loginRes.json<{
    data: { accessToken: string };
  }>().data.accessToken;

  // 2. Upload berkas PDF untuk dokumen
  const uploadId = randomUUID();
  const boundary = '----VaultBoundary12345';
  const dummyPdf = Buffer.from(
    '%PDF-1.4\n1 0 obj<</Type/Catalog>>endobj\ntrailer<</Root 1 0 R>>\n%%EOF',
  );

  const multipart = buildMultipartBody(
    boundary,
    { purpose: 'DOCUMENT', origin: 'FILE' },
    {
      name: 'file',
      filename: 'ktp.pdf',
      mime: 'application/pdf',
      data: dummyPdf,
    },
  );

  const uploadRes = await app.inject({
    method: 'PUT',
    url: `/api/v1/me/uploads/${uploadId}`,
    headers: {
      authorization: `Bearer ${citizenToken}`,
      'idempotency-key': uploadId,
      'content-type': `multipart/form-data; boundary=${boundary}`,
    },
    payload: multipart,
  });
  assert.equal(uploadRes.statusCode, 201);

  let createdDocId: string | null = null;

  try {
    // 3. POST /api/v1/me/documents
    const createDocRes = await app.inject({
      method: 'POST',
      url: '/api/v1/me/documents',
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        uploadId,
        displayName: 'KTP Asli Padang',
      },
    });
    assert.equal(createDocRes.statusCode, 201);
    const docData = createDocRes.json<{ data: Document }>().data;
    assert.ok(docData.id);
    assert.equal(docData.displayName, 'KTP Asli Padang');
    assert.equal(docData.version, 1);
    assert.equal(docData.activeKtp, false);
    createdDocId = docData.id;

    // 4. GET /api/v1/me/documents
    const listDocsRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/documents',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(listDocsRes.statusCode, 200);
    const docsPage = listDocsRes.json<{ data: DocumentPage }>().data;
    assert.ok(
      docsPage.items.some((d: { id: string }) => d.id === createdDocId),
    );

    // 5. GET /api/v1/me/documents/:documentId
    const getDocRes = await app.inject({
      method: 'GET',
      url: `/api/v1/me/documents/${createdDocId}`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(getDocRes.statusCode, 200);
    assert.equal(getDocRes.json<{ data: Document }>().data.id, createdDocId);

    // 6. GET /api/v1/me/ktp (Status awal)
    const initialKtpRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/ktp',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(initialKtpRes.statusCode, 200);
    const initialKtp = initialKtpRes.json<{ data: KtpState }>().data;
    assert.equal(initialKtp.satisfied, false);
    assert.equal(initialKtp.activeDocumentId, null);
    const ktpVersion = initialKtp.version;

    // 7. POST /api/v1/me/ktp-checks
    const ktpCheckRes = await app.inject({
      method: 'POST',
      url: '/api/v1/me/ktp-checks',
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        documentId: createdDocId,
        documentVersion: 1,
        consentVersion: 'ktp-v1',
      },
    });
    assert.equal(ktpCheckRes.statusCode, 200);
    const ktpJob = ktpCheckRes.json<{ data: Job }>().data;
    assert.equal(ktpJob.kind, 'KTP_CHECK');
    assert.equal(ktpJob.state, 'SUCCEEDED');
    const ktpJobId = ktpJob.id;

    // 8. POST /api/v1/me/ktp-confirmations
    const confirmKtpRes = await app.inject({
      method: 'POST',
      url: '/api/v1/me/ktp-confirmations',
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
        'if-match': `"${ktpVersion}"`,
      },
      payload: {
        documentId: createdDocId,
        documentVersion: 1,
        jobId: ktpJobId,
        nameConfirmed: true,
      },
    });
    assert.equal(confirmKtpRes.statusCode, 200);
    const confirmedKtp = confirmKtpRes.json<{ data: KtpState }>().data;
    assert.equal(confirmedKtp.satisfied, true);
    assert.equal(confirmedKtp.activeDocumentId, createdDocId);
    assert.equal(confirmedKtp.version, ktpVersion + 1);

    // 9. POST /api/v1/me/ktp-checks/:jobId/retry
    const retryKtpRes = await app.inject({
      method: 'POST',
      url: `/api/v1/me/ktp-checks/${ktpJobId}/retry`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(retryKtpRes.statusCode, 200);
    assert.equal(retryKtpRes.json<{ data: Job }>().data.id, ktpJobId);

    // 10. GET /api/v1/me/family
    const initialFamilyRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/family',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(initialFamilyRes.statusCode, 200);
    const initialFamily = initialFamilyRes.json<{ data: Family }>().data;
    assert.equal(initialFamily.version, 1);
    assert.equal(initialFamily.members.length, 0);

    // 11. PATCH /api/v1/me/family (Tambah anggota manual)
    const clientMemberId = randomUUID();
    const updateFamilyRes = await app.inject({
      method: 'PATCH',
      url: '/api/v1/me/family',
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"1"',
      },
      payload: {
        operations: [
          {
            op: 'ADD',
            clientMemberId,
            displayName: 'Istri Tercinta',
            ageGroup: 'ADULT',
            specialNeeds: [],
          },
        ],
      },
    });
    assert.equal(updateFamilyRes.statusCode, 200);
    const familyV2 = updateFamilyRes.json<{ data: Family }>().data;
    assert.equal(familyV2.version, 2);
    assert.equal(familyV2.members.length, 1);
    assert.equal(familyV2.members[0]?.displayName, 'Istri Tercinta');

    // 12. POST /api/v1/me/family-extractions
    const extractRes = await app.inject({
      method: 'POST',
      url: '/api/v1/me/family-extractions',
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        documents: [{ id: createdDocId, version: 1 }],
        consentVersion: 'family-v1',
      },
    });
    assert.equal(extractRes.statusCode, 200);
    const extractionJob = extractRes.json<{ data: Job }>().data;
    assert.equal(extractionJob.kind, 'FAMILY_EXTRACTION');
    assert.equal(extractionJob.state, 'SUCCEEDED');
    const familyJobId = extractionJob.id;

    // 13. POST /api/v1/me/family-extractions/:jobId/retry
    const retryExtractionRes = await app.inject({
      method: 'POST',
      url: `/api/v1/me/family-extractions/${familyJobId}/retry`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(retryExtractionRes.statusCode, 200);

    // 14. POST /api/v1/me/family-extractions/:jobId/apply
    const childMemberId = randomUUID();
    const applyRes = await app.inject({
      method: 'POST',
      url: `/api/v1/me/family-extractions/${familyJobId}/apply`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        familyVersion: 2,
        selections: [
          {
            suggestionId: randomUUID(),
            operation: {
              op: 'ADD',
              clientMemberId: childMemberId,
              displayName: 'Anak Pertama',
              ageGroup: 'CHILD',
              specialNeeds: ['MOBILITY'],
            },
          },
        ],
      },
    });
    assert.equal(applyRes.statusCode, 200);
    const familyV3 = applyRes.json<{ data: Family }>().data;
    assert.equal(familyV3.version, 3);
    assert.equal(familyV3.members.length, 2);

    // 15. POST /api/v1/me/documents/:documentId/deletions
    const deleteDocRes = await app.inject({
      method: 'POST',
      url: `/api/v1/me/documents/${createdDocId}/deletions`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
    });
    assert.equal(deleteDocRes.statusCode, 200);

    // Dokumen sudah terhapus -> GET menghasilkan 410 GONE
    const getDeletedDoc = await app.inject({
      method: 'GET',
      url: `/api/v1/me/documents/${createdDocId}`,
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(getDeletedDoc.statusCode, 410);

    // KTP status otomatis melepaskan activeDocumentId
    const afterDeleteKtp = await app.inject({
      method: 'GET',
      url: '/api/v1/me/ktp',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(
      afterDeleteKtp.json<{ data: KtpState }>().data.satisfied,
      false,
    );

    // 16. GET /api/v1/me/cleanup
    const cleanupListRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/cleanup',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(cleanupListRes.statusCode, 200);
    const cleanupPage = cleanupListRes.json<{ data: CleanupPage }>().data;
    assert.ok(cleanupPage.items.length >= 1);
    const cleanupJobId = cleanupPage.items[0]?.id ?? null;

    // 17. POST /api/v1/me/cleanup/:cleanupId/retry
    if (cleanupJobId) {
      const retryCleanupRes = await app.inject({
        method: 'POST',
        url: `/api/v1/me/cleanup/${cleanupJobId}/retry`,
        headers: { authorization: `Bearer ${citizenToken}` },
      });
      assert.equal(retryCleanupRes.statusCode, 200);
      assert.equal(
        retryCleanupRes.json<{ data: Cleanup }>().data.state,
        'RUNNING',
      );
    }
  } finally {
    // Cleanup DB test
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute('DELETE FROM cleanup_jobs WHERE owner_id = ?', [
        citizenId,
      ]);
      await connection.execute(
        'DELETE FROM extraction_suggestions WHERE job_id IN (SELECT id FROM jobs WHERE owner_id = ?)',
        [citizenId],
      );
      await connection.execute('DELETE FROM jobs WHERE owner_id = ?', [
        citizenId,
      ]);
      await connection.execute('DELETE FROM consents WHERE owner_id = ?', [
        citizenId,
      ]);
      await connection.execute(
        'DELETE FROM family_members WHERE account_id = ?',
        [citizenId],
      );
      await connection.execute(
        'DELETE FROM family_profiles WHERE account_id = ?',
        [citizenId],
      );
      await connection.execute('DELETE FROM ktp_states WHERE account_id = ?', [
        citizenId,
      ]);
      if (createdDocId) {
        await connection.execute('DELETE FROM documents WHERE id = ?', [
          createdDocId,
        ]);
      }
      await connection.execute('DELETE FROM uploads WHERE id = ?', [uploadId]);
      await connection.execute('DELETE FROM sessions WHERE account_id = ?', [
        citizenId,
      ]);
      await connection.execute('DELETE FROM commands WHERE actor_scope = ?', [
        actorScope(keys.journal, 'account', citizenId),
      ]);
      await connection.execute(
        'DELETE FROM recovery_verifiers WHERE account_id = ?',
        [citizenId],
      );
      await connection.execute('DELETE FROM accounts WHERE id = ?', [
        citizenId,
      ]);
    });
  }
}
