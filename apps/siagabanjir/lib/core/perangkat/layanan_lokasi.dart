import 'package:geolocator/geolocator.dart';

/// Posisi perangkat yang sudah divalidasi untuk dipakai laporan warga.
class PosisiPengguna {
  const PosisiPengguna({
    required this.latitude,
    required this.longitude,
    required this.akurasiMeter,
  });

  final double latitude;
  final double longitude;
  final double akurasiMeter;

  /// Label koordinat ringkas 5 desimal (±1 m) untuk ditampilkan di formulir.
  String get labelKoordinat =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
}

/// Kegagalan memperoleh lokasi dengan pesan siap tampil ke warga.
class LokasiTidakTersediaException implements Exception {
  const LokasiTidakTersediaException(this.pesan);

  final String pesan;

  @override
  String toString() => pesan;
}

typedef PengambilPosisi = Future<PosisiPengguna> Function();

/// Layanan lokasi GPS nyata dengan izin bertahap (denied → request).
///
/// Pengambil posisi dapat diganti pada pengujian sehingga widget test tidak
/// memanggil channel platform.
class LayananLokasi {
  const LayananLokasi({this.pengambil});

  final PengambilPosisi? pengambil;

  Future<PosisiPengguna> ambilPosisi({
    Duration batasWaktu = const Duration(seconds: 20),
  }) async {
    final ambil = pengambil;
    if (ambil != null) return ambil();

    final aktif = await Geolocator.isLocationServiceEnabled();
    if (!aktif) {
      throw const LokasiTidakTersediaException(
        'Layanan lokasi perangkat belum aktif. Aktifkan GPS lalu coba lagi.',
      );
    }

    var izin = await Geolocator.checkPermission();
    if (izin == LocationPermission.denied) {
      izin = await Geolocator.requestPermission();
    }
    if (izin == LocationPermission.denied) {
      throw const LokasiTidakTersediaException(
        'Izin lokasi ditolak. SiagaBanjir memerlukan lokasi untuk memverifikasi titik laporan.',
      );
    }
    if (izin == LocationPermission.deniedForever) {
      throw const LokasiTidakTersediaException(
        'Izin lokasi diblokir permanen. Buka Pengaturan aplikasi lalu izinkan akses lokasi.',
      );
    }

    try {
      final posisi = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: batasWaktu,
        ),
      );
      return PosisiPengguna(
        latitude: posisi.latitude,
        longitude: posisi.longitude,
        akurasiMeter: posisi.accuracy,
      );
    } on Object {
      throw const LokasiTidakTersediaException(
        'Lokasi tidak terdeteksi dalam 20 detik. Pastikan GPS aktif dan berada di area terbuka.',
      );
    }
  }
}
