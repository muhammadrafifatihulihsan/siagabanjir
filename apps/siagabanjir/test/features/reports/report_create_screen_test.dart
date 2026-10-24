import 'dart:ui' show CheckedState;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'report_test_helpers.dart';

import 'package:siagabanjir/features/reports/presentation/report_create_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadReportFonts);

  // Kedua pintu masuk harus mengarah ke layar laporan yang sama.
  for (final entry in ['Lapor', 'Lapor Banjir Cepat']) {
    testWidgets('$entry opens the report page and returns home', (
      tester,
    ) async {
      await openReport(tester, entry: entry);
      expect(find.byType(ReportCreateScreen), findsOneWidget);
      await tester.tap(find.text('Beranda').last);
      await tester.pumpAndSettle();
      expect(find.byType(ReportCreateScreen), findsNothing);
    });
  }

  // Memeriksa pilihan, keterbatasan layanan, retensi input, dan batal keluar.
  testWidgets(
    'Selections, unavailable services and discard preserve honest state',
    (tester) async {
      await openReport(tester);
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
            .isChecked,
        CheckedState.isTrue,
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
}
