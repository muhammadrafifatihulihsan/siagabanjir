import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { hashPassword } from '../src/security/password.js';
import { readSecurityKeys } from '../src/security/keys.js';
import { actorScope } from '../src/security/fingerprint.js';
import { withBusinessTransaction } from '../src/db/pool.js';
import type {
  ReportingStatus,
  Settings,
  QuotaAccountPage,
} from '../src/reporting/quota.js';

export async function verifyReporting(app: FastifyInstance, pool: Pool) {
  const keys = readSecurityKeys(process.env);
  const citizenEmail = `${randomUUID()}@example.invalid`;
  const adminEmail = `${randomUUID()}@example.invalid`;
  const password = 'sandi pelaporan test 123';

  // 1. Buat akun warga via signup
  const signupRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/signup',
    headers: { 'idempotency-key': randomUUID() },
    payload: {
      displayName: 'Warga Pelapor',
      email: citizenEmail,
      password,
    },
  });
  assert.equal(signupRes.statusCode, 201);
  const citizenData = signupRes.json<{
    data: { account: { id: string; version: number } };
  }>().data;
  const citizenId = citizenData.account.id;

  // Login warga (ANDROID)
  const citizenLoginRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/login',
    headers: { 'idempotency-key': randomUUID() },
    payload: {
      email: citizenEmail,
      password,
      client: 'ANDROID',
    },
  });
  assert.equal(citizenLoginRes.statusCode, 200);
  const citizenToken = citizenLoginRes.json<{
    data: { accessToken: string };
  }>().data.accessToken;

  // 2. Buat akun admin di database langsung dan login via ADMIN_WEB
  const adminId = randomUUID();
  const { salt, hash } = await hashPassword(password);
  await withBusinessTransaction(pool, async (connection) => {
    await connection.execute(
      `INSERT INTO accounts (id, email_normalized, display_name, role, password_salt, password_hash, credential_epoch, version, created_at)
        VALUES (?, ?, 'Admin Pelapor', 'ADMIN', ?, ?, 1, 1, UTC_TIMESTAMP(3))`,
      [adminId, adminEmail.toLowerCase(), salt, hash],
    );
  });

  const adminLoginRes = await app.inject({
    method: 'POST',
    url: '/api/v1/auth/login',
    headers: { 'idempotency-key': randomUUID() },
    payload: {
      email: adminEmail,
      password,
      client: 'ADMIN_WEB',
    },
  });
  assert.equal(adminLoginRes.statusCode, 200);
  const adminToken = adminLoginRes.json<{
    data: { accessToken: string };
  }>().data.accessToken;

  try {
    // 3. GET /api/v1/me/reporting-status
    // Tanpa auth -> 401
    const noAuthStatus = await app.inject({
      method: 'GET',
      url: '/api/v1/me/reporting-status',
    });
    assert.equal(noAuthStatus.statusCode, 401);

    // Dengan token admin (role != CITIZEN) -> 403
    const adminForbiddenStatus = await app.inject({
      method: 'GET',
      url: '/api/v1/me/reporting-status',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(adminForbiddenStatus.statusCode, 403);

    // Dengan token warga -> 200
    const initialStatusRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/reporting-status',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(initialStatusRes.statusCode, 200);
    const initialStatus = initialStatusRes.json<{ data: ReportingStatus }>()
      .data;
    assert.equal(initialStatus.ktpSatisfied, true);
    assert.equal(initialStatus.ktpStateVersion, 1);
    assert.equal(initialStatus.quota.used, 0);
    assert.ok(initialStatus.quota.remaining >= 1);
    assert.equal(initialStatus.quota.nextReleaseAt, null);
    const initialSettingsVersion = initialStatus.quota.settings.version;

    // 4. Admin endpoints access control (warga harus ditolak 403)
    const citizenForbiddenSettings = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/reporting-settings',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(citizenForbiddenSettings.statusCode, 403);

    const citizenForbiddenPatch = await app.inject({
      method: 'PATCH',
      url: '/api/v1/admin/reporting-settings',
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
        'if-match': `"${initialSettingsVersion}"`,
      },
      payload: { quotaCount: 4 },
    });
    assert.equal(citizenForbiddenPatch.statusCode, 403);

    const citizenForbiddenReset = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/quota-resets',
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
        'if-match': `"${initialSettingsVersion}"`,
      },
      payload: { scope: 'ALL' },
    });
    assert.equal(citizenForbiddenReset.statusCode, 403);

    const citizenForbiddenQuotas = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/quotas',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(citizenForbiddenQuotas.statusCode, 403);

    // 5. Admin GET /api/v1/admin/reporting-settings
    const getSettingsRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/reporting-settings',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(getSettingsRes.statusCode, 200);
    const currentSettings = getSettingsRes.json<{ data: Settings }>().data;
    assert.equal(currentSettings.version, initialSettingsVersion);

    // 6. Admin PATCH /api/v1/admin/reporting-settings
    // Missing If-Match -> 428
    const patchMissingIfMatch = await app.inject({
      method: 'PATCH',
      url: '/api/v1/admin/reporting-settings',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: { quotaCount: 4 },
    });
    assert.equal(patchMissingIfMatch.statusCode, 428);

    // Wrong If-Match -> 409 VERSION_CONFLICT
    const patchWrongVersion = await app.inject({
      method: 'PATCH',
      url: '/api/v1/admin/reporting-settings',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"99999"',
      },
      payload: { quotaCount: 4 },
    });
    assert.equal(patchWrongVersion.statusCode, 409);

    // Invalid body (quotaCount out of range) -> 422 VALIDATION_FAILED
    const patchInvalid = await app.inject({
      method: 'PATCH',
      url: '/api/v1/admin/reporting-settings',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': `"${currentSettings.version}"`,
      },
      payload: { quotaCount: 99 },
    });
    assert.equal(patchInvalid.statusCode, 422);

    // Update berhasil
    const patchKey = randomUUID();
    const patchValid = await app.inject({
      method: 'PATCH',
      url: '/api/v1/admin/reporting-settings',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': patchKey,
        'if-match': `"${currentSettings.version}"`,
      },
      payload: {
        galleryEnabled: true,
        quotaCount: 5,
        quotaHours: 12,
      },
    });
    assert.equal(patchValid.statusCode, 200);
    const updatedSettings = patchValid.json<{ data: Settings }>().data;
    assert.equal(updatedSettings.galleryEnabled, true);
    assert.equal(updatedSettings.quotaCount, 5);
    assert.equal(updatedSettings.quotaHours, 12);
    assert.equal(updatedSettings.version, currentSettings.version + 1);

    // Replay update yang sama -> 200 idempotent
    const patchReplay = await app.inject({
      method: 'PATCH',
      url: '/api/v1/admin/reporting-settings',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': patchKey,
        'if-match': `"${currentSettings.version}"`,
      },
      payload: {
        galleryEnabled: true,
        quotaCount: 5,
        quotaHours: 12,
      },
    });
    assert.equal(patchReplay.statusCode, 200);

    // Replay dengan payload beda -> 409 IDEMPOTENCY_CONFLICT
    const patchConflict = await app.inject({
      method: 'PATCH',
      url: '/api/v1/admin/reporting-settings',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': patchKey,
        'if-match': `"${currentSettings.version}"`,
      },
      payload: {
        galleryEnabled: false,
        quotaCount: 2,
        quotaHours: 6,
      },
    });
    assert.equal(patchConflict.statusCode, 409);

    let activeVersion = updatedSettings.version;

    // 7. Masukkan entri simulasi laporan di quota_ledger
    await withBusinessTransaction(pool, async (connection) => {
      for (let i = 0; i < 5; i++) {
        await connection.execute(
          `INSERT INTO quota_ledger (account_id, report_id, accepted_at)
            VALUES (?, ?, UTC_TIMESTAMP(3))`,
          [citizenId, randomUUID()],
        );
      }
    });

    // Cek status warga setelah 5 laporan
    const usedStatusRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/reporting-status',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(usedStatusRes.statusCode, 200);
    const usedStatus = usedStatusRes.json<{ data: ReportingStatus }>().data;
    assert.equal(usedStatus.quota.used, 5);
    assert.equal(usedStatus.quota.remaining, 0);
    assert.ok(typeof usedStatus.quota.nextReleaseAt === 'string');

    // 8. Admin GET /api/v1/admin/quotas
    const quotasRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/quotas',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(quotasRes.statusCode, 200);
    const quotaPage = quotasRes.json<{ data: QuotaAccountPage }>().data;
    assert.ok(Array.isArray(quotaPage.items));
    assert.equal(quotaPage.revision, activeVersion);
    const citizenItem = quotaPage.items.find((item) => item.id === citizenId);
    assert.ok(citizenItem);
    assert.equal(citizenItem.quota.used, 5);
    assert.equal(citizenItem.quota.remaining, 0);

    // Filter search q
    const searchRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/quotas?q=Pelapor',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(searchRes.statusCode, 200);
    const searchPage = searchRes.json<{ data: QuotaAccountPage }>().data;
    assert.ok(searchPage.items.some((i) => i.id === citizenId));

    // 9. Admin POST /api/v1/admin/quota-resets (Scope: ACCOUNT)
    // Account tidak valid
    const resetInvalidAccount = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/quota-resets',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': `"${activeVersion}"`,
      },
      payload: {
        scope: 'ACCOUNT',
        accountId: randomUUID(),
      },
    });
    assert.equal(resetInvalidAccount.statusCode, 404);

    // Reset akun warga yang valid
    const resetKey = randomUUID();
    const resetAccountRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/quota-resets',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': resetKey,
        'if-match': `"${activeVersion}"`,
      },
      payload: {
        scope: 'ACCOUNT',
        accountId: citizenId,
      },
    });
    assert.equal(resetAccountRes.statusCode, 200);
    const afterAccountReset = resetAccountRes.json<{ data: Settings }>().data;
    assert.equal(afterAccountReset.version, activeVersion + 1);
    activeVersion = afterAccountReset.version;

    // Idempotent replay reset
    const resetReplay = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/quota-resets',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': resetKey,
        'if-match': `"${activeVersion - 1}"`,
      },
      payload: {
        scope: 'ACCOUNT',
        accountId: citizenId,
      },
    });
    assert.equal(resetReplay.statusCode, 200);

    // Cek status warga setelah reset akun: kuota harus kembali 0
    const resetStatusRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/reporting-status',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(resetStatusRes.statusCode, 200);
    const resetStatus = resetStatusRes.json<{ data: ReportingStatus }>().data;
    assert.equal(resetStatus.quota.used, 0);
    assert.equal(resetStatus.quota.remaining, 5);
    assert.equal(resetStatus.quota.nextReleaseAt, null);

    // 10. Tambah laporan lagi lalu reset ALL
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute(
        `INSERT INTO quota_ledger (account_id, report_id, accepted_at)
          VALUES (?, ?, UTC_TIMESTAMP(3))`,
        [citizenId, randomUUID()],
      );
    });

    const resetAllRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/quota-resets',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': `"${activeVersion}"`,
      },
      payload: {
        scope: 'ALL',
      },
    });
    assert.equal(resetAllRes.statusCode, 200);
    const afterAllReset = resetAllRes.json<{ data: Settings }>().data;
    assert.equal(afterAllReset.version, activeVersion + 1);
    activeVersion = afterAllReset.version;

    // Cek warga ter-reset kembali oleh reset ALL
    const resetAllStatusRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/reporting-status',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(resetAllStatusRes.statusCode, 200);
    assert.equal(
      resetAllStatusRes.json<{ data: ReportingStatus }>().data.quota.used,
      0,
    );

    // 11. Simulasi status KTP tersimpan (demo: ktpSatisfied selalu true,
    //     versi state tetap mengikuti baris ktp_states)
    const docId = randomUUID();
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute(
        `INSERT INTO ktp_states (account_id, active_document_id, version, updated_at)
          VALUES (?, ?, 2, UTC_TIMESTAMP(3))`,
        [citizenId, docId],
      );
    });

    const ktpSatisfiedRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/reporting-status',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(ktpSatisfiedRes.statusCode, 200);
    const ktpStatus = ktpSatisfiedRes.json<{ data: ReportingStatus }>().data;
    assert.equal(ktpStatus.ktpSatisfied, true);
    assert.equal(ktpStatus.ktpStateVersion, 2);
  } finally {
    // Cleanup data test
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute(
        'DELETE FROM quota_ledger WHERE account_id = ?',
        [citizenId],
      );
      await connection.execute(
        'DELETE FROM quota_accounts WHERE account_id = ?',
        [citizenId],
      );
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
      await connection.execute('DELETE FROM commands WHERE actor_scope = ?', [
        actorScope(keys.journal, 'public', 'admin_reporting_settings'),
      ]);
      await connection.execute('DELETE FROM commands WHERE actor_scope = ?', [
        actorScope(keys.journal, 'public', 'admin_quota_resets'),
      ]);
      await connection.execute(
        'DELETE FROM recovery_verifiers WHERE account_id IN (?, ?)',
        [citizenId, adminId],
      );
      await connection.execute('DELETE FROM accounts WHERE id IN (?, ?)', [
        citizenId,
        adminId,
      ]);
      // Kembalikan quota_settings ke default id=1
      await connection.execute(
        `UPDATE quota_settings
          SET gallery_enabled = 0, quota_count = 3, quota_hours = 6, global_reset_seq = 0, version = 1, updated_at = UTC_TIMESTAMP(3)
          WHERE id = 1`,
      );
    });
  }
}
