import '../../../core/jaringan/endpoint_api.dart';
import '../../../core/jaringan/klien_api.dart';
import '../domain/profil_pengguna.dart';

/// Repositori penghubung fitur Akun & Profil Warga ke endpoint Fastify Backend.
class AkunRepository {
  AkunRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  /// Membaca data profil akun sendiri via `GET /api/v1/me`.
  Future<ProfilPengguna> ambilProfil() async {
    final res = await _klien.get(EndpointApi.me);
    final data = res['data'] as Map<String, dynamic>? ?? res;

    final namaLengkap = data['name'] as String? ?? 'Warga Siaga';
    final parts = namaLengkap.split(' ');
    final inisial = parts.map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return ProfilPengguna(
      name: namaLengkap,
      phone: data['phone'] as String? ?? '081234567890',
      location: data['location'] as String? ?? 'Kota Padang',
      initials: inisial.isNotEmpty ? inisial : 'WS',
      nik: data['nik'] as String? ?? '137107*********01',
      email: data['email'] as String? ?? 'warga@padang.go.id',
      address: data['address'] as String? ?? 'Kota Padang',
      floodAlertEnabled: data['floodAlertEnabled'] as bool? ?? true,
    );
  }

  /// Memperbarui profil akun sendiri via `PATCH /api/v1/me`.
  Future<void> perbaruiProfil({
    String? nama,
    String? telepon,
    String? alamat,
    bool? peringatanBanjir,
  }) async {
    final payload = <String, dynamic>{
      'name': ?nama,
      'phone': ?telepon,
      'address': ?alamat,
      'floodAlertEnabled': ?peringatanBanjir,
    };

    await _klien.patch(EndpointApi.me, body: payload);
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
}
