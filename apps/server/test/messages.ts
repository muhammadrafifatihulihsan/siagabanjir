import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { withBusinessTransaction } from '../src/db/pool.js';
import { hashPassword } from '../src/security/password.js';
import { readSecurityKeys } from '../src/security/keys.js';
import { actorScope } from '../src/security/fingerprint.js';
import type {
  Message,
  MessagePage,
  InboxItemPage,
  ReadResult,
} from '../src/messages/inbox.js';

export async function verifyMessages(
  app: FastifyInstance,
  pool: Pool,
): Promise<void> {
  const keys = readSecurityKeys(process.env);
  const adminEmail = `${randomUUID()}@example.invalid`;
  const citizenEmail = `${randomUUID()}@example.invalid`;
  const password = 'sandi pesan siagabanjir 123';

  const adminId = randomUUID();
  const citizenId = randomUUID();

  const { salt: adminSalt, hash: adminHash } = await hashPassword(password);
  const { salt: citSalt, hash: citHash } = await hashPassword(password);

  // 1. Buat akun Admin & Citizen
  await withBusinessTransaction(pool, async (connection) => {
    await connection.execute(
      `INSERT INTO accounts (id, email_normalized, display_name, role, password_salt, password_hash, credential_epoch, version, created_at)
        VALUES (?, ?, 'Admin Pesan Test', 'ADMIN', ?, ?, 1, 1, UTC_TIMESTAMP(3))`,
      [adminId, adminEmail.toLowerCase(), adminSalt, adminHash],
    );
    await connection.execute(
      `INSERT INTO accounts (id, email_normalized, display_name, role, password_salt, password_hash, credential_epoch, version, created_at)
        VALUES (?, ?, 'Warga Pesan Test', 'CITIZEN', ?, ?, 1, 1, UTC_TIMESTAMP(3))`,
      [citizenId, citizenEmail.toLowerCase(), citSalt, citHash],
    );
  });

  // Login admin & citizen
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

  try {
    // 2. POST /api/v1/admin/messages (Citizen dilarang -> 403)
    const citPublishRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/messages',
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        title: 'Warga coba siaran',
        body: 'Isi siaran warga',
        endsAt: null,
      },
    });
    assert.equal(citPublishRes.statusCode, 403);

    // 3. Admin terbitkan pesan 1 (Aktif, tanpa batas waktu)
    const key1 = randomUUID();
    const pubRes1 = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/messages',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': key1,
      },
      payload: {
        title: 'Peringatan Banjir Siaga 2',
        body: 'Warga bantaran kali harap mengamankan barang berharga.',
        severity: 'CRITICAL',
        endsAt: null,
      },
    });
    assert.equal(pubRes1.statusCode, 201);
    assert.equal(pubRes1.headers.etag, '"1"');
    const msg1 = pubRes1.json<{ data: Message }>().data;
    assert.equal(msg1.title, 'Peringatan Banjir Siaga 2');
    assert.equal(msg1.severity, 'CRITICAL');
    assert.equal(msg1.contentVersion, 1);
    assert.equal(msg1.version, 1);
    assert.equal(msg1.state, 'ACTIVE');

    // Replay idempotency
    const replayRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/messages',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': key1,
      },
      payload: {
        title: 'Peringatan Banjir Siaga 2',
        body: 'Warga bantaran kali harap mengamankan barang berharga.',
        severity: 'CRITICAL',
        endsAt: null,
      },
    });
    assert.equal(replayRes.statusCode, 201);
    assert.equal(replayRes.json<{ data: Message }>().data.id, msg1.id);

    // Idempotency conflict
    const conflictRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/messages',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': key1,
      },
      payload: {
        title: 'Judul Lain dengan Kunci Sama',
        body: 'Isi beda',
        endsAt: null,
      },
    });
    assert.equal(conflictRes.statusCode, 409);

    // Severity tidak dikenal ditolak 422
    const invalidSeverityRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/messages',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        title: 'Severity tidak valid',
        body: 'Isi pesan',
        severity: 'DANGER',
        endsAt: null,
      },
    });
    assert.equal(invalidSeverityRes.statusCode, 422);

    // Admin terbitkan pesan 2 (Aktif dengan batas waktu masa depan)
    const futureDate = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();
    const pubRes2 = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/messages',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        title: 'Posko Bantuan Duren Sawit',
        body: 'Posko logistik dan obat dibuka di Balai RW 03.',
        endsAt: futureDate,
      },
    });
    assert.equal(pubRes2.statusCode, 201);
    const msg2 = pubRes2.json<{ data: Message }>().data;

    // Admin terbitkan pesan 3 (Sudah kedaluwarsa)
    const pastDate = new Date(Date.now() - 60 * 1000).toISOString();
    const pubRes3 = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/messages',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        title: 'Pesan Masa Lalu',
        body: 'Sudah selesai',
        endsAt: pastDate,
      },
    });
    assert.equal(pubRes3.statusCode, 201);
    const msg3 = pubRes3.json<{ data: Message }>().data;
    assert.equal(msg3.title, 'Pesan Masa Lalu');

    // 4. GET /api/v1/admin/messages (Admin melihat semua pesan)
    const adminListRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/messages',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(adminListRes.statusCode, 200);
    const adminPage = adminListRes.json<{ data: MessagePage }>().data;
    assert.ok(adminPage.items.length >= 3);

    // Filter q
    const adminFilterRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/messages?q=Duren+Sawit',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(adminFilterRes.statusCode, 200);
    const filterPage = adminFilterRes.json<{ data: MessagePage }>().data;
    assert.equal(filterPage.items.length, 1);
    assert.equal(filterPage.items[0]!.id, msg2.id);

    // 5. GET /api/v1/admin/messages/:messageId
    const adminGetRes = await app.inject({
      method: 'GET',
      url: `/api/v1/admin/messages/${msg1.id}`,
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(adminGetRes.statusCode, 200);
    assert.equal(adminGetRes.headers.etag, '"1"');
    assert.equal(adminGetRes.json<{ data: Message }>().data.id, msg1.id);

    // 6. GET /api/v1/me/inbox (Warga membaca inbox)
    // Admin coba akses inbox warga -> 403
    const adminInboxRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/inbox',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(adminInboxRes.statusCode, 403);

    // Warga membaca inbox: hanya pesan 1 dan pesan 2 (pesan 3 masa lalu tidak tampil)
    const citInboxRes = await app.inject({
      method: 'GET',
      url: '/api/v1/me/inbox',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(citInboxRes.statusCode, 200);
    const inboxPage = citInboxRes.json<{ data: InboxItemPage }>().data;
    assert.equal(inboxPage.items.length, 2);
    // Kedua pesan belum dibaca
    const item1 = inboxPage.items.find((i) => i.message.id === msg1.id);
    const item2 = inboxPage.items.find((i) => i.message.id === msg2.id);
    assert.ok(item1);
    assert.ok(item2);
    assert.equal(item1.read, false);
    assert.equal(item2.read, false);

    // 7. PUT /api/v1/me/inbox/:messageId/read (Warga menandai dibaca)
    const readKey = randomUUID();
    const readRes = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/inbox/${msg1.id}/read`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': readKey,
      },
      payload: { contentVersion: 1 },
    });
    assert.equal(readRes.statusCode, 200);
    const readData = readRes.json<{ data: ReadResult }>().data;
    assert.equal(readData.messageId, msg1.id);
    assert.equal(readData.recordedVersion, 1);
    assert.equal(readData.readCurrent, true);

    // Cek kembali inbox warga: pesan 1 terbaca, pesan 2 belum terbaca
    const citInboxRes2 = await app.inject({
      method: 'GET',
      url: '/api/v1/me/inbox',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(citInboxRes2.statusCode, 200);
    const inboxPage2 = citInboxRes2.json<{ data: InboxItemPage }>().data;
    const rechecked1 = inboxPage2.items.find((i) => i.message.id === msg1.id);
    assert.equal(rechecked1?.read, true);

    // 8. PATCH /api/v1/admin/messages/:messageId (Edit pesan)
    // Precondition Required (tanpa If-Match -> 428)
    const noIfMatchRes = await app.inject({
      method: 'PATCH',
      url: `/api/v1/admin/messages/${msg1.id}`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: { endsAt: futureDate },
    });
    assert.equal(noIfMatchRes.statusCode, 428);

    // Version conflict (If-Match salah -> 409)
    const badIfMatchRes = await app.inject({
      method: 'PATCH',
      url: `/api/v1/admin/messages/${msg1.id}`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'if-match': '"999"',
        'idempotency-key': randomUUID(),
      },
      payload: { endsAt: futureDate },
    });
    assert.equal(badIfMatchRes.statusCode, 409);

    // Update HANYA endsAt: version bertambah, content_version TETAP 1
    const editEndsAtRes = await app.inject({
      method: 'PATCH',
      url: `/api/v1/admin/messages/${msg1.id}`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'if-match': '"1"',
        'idempotency-key': randomUUID(),
      },
      payload: { endsAt: futureDate },
    });
    assert.equal(editEndsAtRes.statusCode, 200);
    assert.equal(editEndsAtRes.headers.etag, '"2"');
    const msg1v2 = editEndsAtRes.json<{ data: Message }>().data;
    assert.equal(msg1v2.version, 2);
    assert.equal(msg1v2.contentVersion, 1);

    // Verifikasi inbox warga: status pesan 1 TETAP terbaca (read: true)
    const citInboxRes3 = await app.inject({
      method: 'GET',
      url: '/api/v1/me/inbox',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    const item1v2 = citInboxRes3
      .json<{ data: InboxItemPage }>()
      .data.items.find((i) => i.message.id === msg1.id);
    assert.equal(item1v2?.read, true);

    // Update KONTEN (body): content_version naik ke 2, version naik ke 3
    const editBodyRes = await app.inject({
      method: 'PATCH',
      url: `/api/v1/admin/messages/${msg1.id}`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'if-match': '"2"',
        'idempotency-key': randomUUID(),
      },
      payload: {
        body: 'Warga bantaran kali diimbau segera evakuasi ke posko utama.',
      },
    });
    assert.equal(editBodyRes.statusCode, 200);
    assert.equal(editBodyRes.headers.etag, '"3"');
    const msg1v3 = editBodyRes.json<{ data: Message }>().data;
    assert.equal(msg1v3.version, 3);
    assert.equal(msg1v3.contentVersion, 2);

    // Verifikasi inbox warga: status pesan 1 KEMBALI UNREAD (read: false)!
    const citInboxRes4 = await app.inject({
      method: 'GET',
      url: '/api/v1/me/inbox',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    const item1v3 = citInboxRes4
      .json<{ data: InboxItemPage }>()
      .data.items.find((i) => i.message.id === msg1.id);
    assert.equal(item1v3?.read, false);

    // Warga menandai dibaca versi konten baru (contentVersion: 2)
    const readRes2 = await app.inject({
      method: 'PUT',
      url: `/api/v1/me/inbox/${msg1.id}/read`,
      headers: {
        authorization: `Bearer ${citizenToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: { contentVersion: 2 },
    });
    assert.equal(readRes2.statusCode, 200);
    assert.equal(readRes2.json<{ data: ReadResult }>().data.readCurrent, true);

    // 9. POST /api/v1/admin/messages/:messageId/expire (Masa berlaku berakhir)
    const expireRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/messages/${msg2.id}/expire`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'if-match': '"1"',
        'idempotency-key': randomUUID(),
      },
    });
    assert.equal(expireRes.statusCode, 200);
    assert.equal(expireRes.headers.etag, '"2"');
    const msg2Exp = expireRes.json<{ data: Message }>().data;
    assert.equal(msg2Exp.state, 'EXPIRED');

    // Pesan 2 kini tidak muncul di inbox warga
    const citInboxRes5 = await app.inject({
      method: 'GET',
      url: '/api/v1/me/inbox',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    const items5 = citInboxRes5.json<{ data: InboxItemPage }>().data.items;
    assert.equal(
      items5.some((i) => i.message.id === msg2.id),
      false,
    );

    // 10. POST /api/v1/admin/messages/:messageId/revoke (Cabut pesan)
    const revokeRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/messages/${msg1.id}/revoke`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'if-match': '"3"',
        'idempotency-key': randomUUID(),
      },
    });
    assert.equal(revokeRes.statusCode, 200);
    assert.equal(revokeRes.headers.etag, '"4"');
    const msg1Rev = revokeRes.json<{ data: Message }>().data;
    assert.equal(msg1Rev.state, 'REVOKED');

    // Pesan 1 kini juga hilang dari inbox warga
    const citInboxRes6 = await app.inject({
      method: 'GET',
      url: '/api/v1/me/inbox',
      headers: { authorization: `Bearer ${citizenToken}` },
    });
    assert.equal(
      citInboxRes6.json<{ data: InboxItemPage }>().data.items.length,
      0,
    );
  } finally {
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute(
        'DELETE FROM message_reads WHERE account_id IN (?, ?)',
        [adminId, citizenId],
      );
      await connection.execute('DELETE FROM messages WHERE 1=1');
      await connection.execute(
        'DELETE FROM commands WHERE actor_scope IN (?, ?)',
        [
          actorScope(keys.journal, 'account', adminId),
          actorScope(keys.journal, 'account', citizenId),
        ],
      );
      await connection.execute(
        'DELETE FROM sessions WHERE account_id IN (?, ?)',
        [adminId, citizenId],
      );
      await connection.execute('DELETE FROM accounts WHERE id IN (?, ?)', [
        adminId,
        citizenId,
      ]);
    });
  }
}
