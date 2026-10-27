import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/laporan/presentation/widgets/kartu_riwayat_laporan.dart';

void main() {
  testWidgets(
    'Riwayat hanya menampilkan catatan yang disimpan; detail dibuka dengan ketuk',
    (t) async {
      t.view.physicalSize = const Size(390, 844);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      await t.pumpWidget(const SiagaBanjirApp());
      await t.pumpAndSettle();
      await t.tap(find.text('Riwayat'));
      await t.pumpAndSettle();
      expect(find.text('Tidak ada laporan'), findsOneWidget);
      await t.tap(find.text('Lapor'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Luapan Sungai'));
      await t.tap(find.text('Luapan Sungai'));
      await t.pumpAndSettle();
      await t.enterText(
        find.byType(TextField),
        'Air masuk halaman rumah penguji.',
      );
      await t.testTextInput.receiveAction(TextInputAction.done);
      await t.ensureVisible(find.text('Simpan ke Riwayat'));
      await t.tap(find.text('Simpan ke Riwayat'));
      await t.pumpAndSettle();
      await t.tap(find.text('Simpan Laporan'));
      await t.pumpAndSettle();
      await t.tap(find.text('Riwayat'));
      await t.pumpAndSettle();
      expect(find.byType(KartuRiwayatLaporan), findsOneWidget);
      expect(find.text('Air masuk halaman rumah penguji.'), findsOneWidget);
      expect(find.textContaining('Tim Reaksi'), findsNothing);
      await t.tap(find.byType(KartuRiwayatLaporan));
      await t.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Kebutuhan: Tidak dipilih'), findsOneWidget);
      await t.tap(find.text('Tutup'));
      await t.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
