import 'package:flutter/foundation.dart';

/// Konfigurasi URL dan parameter jaringan untuk komunikasi dengan Backend Fastify SiagaBanjir.
class KonfigurasiApi {
  const KonfigurasiApi._();

  /// URL domain tunnel remote publik (prioritas utama jika aktif).
  static const String defaultRemoteUrl = 'https://api.rafitesting.cloud';

  /// URL fallback lokal tergantung pada platform yang berjalan:
  /// - Web & Desktop: `http://127.0.0.1:3000`
  /// - Android Emulator: `http://10.0.2.2:3000`
  /// - Android Device fisik (via ADB reverse loopback): `http://127.0.0.1:3000`
  static String get defaultLocalUrl {
    if (kIsWeb) {
      return Uri.base.port == 8080 || Uri.base.scheme == 'https'
          ? Uri.base.origin
          : 'http://127.0.0.1:3000';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }

    return 'http://127.0.0.1:3000';
  }

  /// URL aktif yang saat ini digunakan (bisa diubah dinamis saat runtime jika remote offline).
  static String? _activeBaseUrl;

  /// Mengatur secara manual atau mencatat fallback URL aktif saat runtime.
  static void setBaseUrl(String url) {
    _activeBaseUrl = _normalisasiUrl(url);
  }

  /// Memastikan URL dinormalisasi dan mengenkripsi komunikasi remote dengan HTTPS.
  static String _normalisasiUrl(String url) {
    var bersih = url.trim().replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.tryParse(bersih);
    if (uri != null) {
      final host = uri.host.toLowerCase();
      final isLocal =
          host == '127.0.0.1' || host == 'localhost' || host == '10.0.2.2';
      if (!isLocal && uri.scheme == 'http') {
        bersih = bersih.replaceFirst('http://', 'https://');
      }
    }
    return bersih;
  }

  /// Menentukan Base URL yang tepat:
  /// 1. Prioritas tertinggi: Nilai flag kompilasi `--dart-define=API_BASE_URL=...`
  /// 2. Jika ada override aktif di runtime, gunakan itu
  /// 3. Bawaan utama: Domain tunnel remote `https://api.rafitesting.cloud`
  /// 4. Fallback jika remote offline: `defaultLocalUrl` (localhost / 10.0.2.2)
  static String get baseUrl {
    const dariEnv = String.fromEnvironment('API_BASE_URL');
    if (dariEnv.isNotEmpty) {
      return _normalisasiUrl(dariEnv);
    }

    if (_activeBaseUrl != null && _activeBaseUrl!.isNotEmpty) {
      return _activeBaseUrl!;
    }

    return defaultRemoteUrl;
  }

  /// Durasi batas waktu (timeout) untuk permintaan HTTP standar.
  static const Duration batasWaktu = Duration(seconds: 10);
}
