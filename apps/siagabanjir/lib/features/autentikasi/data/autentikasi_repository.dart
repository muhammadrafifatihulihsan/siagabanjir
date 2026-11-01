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
      'identifier': identifier,
      'password': sandi,
      'expectedRole': peran == PeranPengguna.admin ? 'ADMIN_WEB' : 'WARGA',
    };

    final res = await _klien.post('/api/v1/auth/login', body: payload);
    final data = res['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final userMap = data['user'] as Map<String, dynamic>;

    final pengguna = PenggunaSesi(
      id: userMap['id'] as String,
      nama: userMap['name'] as String,
      email: userMap['email'] as String,
      peran: peran,
      nomorTelepon: userMap['phone'] as String?,
    );

    PengelolaSesi.instance.setSesi(
      token: token,
      pengguna: pengguna,
    );

    return pengguna;
  }

  /// Mendaftarkan akun baru warga ke `/api/v1/auth/signup`.
  Future<void> daftar({
    required String nama,
    required String email,
    required String sandi,
    String? nomorTelepon,
  }) async {
    final payload = {
      'name': nama,
      'email': email,
      'password': sandi,
      if (nomorTelepon != null && nomorTelepon.isNotEmpty)
        'phone': nomorTelepon,
    };

    await _klien.post('/api/v1/auth/signup', body: payload);
  }

  /// Keluar dari sesi aktif dan mencabut token di server via `/api/v1/auth/logout`.
  Future<void> keluar() async {
    try {
      await _klien.post('/api/v1/auth/logout');
    } finally {
      PengelolaSesi.instance.hapusSesi();
    }
  }

  /// Memulihkan kata sandi dengan kode pemulihan via `/api/v1/auth/reset-password`.
  Future<void> pulihkanSandi({
    required String identifier,
    required String kodePemulihan,
    required String sandiBaru,
  }) async {
    final payload = {
      'identifier': identifier,
      'recoveryCode': kodePemulihan,
      'newPassword': sandiBaru,
    };

    await _klien.post('/api/v1/auth/reset-password', body: payload);
  }
}
