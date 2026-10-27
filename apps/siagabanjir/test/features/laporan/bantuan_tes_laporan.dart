import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';

// Memuat Inter lokal supaya layout tes memakai ukuran glyph yang sebenarnya.
Future<void> loadReportFonts() async {
  final fonts = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
  }
  await fonts.load();
}

// Membuka form melalui home dan memulihkan konfigurasi viewport seusai tes.
Future<void> openReport(
  WidgetTester tester, {
  double scale = 1,
  String entry = 'Lapor',
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(const SiagaBanjirApp());
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text(entry));
  await tester.tap(find.text(entry));
  await tester.pumpAndSettle();
}
