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
      'client': peran == PeranPengguna.admin ? 'ADMIN_WEB' : 'ANDROID',
    };

    final res = await _klien.post(
      '/api/v1/auth/login',
      body: payload,
      headers: {'Idempotency-Key': identitasAksi()},
    );
    final data = res['data'] as Map<String, dynamic>;
    final token = (data['accessToken'] ?? data['token']) as String;
    final userMap = (data['account'] ?? data['user']) as Map<String, dynamic>;
    final roleStr = userMap['role'] as String;
    final roleMatches = peran == PeranPengguna.admin
        ? (roleStr == 'ADMIN' || roleStr == 'ADMIN_WEB')
        : (roleStr == 'CITIZEN' || roleStr == 'WARGA');
    if (!roleMatches) {
      throw StateError('Peran akun tidak sesuai halaman masuk.');
    }

    final pengguna = PenggunaSesi(
      id: userMap['id'] as String,
      nama: (userMap['displayName'] ?? userMap['name'] ?? 'Warga') as String,
      email: userMap['email'] as String,
      peran: peran,
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
      '/api/v1/auth/signup',
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
        '/api/v1/auth/logout',
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
      '/api/v1/auth/reset-password',
      body: payload,
      headers: {'Idempotency-Key': identitasAksi()},
    );
    final data = res['data'] as Map<String, dynamic>?;
    return (data?['recoveryCode'] as String?) ?? '';
  }
}
