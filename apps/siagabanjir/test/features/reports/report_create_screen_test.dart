import 'dart:ui' show Tristate, CheckedState;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/reports/presentation/report_create_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('Inter');
    for (final weight in [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
      'ExtraBold',
    ]) {
      fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
    }
    await fonts.load();
  });

  Future<void> open(
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

  for (final entry in ['Lapor', 'Lapor Banjir Cepat']) {
    testWidgets('$entry opens the report page and returns home', (
      tester,
    ) async {
      await open(tester, entry: entry);
      expect(find.byType(ReportCreateScreen), findsOneWidget);
      await tester.tap(find.text('Beranda').last);
      await tester.pumpAndSettle();
      expect(find.byType(ReportCreateScreen), findsNothing);
    });
  }

  testWidgets(
    'Selections, unavailable services and discard preserve honest state',
    (tester) async {
      await open(tester);
      await tester.tap(find.text('Buka Kamera Ponsel'));
      await tester.pumpAndSettle();
      expect(find.text('Kamera belum tersedia'), findsOneWidget);
      await tester.tap(find.text('Mengerti'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sinkronisasi Lokasi GPS'));
      await tester.tap(find.text('Sinkronisasi Lokasi GPS'));
      await tester.pumpAndSettle();
      expect(find.text('GPS belum tersedia'), findsOneWidget);
      await tester.tap(find.text('Mengerti'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Genangan Hujan'));
      await tester.tap(find.text('Genangan Hujan'));
      await tester.pumpAndSettle();
      final semantics = tester.ensureSemantics();
      expect(
        tester
            .getSemantics(find.text('Genangan Hujan'))
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      await tester.ensureVisible(find.text('Bantuan Logistik'));
      await tester.tap(find.text('Bantuan Logistik'));
      await tester.pumpAndSettle();
      expect(
        tester
            .getSemantics(find.text('Bantuan Logistik'))
            .flagsCollection
            .isChecked,
        CheckedState.isTrue,
      );
      semantics.dispose();
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Air menggenangi jalan.');
      await tester.ensureVisible(find.text('Kirim Laporan Banjir'));
      await tester.tap(find.text('Kirim Laporan Banjir'));
      await tester.pumpAndSettle();
      expect(find.text('Laporan belum dikirim'), findsOneWidget);
      await tester.tap(find.text('Mengerti'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Riwayat').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Tutup pratinjau'));
      await tester.pumpAndSettle();
      expect(find.text('Air menggenangi jalan.'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Keluar dari laporan?'), findsOneWidget);
      await tester.tap(find.text('Lanjut mengisi'));
      await tester.pumpAndSettle();
      expect(find.text('Air menggenangi jalan.'), findsOneWidget);
      await tester.tap(find.text('Beranda').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keluar'));
      await tester.pumpAndSettle();
      expect(find.byType(ReportCreateScreen), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Report controls expose labels, touch targets and contrast', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await open(tester);
      tester.view.physicalSize = const Size(390, 1600);
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    } finally {
      semantics.dispose();
    }
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('Small screen and keyboard support text scale $scale', (
      tester,
    ) async {
      await open(tester, scale: scale);
      tester.view.physicalSize = const Size(320, 640);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Kirim Laporan Banjir'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Contoh kondisi');
      tester.view.viewInsets = const FakeViewPadding(bottom: 250);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
