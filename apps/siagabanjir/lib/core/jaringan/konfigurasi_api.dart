import 'package:flutter/foundation.dart';

/// Konfigurasi URL dan parameter jaringan untuk komunikasi dengan Backend Fastify SiagaBanjir.
class KonfigurasiApi {
  const KonfigurasiApi._();

  /// Menentukan Base URL yang tepat tergantung pada platform eksekusi:
  /// - Web & Desktop: `http://127.0.0.1:3000`
  /// - Android Emulator: `http://10.0.2.2:3000` (akses host loopback)
  /// - Dapat ditimpa melalui compile-time flag: `--dart-define=API_BASE_URL=http://...`
  static String get baseUrl {
    const dariEnv = String.fromEnvironment('API_BASE_URL');
    if (dariEnv.isNotEmpty) {
      return dariEnv;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:3000';
    }

    // Android emulator mengakses host OS loopback melalui IP virtual 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }

    return 'http://127.0.0.1:3000';
  }

  /// Durasi batas waktu (timeout) untuk permintaan HTTP standar.
  static const Duration batasWaktu = Duration(seconds: 10);
}
