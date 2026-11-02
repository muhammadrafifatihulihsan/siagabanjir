import '../../../core/jaringan/endpoint_api.dart';
import '../../../core/jaringan/identitas_aksi.dart';
import '../../../core/jaringan/klien_api.dart';
import '../../../core/sesi/pengelola_sesi.dart';
import '../domain/peran_pengguna.dart';

/// Repositori penghubung fitur Autentikasi Flutter ke endpoint backend Fastify.
class AutentikasiRepository {
  AutentikasiRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  /// Melakukan login akun Warga atau Petugas Admin ke `/api/v1/auth/login`.
  Future<PenggunaSesi> masuk({
    required String identifier,
    required String sandi,
    required PeranPengguna peran,
  }) async {
    final payload = {
      'email': identifier.trim(),
      'password': sandi,
      'client': (peran == PeranPengguna.admin || identifier.trim().toLowerCase().contains('admin'))
          ? 'ADMIN_WEB'
          : 'ANDROID',
    };

    final res = await _klien.post(
      EndpointApi.login,
      body: payload,
      headers: {'Idempotency-Key': identitasAksi()},
    );
    final data = res['data'] as Map<String, dynamic>;
    final token = (data['accessToken'] ?? data['token']) as String;
    final userMap = (data['account'] ?? data['user']) as Map<String, dynamic>;
    final roleStr = (userMap['role'] as String?)?.toUpperCase() ?? 'CITIZEN';
    final actualRole = (roleStr == 'ADMIN' || roleStr == 'ADMIN_WEB')
        ? PeranPengguna.admin
        : PeranPengguna.warga;

    final pengguna = PenggunaSesi(
      id: userMap['id'] as String,
      nama: (userMap['displayName'] ?? userMap['name'] ?? (actualRole == PeranPengguna.admin ? 'Petugas Admin' : 'Warga')) as String,
      email: userMap['email'] as String,
      peran: actualRole,
      nomorTelepon: userMap['phone'] as String?,
    );

    PengelolaSesi.instance.setSesi(token: token, pengguna: pengguna);

    return pengguna;
  }

  /// Mendaftarkan akun baru warga ke `/api/v1/auth/signup`.
  Future<String> daftar({
    required String nama,
    required String email,
    required String sandi,
    String? nomorTelepon,
  }) async {
    final payload = {
      'displayName': nama,
      'email': email,
      'password': sandi,
      if (nomorTelepon != null && nomorTelepon.isNotEmpty)
        'phone': nomorTelepon,
    };

    final res = await _klien.post(
      EndpointApi.signup,
      body: payload,
      headers: {'Idempotency-Key': identitasAksi()},
    );
    final data = res['data'] as Map<String, dynamic>?;
    return (data?['recoveryCode'] as String?) ?? '';
  }

  /// Keluar dari sesi aktif dan mencabut token di server via `/api/v1/auth/logout`.
  Future<void> keluar() async {
    try {
      await _klien.post(
        EndpointApi.logout,
        headers: {'Idempotency-Key': identitasAksi()},
      );
    } finally {
      PengelolaSesi.instance.hapusSesi();
    }
  }

  /// Memulihkan kata sandi dengan kode pemulihan via `/api/v1/auth/reset-password`.
  Future<String> pulihkanSandi({
    required String identifier,
    required String kodePemulihan,
    required String sandiBaru,
  }) async {
    final payload = {
      'email': identifier.trim(),
      'code': kodePemulihan,
      'newPassword': sandiBaru,
    };

    final res = await _klien.post(
      EndpointApi.resetPassword,
      body: payload,
      headers: {'Idempotency-Key': identitasAksi()},
    );
    final data = res['data'] as Map<String, dynamic>?;
    return (data?['recoveryCode'] as String?) ?? '';
  }
}
