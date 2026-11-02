import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:siagabanjir/core/jaringan/klien_api.dart';
import 'package:siagabanjir/core/sesi/pengelola_sesi.dart';
import 'package:siagabanjir/features/autentikasi/data/autentikasi_repository.dart';
import 'package:siagabanjir/features/autentikasi/domain/peran_pengguna.dart';

void main() {
  setUp(() => PengelolaSesi.instance.hapusSesi());
  test('Pemulihan mengirim kode dan mengembalikan kode pengganti', () async {
    final repo = AutentikasiRepository(
      klien: KlienApi(
        baseUrl: 'http://test',
        client: MockClient((r) async {
          expect(r.url.path, '/api/v1/auth/reset-password');
          expect(jsonDecode(r.body), {
            'email': 'warga@example.invalid',
            'code': 'kode-lama',
            'newPassword': 'kata sandi baru',
          });
          return http.Response('{"data":{"recoveryCode":"kode-baru"}}', 200);
        }),
      ),
    );
    expect(
      await repo.pulihkanSandi(
        identifier: 'warga@example.invalid',
        kodePemulihan: 'kode-lama',
        sandiBaru: 'kata sandi baru',
      ),
      'kode-baru',
    );
    expect(PengelolaSesi.instance.apakahMasuk, false);
  });
  test('Unduh media memakai token dan menolak hasil lintas sesi', () async {
    PengelolaSesi.instance.setSesi(
      token: 'token-media',
      pengguna: const PenggunaSesi(
        id: 'warga',
        nama: 'Warga',
        email: 'warga@example.invalid',
        peran: PeranPengguna.warga,
      ),
    );
    var logout = false;
    final api = KlienApi(
      baseUrl: 'http://test',
      client: MockClient((r) async {
        expect(r.headers['authorization'], 'Bearer token-media');
        if (logout) PengelolaSesi.instance.hapusSesi();
        return http.Response.bytes([137, 80, 78, 71], 200);
      }),
    );
    expect(await api.unduh('/api/v1/media/test'), [137, 80, 78, 71]);
    logout = true;
    await expectLater(api.unduh('/api/v1/media/test'), throwsException);
  });
  test('Login memakai kontrak server dan identitas aksi UUID', () async {
    final repo = AutentikasiRepository(
      klien: KlienApi(
        baseUrl: 'http://test',
        client: MockClient((r) async {
          expect(jsonDecode(r.body), {
            'email': 'warga@example.invalid',
            'password': 'sandi panjang',
            'client': 'ANDROID',
          });
          expect(
            r.headers['idempotency-key'],
            matches(RegExp(r'^[0-9a-f-]{36}$')),
          );
          return http.Response(
            jsonEncode({
              'data': {
                'accessToken': 'token-test',
                'account': {
                  'id': 'id-test',
                  'displayName': 'Warga',
                  'email': 'warga@example.invalid',
                  'role': 'CITIZEN',
                  'version': 1,
                },
              },
            }),
            200,
          );
        }),
      ),
    );
    final user = await repo.masuk(
      identifier: 'warga@example.invalid',
      sandi: 'sandi panjang',
      peran: PeranPengguna.warga,
    );
    expect(user.nama, 'Warga');
    expect(PengelolaSesi.instance.tokenSesi, 'token-test');
  });
  test('Login ditolak tidak membuat sesi', () async {
    final repo = AutentikasiRepository(
      klien: KlienApi(
        baseUrl: 'http://test',
        client: MockClient(
          (_) async => http.Response(
            '{"code":"INVALID_CREDENTIALS","message":"Ditolak"}',
            401,
          ),
        ),
      ),
    );
    await expectLater(
      repo.masuk(
        identifier: 'warga@example.invalid',
        sandi: 'salah',
        peran: PeranPengguna.warga,
      ),
      throwsException,
    );
    expect(PengelolaSesi.instance.apakahMasuk, false);
  });
  test('Respons akun lama ditolak setelah logout', () async {
    final api = KlienApi(
      baseUrl: 'http://test',
      client: MockClient((_) async {
        PengelolaSesi.instance.hapusSesi();
        return http.Response('{"data":{}}', 200);
      }),
    );
    await expectLater(api.get('/api/v1/me'), throwsException);
  });
}
