import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/laporan/presentation/layar_buat_laporan.dart';

import 'bantuan_tes_laporan.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadReportFonts);

  // Tidak ada jawaban awal; membatalkan pilihan tidak menyisakan perubahan palsu.
  testWidgets(
    'Empty choices and reverted input can leave without confirmation',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await openReport(tester);
        for (final label in [
          'Luapan Sungai',
          'Banjir Bandang',
          'Genangan Hujan',
          'Perahu Karet',
          'Evakuasi Balita',
          'Bantuan Logistik',
          'Medis Darurat',
        ]) {
          await tester.ensureVisible(find.text(label));
          await tester.pumpAndSettle();
          expect(
            tester.getSemantics(find.text(label)).flagsCollection.isChecked,
            CheckedState.isFalse,
          );
        }
        await tester.tap(find.text('Medis Darurat'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Medis Darurat'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'Contoh');
        await tester.enterText(find.byType(TextField), '');
        await tester.tap(find.text('Beranda').last);
        await tester.pumpAndSettle();
        expect(find.text('Keluar dari laporan?'), findsNothing);
        expect(find.byType(LayarBuatLaporan), findsNothing);
      } finally {
        semantics.dispose();
      }
    },
  );

  // Tab aktif menggulir ke awal tanpa membuat route baru atau menghapus input.
  testWidgets('Active report tab scrolls to top while retaining text', (
    tester,
  ) async {
    await openReport(tester);
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Air di jalan');
    await tester.tap(find.text('Lapor').last);
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Lapor Kejadian Banjir')).dy,
      lessThan(200),
    );
    expect(find.text('Air di jalan'), findsOneWidget);
    expect(find.byType(LayarBuatLaporan), findsOneWidget);
  });

  // Navigasi Tab dan Space harus dapat memilih kategori tanpa mouse/sentuhan.
  testWidgets(
    'Keyboard selection is exclusive and switching tabs retains input',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await openReport(tester);
        await tester.ensureVisible(find.text('Luapan Sungai'));
        await tester.tap(find.text('Luapan Sungai'));
        await tester.pumpAndSettle();
        // Pada Android, tap tidak otomatis memindahkan fokus keyboard.
        for (var step = 0; step < 12; step++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pumpAndSettle();
          if (tester
                  .getSemantics(find.text('Banjir Bandang'))
                  .flagsCollection
                  .isFocused ==
              Tristate.isTrue) {
            break;
          }
        }
        expect(
          tester
              .getSemantics(find.text('Banjir Bandang'))
              .flagsCollection
              .isFocused,
          Tristate.isTrue,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(
          tester
              .getSemantics(find.text('Luapan Sungai'))
              .flagsCollection
              .isChecked,
          CheckedState.isFalse,
        );
        expect(
          tester
              .getSemantics(find.text('Banjir Bandang'))
              .flagsCollection
              .isChecked,
          CheckedState.isTrue,
        );
        await tester.ensureVisible(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'Air di jalan');
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text('Keluar dari laporan?'), findsNothing);
        await tester.tap(find.text('Lapor').last);
        await tester.pumpAndSettle();
        expect(find.text('Air di jalan'), findsOneWidget);
      } finally {
        semantics.dispose();
      }
    },
  );
}
