import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import type { FastifyInstance } from 'fastify';
import type { Pool } from 'mysql2/promise';
import { withBusinessTransaction } from '../src/db/pool.js';
import { actorScope } from '../src/security/fingerprint.js';
import { readSecurityKeys } from '../src/security/keys.js';
import { hashPassword } from '../src/security/password.js';
import type {
  MonitorItemPage,
  ContentManifest,
  ContentItemPage,
  ContentAdminPage,
  ContentAdmin,
} from '../src/content/cms.js';

export async function verifyCms(
  app: FastifyInstance,
  pool: Pool,
): Promise<void> {
  const keys = readSecurityKeys(process.env);
  const adminEmail = `${randomUUID()}@example.invalid`;
  const password = 'sandi admin cms 123';

  // 1. Buat akun Admin & login ADMIN_WEB
  const adminId = randomUUID();
  const { salt, hash } = await hashPassword(password);
  await withBusinessTransaction(pool, async (connection) => {
    await connection.execute(
      `INSERT INTO accounts (id, email_normalized, display_name, role, password_salt, password_hash, credential_epoch, version, created_at)
        VALUES (?, ?, 'Admin CMS Test', 'ADMIN', ?, ?, 1, 1, UTC_TIMESTAMP(3))`,
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

  const groupId = randomUUID();

  // Setup grup uji untuk monitor publik
  await withBusinessTransaction(pool, async (connection) => {
    await connection.execute(
      `INSERT INTO \`groups\` (id, code, state, location_label, level, created_at, updated_at, version)
        VALUES (?, 'GRP-MONITOR-TEST', 'ACTIVE', 'Kelurahan Lubuk Minturun', 'HIGH', UTC_TIMESTAMP(3), UTC_TIMESTAMP(3), 1)`,
      [groupId],
    );
  });

  try {
    // 2. GET /api/v1/public/monitor
    const monitorRes = await app.inject({
      method: 'GET',
      url: '/api/v1/public/monitor',
    });
    assert.equal(monitorRes.statusCode, 200);
    const monitorPage = monitorRes.json<{ data: MonitorItemPage }>().data;
    assert.ok(monitorPage.items.length >= 1);
    const foundMonitor = monitorPage.items.find(
      (m) => m.locationName === 'Kelurahan Lubuk Minturun',
    );
    assert.ok(foundMonitor);
    assert.equal(foundMonitor.level, 'HIGH');
    assert.equal(foundMonitor.reviewState, 'REVIEWED');

    // 3. GET /api/v1/public/content/manifest (Awal)
    const initialManifestRes = await app.inject({
      method: 'GET',
      url: '/api/v1/public/content/manifest',
    });
    assert.equal(initialManifestRes.statusCode, 200);
    const initialManifest = initialManifestRes.json<{ data: ContentManifest }>()
      .data;
    assert.ok(initialManifest.revision >= 1);
    assert.equal(initialManifest.parts.length, 3);

    // 4. POST /api/v1/admin/content/contacts (Buat draf kontak)
    const createContactRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/content/contacts',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        name: 'BPBD Kota Padang',
        description: 'Pusat Pengendalian Operasi Penanggulangan Bencana',
        phone: '+6275177877',
        source: {
          label: 'Website Resmi BPBD Padang',
          url: 'https://bpbd.padang.go.id',
          checkedAt: new Date().toISOString(),
          state: 'VERIFIED',
        },
      },
    });
    assert.equal(createContactRes.statusCode, 201);
    const contactAdmin = createContactRes.json<{ data: ContentAdmin }>().data;
    assert.ok(contactAdmin.id);
    assert.equal(contactAdmin.kind, 'CONTACTS');
    assert.equal(contactAdmin.state, 'DRAFT');
    assert.equal(contactAdmin.version, 1);
    const contactContentId = contactAdmin.id;

    // 5. GET /api/v1/admin/content/contacts
    const listContactsRes = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/content/contacts',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    assert.equal(listContactsRes.statusCode, 200);
    const adminContactsPage = listContactsRes.json<{ data: ContentAdminPage }>()
      .data;
    assert.ok(
      adminContactsPage.items.some((item) => item.id === contactContentId),
    );

    // 6. PUT /api/v1/admin/content/contacts/:contentId (Update draf kontak)
    const updateContactRes = await app.inject({
      method: 'PUT',
      url: `/api/v1/admin/content/contacts/${contactContentId}`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"1"',
      },
      payload: {
        name: 'BPBD Kota Padang (Pusdalops)',
        description: 'Pusat Pengendalian Operasi 24 Jam',
        phone: '+6275177877',
        source: {
          label: 'Website Resmi BPBD Padang',
          url: 'https://bpbd.padang.go.id',
          checkedAt: new Date().toISOString(),
          state: 'VERIFIED',
        },
      },
    });
    assert.equal(updateContactRes.statusCode, 200);
    const updatedContact = updateContactRes.json<{ data: ContentAdmin }>().data;
    assert.equal(updatedContact.version, 2);

    // 7. POST /api/v1/admin/content/contacts/:contentId/publish (Terbitkan kontak)
    const publishContactRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/content/contacts/${contactContentId}/publish`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"2"',
      },
    });
    assert.equal(publishContactRes.statusCode, 200);
    const publishedContact = publishContactRes.json<{ data: ContentAdmin }>()
      .data;
    assert.equal(publishedContact.state, 'PUBLISHED');
    assert.equal(publishedContact.version, 3);
    assert.ok(publishedContact.published);

    // 8. POST /api/v1/admin/content/guides (Buat draf panduan & terbitkan)
    const createGuideRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/content/guides',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        title: 'Panduan Evakuasi Banjir Mandiri',
        body: '1. Matikan aliran listrik dari meteran utama.\n2. Amankan tas siaga bencana.\n3. Ikuti rute evakuasi menuju titik kumpul tertinggi.',
        source: {
          label: 'Buku Saku Tanggap Bencana BNPB',
          url: 'https://bnpb.go.id',
          checkedAt: new Date().toISOString(),
          state: 'VERIFIED',
        },
      },
    });
    assert.equal(createGuideRes.statusCode, 201);
    const guideAdmin = createGuideRes.json<{ data: ContentAdmin }>().data;
    const guideContentId = guideAdmin.id;

    const publishGuideRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/content/guides/${guideContentId}/publish`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"1"',
      },
    });
    assert.equal(publishGuideRes.statusCode, 200);

    // 9. POST /api/v1/admin/content/catalog (Buat draf katalog & terbitkan)
    const createCatalogRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/content/catalog',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        name: 'Senter Tahan Air & Baterai Cadangan',
        unit: 'Buah',
        quantity: 2,
        mode: 'HOUSEHOLD',
        ageGroups: ['ADULT'],
        specialNeeds: [],
        general: true,
        source: {
          label: 'Standar Tas Siaga BNPB',
          url: 'https://bnpb.go.id',
          checkedAt: new Date().toISOString(),
          state: 'VERIFIED',
        },
      },
    });
    assert.equal(createCatalogRes.statusCode, 201);
    const catalogAdmin = createCatalogRes.json<{ data: ContentAdmin }>().data;
    const catalogContentId = catalogAdmin.id;

    const publishCatalogRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/content/catalog/${catalogContentId}/publish`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"1"',
      },
    });
    assert.equal(publishCatalogRes.statusCode, 200);

    // 10. GET /api/v1/public/content/manifest (Setelah publikasi)
    const manifestRes = await app.inject({
      method: 'GET',
      url: '/api/v1/public/content/manifest',
    });
    assert.equal(manifestRes.statusCode, 200);
    const latestManifest = manifestRes.json<{ data: ContentManifest }>().data;
    const currentRev = latestManifest.revision;
    assert.ok(currentRev >= 2);

    const contactPart = latestManifest.parts.find((p) => p.kind === 'contacts');
    assert.ok(contactPart);
    assert.ok(contactPart.count >= 1);
    assert.equal(contactPart.sha256.length, 64);

    // 11. GET /api/v1/public/content/:revision/:kind (Ambil bagian konten)
    const getContactsPartRes = await app.inject({
      method: 'GET',
      url: `/api/v1/public/content/${currentRev}/contacts`,
    });
    assert.equal(getContactsPartRes.statusCode, 200);
    const contactsPartPage = getContactsPartRes.json<{
      data: ContentItemPage;
    }>().data;
    assert.ok(contactsPartPage.items.length >= 1);
    assert.ok(
      contactsPartPage.items.some(
        (it) => 'name' in it && it.name.includes('BPBD'),
      ),
    );

    const getGuidesPartRes = await app.inject({
      method: 'GET',
      url: `/api/v1/public/content/${currentRev}/guides`,
    });
    assert.equal(getGuidesPartRes.statusCode, 200);
    const guidesPartPage = getGuidesPartRes.json<{ data: ContentItemPage }>()
      .data;
    assert.ok(guidesPartPage.items.length >= 1);

    const getCatalogPartRes = await app.inject({
      method: 'GET',
      url: `/api/v1/public/content/${currentRev}/catalog`,
    });
    assert.equal(getCatalogPartRes.statusCode, 200);
    const catalogPartPage = getCatalogPartRes.json<{ data: ContentItemPage }>()
      .data;
    assert.ok(catalogPartPage.items.length >= 1);

    // 12. POST /api/v1/admin/content/contacts/:contentId/withdraw (Tarik konten terbit)
    const withdrawRes = await app.inject({
      method: 'POST',
      url: `/api/v1/admin/content/contacts/${contactContentId}/withdraw`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"3"',
      },
    });
    assert.equal(withdrawRes.statusCode, 200);
    const withdrawnItem = withdrawRes.json<{ data: ContentAdmin }>().data;
    assert.equal(withdrawnItem.state, 'WITHDRAWN');
    assert.equal(withdrawnItem.published, null);

    // 13. DELETE /api/v1/admin/content/:kind/:contentId (Hapus draf)
    const createDraftRes = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/content/contacts',
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
      },
      payload: {
        name: 'Kontak Draf Sementara',
        description: 'Akan dihapus',
        phone: '+6281234567890',
        source: {
          label: 'Uji Coba',
          url: 'https://example.invalid',
          checkedAt: null,
          state: 'EXAMPLE',
        },
      },
    });
    assert.equal(createDraftRes.statusCode, 201);
    const draftToDeleteId = createDraftRes.json<{ data: ContentAdmin }>().data
      .id;

    const deleteDraftRes = await app.inject({
      method: 'DELETE',
      url: `/api/v1/admin/content/contacts/${draftToDeleteId}`,
      headers: {
        authorization: `Bearer ${adminToken}`,
        'idempotency-key': randomUUID(),
        'if-match': '"1"',
      },
    });
    assert.equal(deleteDraftRes.statusCode, 200);
  } finally {
    // Cleanup DB test
    await withBusinessTransaction(pool, async (connection) => {
      await connection.execute('DELETE FROM content_revisions');
      await connection.execute('DELETE FROM content_items');
      await connection.execute('DELETE FROM `groups` WHERE id = ?', [groupId]);
      await connection.execute('DELETE FROM sessions WHERE account_id = ?', [
        adminId,
      ]);
      await connection.execute('DELETE FROM commands WHERE actor_scope = ?', [
        actorScope(keys.journal, 'account', adminId),
      ]);
      await connection.execute('DELETE FROM accounts WHERE id = ?', [adminId]);
    });
  }
}
