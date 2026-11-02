import 'package:flutter/foundation.dart';

import '../../features/autentikasi/domain/peran_pengguna.dart';

/// Model ringkas identitas akun aktif dalam sesi aplikasi SiagaBanjir.
class PenggunaSesi {
  const PenggunaSesi({
    required this.id,
    required this.nama,
    required this.email,
    required this.peran,
    this.nomorTelepon,
  });

  final String id;
  final String nama;
  final String email;
  final PeranPengguna peran;
  final String? nomorTelepon;
}

/// Pengelola status sesi dan token autentikasi aplikasi SiagaBanjir.
class PengelolaSesi extends ChangeNotifier {
  PengelolaSesi._();

  static final PengelolaSesi instance = PengelolaSesi._();

  int _generasi = 0;
  int get generasi => _generasi;
  String? _tokenSesi;
  PenggunaSesi? _pengguna;

  String? get tokenSesi => _tokenSesi;
  PenggunaSesi? get pengguna => _pengguna;
  bool get apakahMasuk => _tokenSesi != null && _tokenSesi!.isNotEmpty;

  /// Memperbarui sesi setelah login atau registrasi berhasil.
  void setSesi({required String token, required PenggunaSesi pengguna}) {
    _generasi++;
    _tokenSesi = token;
    _pengguna = pengguna;
    notifyListeners();
  }

  /// Menghapus sesi saat logout atau pencabutan sesi oleh backend.
  void hapusSesi() {
    _generasi++;
    _tokenSesi = null;
    _pengguna = null;
    notifyListeners();
  }
}
