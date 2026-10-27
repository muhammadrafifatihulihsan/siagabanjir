import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/shared/widgets/citizen_navigation.dart';

import 'bantuan_tes_laporan.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadReportFonts);

  // Tata letak tetap dapat digulir pada orientasi mendatar dan jendela Web lebar.
  for (final size in [const Size(844, 390), const Size(1024, 768)]) {
    testWidgets('Report stays usable at $size', (tester) async {
      await openReport(tester);
      tester.view.physicalSize = size;
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Simpan ke Riwayat'));
      await tester.pumpAndSettle();
      expect(find.text('Simpan ke Riwayat').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  // Semua kontrol diperiksa tanpa pemotongan viewport saat mengukur target sentuh.
  testWidgets('Report controls expose labels, touch targets and contrast', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await openReport(tester);
      tester.view.physicalSize = const Size(390, 1900);
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    } finally {
      semantics.dispose();
    }
  });

  // Keyboard dan teks besar harus menyisakan ruang untuk membaca dan mengisi form.
  for (final scale in [1.0, 2.0]) {
    testWidgets('Small screen and keyboard support text scale $scale', (
      tester,
    ) async {
      await openReport(tester, scale: scale);
      tester.view.physicalSize = const Size(320, 640);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Simpan ke Riwayat'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Contoh kondisi');
      tester.view.viewInsets = const FakeViewPadding(bottom: 250);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(CitizenNavigation), findsNothing);
      await tester.ensureVisible(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byType(TextField)).bottom,
        lessThanOrEqualTo(390),
      );
    });
  }
}
