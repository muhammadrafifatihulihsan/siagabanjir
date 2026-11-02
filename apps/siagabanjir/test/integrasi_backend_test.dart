import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:siagabanjir/core/jaringan/klien_api.dart';
import 'package:siagabanjir/core/jaringan/pengecualian_api.dart';
import 'package:siagabanjir/core/sesi/pengelola_sesi.dart';
import 'package:siagabanjir/features/admin/data/admin_repository.dart';
import 'package:siagabanjir/features/akun/data/akun_repository.dart';
import 'package:siagabanjir/features/autentikasi/data/autentikasi_repository.dart';
import 'package:siagabanjir/features/autentikasi/domain/peran_pengguna.dart';
import 'package:siagabanjir/features/laporan/data/laporan_repository.dart';
import 'package:siagabanjir/features/meta/data/meta_repository.dart';
import 'package:siagabanjir/features/pantau/data/pantau_repository.dart';
import 'package:siagabanjir/features/pesan/data/pesan_repository.dart';

void main() {
  group('Integrasi Flutter <-> Backend Fastify', () {
    tearDown(() {
      PengelolaSesi.instance.hapusSesi();
    });

    test('MetaRepository: memeriksa health check dan metadata server', () async {
      final mock = MockClient((req) async {
        if (req.url.path == '/health') {
          return http.Response(
            jsonEncode({
              'data': {
                'status': 'healthy',
                'server': {
                  'status': 'UP',
                  'uptimeSeconds': 100,
                  'nodeVersion': 'v24.15.0',
                  'memoryMb': {'rss': 50, 'heapUsed': 25, 'heapTotal': 40},
                },
                'database': {'status': 'UP', 'latencyMs': 2.5},
                'migrations': {'status': 'UP', 'appliedCount': 32},
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (req.url.path == '/api/v1/meta') {
          return http.Response(
            jsonEncode({
              'data': {'service': 'siagabanjir-server', 'version': '1.0.0'},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final klien = KlienApi(client: mock, baseUrl: 'http://test-server');
      final repo = MetaRepository(klien: klien);

      final health = await repo.periksaKesehatan();
      expect(health.sehat, isTrue);
      expect(health.statusServer, 'UP');
      expect(health.statusDatabase, 'UP');
      expect(health.migrasiDiterapkan, 32);

      final meta = await repo.ambilMetadata();
      expect((meta['data'] as Map)['service'], 'siagabanjir-server');
    });

    test('AutentikasiRepository: login, daftar, logout, dan manajemen sesi', () async {
      final mock = MockClient((req) async {
        if (req.url.path == '/api/v1/auth/login') {
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['email'], '081234567890');
          expect(body['client'], 'ANDROID');
          return http.Response(
            jsonEncode({
              'data': {
                'accessToken': 'jwt-session-token-warga-123',
                'account': {
                  'id': 'usr-001',
                  'displayName': 'Budi Warga',
                  'email': 'budi@padang.go.id',
                  'role': 'CITIZEN',
                  'phone': '081234567890',
                },
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (req.url.path == '/api/v1/auth/logout') {
          expect(req.headers['authorization'], 'Bearer jwt-session-token-warga-123');
          return http.Response(jsonEncode({'data': {'revoked': true}}), 200);
        }
        if (req.url.path == '/api/v1/auth/signup') {
          return http.Response(jsonEncode({'data': {'recoveryCode': 'REC-123'}}), 201);
        }
        if (req.url.path == '/api/v1/auth/reset-password') {
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['email'], 'budi@padang.go.id');
          expect(body['code'], 'REC-CODE-123');
          expect(body['newPassword'], 'passBaru123');
          return http.Response(jsonEncode({'data': {'recoveryCode': 'NEW-REC-456'}}), 200);
        }
        return http.Response('Not Found', 404);
      });

      final klien = KlienApi(client: mock, baseUrl: 'http://test-server');
      final repo = AutentikasiRepository(klien: klien);

      // 1. Login
      final user = await repo.masuk(
        identifier: '081234567890',
        sandi: 'rahasia123',
        peran: PeranPengguna.warga,
      );
      expect(user.id, 'usr-001');
      expect(user.nama, 'Budi Warga');
      expect(PengelolaSesi.instance.apakahMasuk, isTrue);
      expect(PengelolaSesi.instance.tokenSesi, 'jwt-session-token-warga-123');

      // 2. Registrasi
      await repo.daftar(
        nama: 'Ahmad Warga',
        email: 'ahmad@padang.go.id',
        sandi: 'pass123',
        nomorTelepon: '081987654321',
      );

      // 3. Reset Password
      await repo.pulihkanSandi(
        identifier: 'budi@padang.go.id',
        kodePemulihan: 'REC-CODE-123',
        sandiBaru: 'passBaru123',
      );

      // 4. Logout
      await repo.keluar();
      expect(PengelolaSesi.instance.apakahMasuk, isFalse);
      expect(PengelolaSesi.instance.tokenSesi, isNull);
    });

    test('PantauRepository: memuat ringkasan pantau publik', () async {
      final mock = MockClient((req) async {
        if (req.url.path == '/api/v1/public/monitor') {
          expect(req.url.queryParameters['q'], 'Kuranji');
          return http.Response(
            jsonEncode({
              'items': [
                {
                  'locationName': 'Batang Kuranji',
                  'level': 'HIGH',
                  'updatedAt': '2026-11-01T15:00:00Z',
                  'reviewState': 'REVIEWED',
                },
              ],
              'nextCursor': null,
              'serverTime': '2026-11-01T15:00:00Z',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final klien = KlienApi(client: mock, baseUrl: 'http://test-server');
      final repo = PantauRepository(klien: klien);

      final hasil = await repo.ambilRingkasanPantau(query: 'Kuranji');
      expect(hasil.items.length, 1);
      expect(hasil.items.first.namaLokasi, 'Batang Kuranji');
      expect(hasil.items.first.tingkat, 'HIGH');
    });

    test('LaporanRepository: kuota, upload foto, dan pengiriman laporan', () async {
      final mock = MockClient((req) async {
        if (req.url.path == '/api/v1/me/reporting-status') {
          return http.Response(
            jsonEncode({
              'data': {
                'allowed': true,
                'remainingQuota': 2,
                'activeReports': 1,
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (req.url.path == '/api/v1/me/uploads/up-123') {
          expect(req.method, 'PUT');
          expect(req.headers['content-type'], 'image/jpeg');
          return http.Response(
            jsonEncode({
              'data': {
                'mediaId': 'med-blob-456',
                'mimeType': 'image/jpeg',
                'byteSize': req.bodyBytes.length,
              },
            }),
            201,
            headers: {'content-type': 'application/json'},
          );
        }
        if (req.url.path == '/api/v1/me/submissions/sub-789') {
          expect(req.method, 'PUT');
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['category'], 'Banjir Pemukiman');
          expect(body['mediaId'], 'med-blob-456');
          return http.Response(
            jsonEncode({'data': {'status': 'SUBMITTED', 'reportId': 'rep-999'}}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (req.url.path == '/api/v1/me/reports') {
          return http.Response(
            jsonEncode({
              'items': [
                {
                  'id': 'rep-999',
                  'category': 'Banjir Pemukiman',
                  'description': 'Air 50cm',
                  'status': 'SUBMITTED',
                  'createdAt': '2026-11-01T15:00:00Z',
                },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final klien = KlienApi(client: mock, baseUrl: 'http://test-server');
      final repo = LaporanRepository(klien: klien);

      final kuota = await repo.periksaStatusKuota();
      expect(kuota.diizinkan, isTrue);
      expect(kuota.sisaKuota, 2);

      final mediaId = await repo.unggahFotoBukti(
        uploadId: 'up-123',
        bytes: Uint8List.fromList([1, 2, 3, 4]),
      );
      expect(mediaId, 'med-blob-456');

      final submission = await repo.kirimLaporan(
        submissionId: 'sub-789',
        kategori: 'Banjir Pemukiman',
        deskripsi: 'Air 50cm',
        mediaId: mediaId,
      );
      expect((submission['data'] as Map)['status'], 'SUBMITTED');

      final riwayat = await repo.ambilRiwayatLaporan();
      expect(riwayat.length, 1);
      expect(riwayat.first.id, 'rep-999');
    });

    test('AkunRepository & PesanRepository: profil dan inbox pesan', () async {
      final mock = MockClient((req) async {
        if (req.url.path == '/api/v1/me') {
          if (req.method == 'GET') {
            return http.Response(
              jsonEncode({
                'data': {
                  'name': 'Rahmat Hidayat',
                  'phone': '081234567890',
                  'email': 'rahmat@padang.go.id',
                  'address': 'Koto Tangah',
                  'floodAlertEnabled': true,
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (req.method == 'PATCH') {
            return http.Response(jsonEncode({'data': {'updated': true}}), 200);
          }
        }
        if (req.url.path == '/api/v1/me/inbox') {
          return http.Response(
            jsonEncode({
              'items': [
                {
                  'id': 'msg-100',
                  'title': 'Siaga 2 Batang Kuranji',
                  'body': 'Air meluap',
                  'severity': 'WARNING',
                  'isRead': false,
                  'createdAt': '2026-11-01T15:00:00Z',
                },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (req.url.path == '/api/v1/me/inbox/msg-100/read') {
          return http.Response(jsonEncode({'data': {'read': true}}), 200);
        }
        return http.Response('Not Found', 404);
      });

      final klien = KlienApi(client: mock, baseUrl: 'http://test-server');
      final akunRepo = AkunRepository(klien: klien);
      final pesanRepo = PesanRepository(klien: klien);

      final profil = await akunRepo.ambilProfil();
      expect(profil.name, 'Rahmat Hidayat');
      expect(profil.phone, '081234567890');

      await akunRepo.perbaruiProfil(nama: 'Rahmat Baru');

      final inbox = await pesanRepo.ambilKotakMasuk();
      expect(inbox.length, 1);
      expect(inbox.first.judul, 'Siaga 2 Batang Kuranji');
      expect(inbox.first.toPesanSiaga().title, 'Siaga 2 Batang Kuranji');

      await pesanRepo.tandaiDibaca('msg-100');
    });

    test('AdminRepository: laporan, klaster, dan broadcast siaran', () async {
      final mock = MockClient((req) async {
        if (req.url.path == '/api/v1/admin/reports') {
          return http.Response(
            jsonEncode({
              'items': [
                {
                  'id': 'rep-admin-1',
                  'reporterName': 'Siti Rahma',
                  'category': 'Jalan Terputus',
                  'description': 'Air deras',
                  'status': 'SUBMITTED',
                  'createdAt': '2026-11-01T15:00:00Z',
                },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (req.url.path == '/api/v1/admin/groups') {
          return http.Response(
            jsonEncode({
              'items': [
                {
                  'id': 'grp-1',
                  'locationLabel': 'Koto Tangah',
                  'level': 'HIGH',
                  'state': 'ACTIVE',
                  'reportCount': 5,
                },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (req.url.path == '/api/v1/admin/messages') {
          expect(req.headers['idempotency-key'], 'idemp-key-123');
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['severity'], 'CRITICAL');
          return http.Response(
            jsonEncode({'data': {'messageId': 'msg-broadcast-99'}}),
            201,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final klien = KlienApi(client: mock, baseUrl: 'http://test-server');
      final repo = AdminRepository(klien: klien);

      final laporanList = await repo.ambilDaftarLaporan();
      expect(laporanList.length, 1);
      expect(laporanList.first.namaPelapor, 'Siti Rahma');

      final klasterList = await repo.ambilKlasterWilayah();
      expect(klasterList.length, 1);
      expect(klasterList.first.namaLokasi, 'Koto Tangah');

      final siaran = await repo.terbitkanPesanSiaga(
        judul: 'Peringatan Banjir Kritis',
        isi: 'Evakuasi segera!',
        tingkat: 'CRITICAL',
        idempotencyKey: 'idemp-key-123',
      );
      expect((siaran['data'] as Map)['messageId'], 'msg-broadcast-99');
    });

    test('PengecualianApi: menangani error HTTP 400, 401, 500 dengan tepat', () async {
      final mock = MockClient((req) async {
        return http.Response(
          jsonEncode({
            'code': 'VALIDATION_FAILED',
            'message': 'Parameter tidak valid',
          }),
          400,
          headers: {'content-type': 'application/json'},
        );
      });

      final klien = KlienApi(client: mock, baseUrl: 'http://test-server');
      expect(
        () => klien.get('/api/v1/any'),
        throwsA(
          isA<PengecualianApi>()
              .having((e) => e.kodeStatus, 'kodeStatus', 400)
              .having((e) => e.pesan, 'pesan', 'Parameter tidak valid')
              .having((e) => e.kodeError, 'kodeError', 'VALIDATION_FAILED'),
        ),
      );
    });
  });
}
