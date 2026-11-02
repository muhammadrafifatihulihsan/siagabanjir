import 'dart:math';

import '../../../core/jaringan/endpoint_api.dart';
import '../../../core/jaringan/klien_api.dart';
import '../domain/profil_pengguna.dart';

/// Repositori penghubung fitur Akun & Profil Warga ke endpoint Fastify Backend.
///
/// Profil memakai field kontrak nyata (`displayName`, `phone`, `address`,
/// `floodAlertEnabled`) sehingga perubahan di aplikasi benar-benar tersimpan
/// dan terbaca kembali, bukan menimpa dengan data contoh.
class AkunRepository {
  AkunRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  /// Versi resource terakhir dari `GET /api/v1/me` untuk header `If-Match`.
  int? _versi;

  /// Membaca data profil akun sendiri via `GET /api/v1/me`.
  Future<ProfilPengguna> ambilProfil() async {
    final data = await _ambilDataProfil();
    return _petaProfil(data);
  }

  Future<Map<String, dynamic>> _ambilDataProfil() async {
    final res = await _klien.get(EndpointApi.me);
    final data = res is Map<String, dynamic>
        ? (res['data'] as Map<String, dynamic>? ?? res)
        : <String, dynamic>{};
    final versi = data['version'];
    if (versi is int) _versi = versi;
    return data;
  }

  ProfilPengguna _petaProfil(Map<String, dynamic> data) {
    final nama = (data['displayName'] ?? data['name'] ?? '').toString().trim();
    final alamat = (data['address'] ?? '').toString().trim();
    final namaTampil = nama.isEmpty ? 'Warga Siaga' : nama;
    final parts = namaTampil.split(RegExp(r'\s+'));
    final inisial = parts
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return ProfilPengguna(
      name: namaTampil,
      phone: (data['phone'] ?? '').toString().trim(),
      location: alamat,
      initials: inisial.isEmpty ? 'WS' : inisial,
      email: (data['email'] ?? '').toString().trim(),
      address: alamat,
      floodAlertEnabled: data['floodAlertEnabled'] != false,
    );
  }

  /// Memperbarui profil akun sendiri via `PATCH /api/v1/me`.
  ///
  /// Header `If-Match` dan `Idempotency-Key` wajib dipenuhi kontrak backend.
  Future<void> perbaruiProfil({
    String? nama,
    String? telepon,
    String? alamat,
    bool? peringatanBanjir,
  }) async {
    if (_versi == null) await _ambilDataProfil();

    final payload = <String, dynamic>{
      'displayName': ?nama,
      'phone': ?telepon,
      'address': ?alamat,
      'floodAlertEnabled': ?peringatanBanjir,
    };
    if (payload.isEmpty) return;

    final res = await _klien.patch(
      EndpointApi.me,
      body: payload,
      headers: {
        'If-Match': '"${_versi ?? 1}"',
        'Idempotency-Key': _uuidV4(),
      },
    );
    final data = res is Map<String, dynamic>
        ? (res['data'] as Map<String, dynamic>? ?? res)
        : null;
    final versi = data?['version'];
    if (versi is int) _versi = versi;
  }

  /// Memperbarui kata sandi atau email akun via `POST /api/v1/me/credentials`.
  Future<void> perbaruiKredensial({
    required String sandiSaatIni,
    String? emailBaru,
    String? sandiBaru,
  }) async {
    final payload = <String, dynamic>{
      'currentPassword': sandiSaatIni,
      'email': ?emailBaru,
      'newPassword': ?sandiBaru,
    };

    await _klien.post(EndpointApi.meCredentials, body: payload);
  }

  /// Menghasilkan kode pemulihan akun baru via `POST /api/v1/me/recovery-code`.
  Future<String> buatKodePemulihan() async {
    final res = await _klien.post(EndpointApi.meRecoveryCode);
    final data = res['data'] as Map<String, dynamic>? ?? res;
    return data['recoveryCode'] as String? ?? '';
  }

  String _uuidV4() {
    final acak = Random.secure();
    final bytes = List<int>.generate(16, (_) => acak.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
