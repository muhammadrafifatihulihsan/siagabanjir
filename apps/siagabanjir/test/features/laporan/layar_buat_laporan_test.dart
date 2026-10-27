import 'dart:ui' show CheckedState;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'bantuan_tes_laporan.dart';

import 'package:siagabanjir/features/laporan/presentation/layar_buat_laporan.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadReportFonts);

  // Kedua pintu masuk harus mengarah ke layar laporan yang sama.
  for (final entry in ['Lapor', 'Lapor Banjir Cepat']) {
    testWidgets('$entry opens the report page and returns home', (
      tester,
    ) async {
      await openReport(tester, entry: entry);
      expect(find.byType(LayarBuatLaporan), findsOneWidget);
      await tester.tap(find.text('Beranda').last);
      await tester.pumpAndSettle();
      expect(find.byType(LayarBuatLaporan), findsNothing);
    });
  }

  // Memeriksa pilihan, keterbatasan layanan, retensi input, dan batal keluar.
  testWidgets(
    'Selections, unavailable services and discard preserve honest state',
    (tester) async {
      await openReport(tester);
      await tester.ensureVisible(find.text('Sinkronisasi Lokasi GPS'));
      await tester.tap(find.text('Sinkronisasi Lokasi GPS'));
      await tester.pumpAndSettle();
      expect(find.text('Lokasi Terdeteksi'), findsOneWidget);
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
      await tester.ensureVisible(find.text('Simpan ke Riwayat'));
      await tester.tap(find.text('Simpan ke Riwayat'));
      await tester.pumpAndSettle();
      expect(find.text('Simpan Laporan?'), findsOneWidget);
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Riwayat').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lapor').last);
      await tester.pumpAndSettle();
      expect(find.text('Air menggenangi jalan.'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(LayarBuatLaporan), findsNothing);
      await tester.tap(find.text('Lapor').last);
      await tester.pumpAndSettle();
      expect(find.text('Air menggenangi jalan.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
