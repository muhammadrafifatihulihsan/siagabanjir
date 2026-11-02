import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/core/perangkat/layanan_lokasi.dart';

// Memuat Inter lokal supaya layout tes memakai ukuran glyph yang sebenarnya.
Future<void> loadReportFonts() async {
  final fonts = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
  }
  await fonts.load();
}

// Layanan GPS siap pakai: memberi posisi tetap agar alur lapor dapat diuji.
LayananLokasi gpsSiap() => LayananLokasi(
  pengambil: () async => const PosisiPengguna(
    latitude: -0.9471,
    longitude: 100.4172,
    akurasiMeter: 8,
  ),
);

// Membuka form melalui home dan memulihkan konfigurasi viewport seusai tes.
Future<void> openReport(
  WidgetTester tester, {
  double scale = 1,
  String entry = 'Lapor',
  LayananLokasi? layananLokasi,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(SiagaBanjirApp(layananLokasi: layananLokasi));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text(entry));
  await tester.tap(find.text(entry));
  await tester.pumpAndSettle();
}
