import 'package:url_launcher/url_launcher.dart';

/// Tautan Google Maps untuk satu koordinat (tanpa API key, mode pencarian).
Uri tautanPetaGoogle(double latitude, double longitude) => Uri.parse(
  'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
);

/// Membuka Google Maps pada peramban/aplikasi peta eksternal.
///
/// Mengembalikan `false` bila perangkat tidak dapat membuka tautan sehingga UI
/// dapat memberi umpan balik tanpa melempar error ke pengguna.
Future<bool> bukaPetaGoogle(
  double latitude,
  double longitude, {
  LaunchMode mode = LaunchMode.externalApplication,
}) async {
  try {
    return await launchUrl(tautanPetaGoogle(latitude, longitude), mode: mode);
  } on Object {
    return false;
  }
}
