import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/akun/presentation/layar_profil.dart';
import 'package:siagabanjir/features/laporan/presentation/layar_buat_laporan.dart';
import 'package:siagabanjir/shared/widgets/citizen_header.dart';
import 'package:siagabanjir/shared/widgets/citizen_navigation.dart';

import 'features/laporan/bantuan_tes_laporan.dart';

void main() {
  setUpAll(loadReportFonts);
  testWidgets(
    'Header tetap, profil dan laporan memakai state yang sama saat pindah tab',
    (t) async {
      await t.pumpWidget(const SiagaBanjirApp());
      await t.pumpAndSettle();
      final header = t.element(find.byType(CitizenHeader));
      final headerWidget = header.widget;
      await t.tap(find.text('Profil').last);
      await t.pumpAndSettle();
      final profil = t.state(find.byType(LayarProfil));
      expect(t.element(find.byType(CitizenHeader)), same(header));
      expect(t.widget(find.byType(CitizenHeader)), same(headerWidget));
      await t.tap(find.text('Lapor').last);
      await t.pumpAndSettle();
      final laporan = t.state(find.byType(LayarBuatLaporan));
      await t.ensureVisible(find.byType(TextField));
      await t.enterText(find.byType(TextField), 'Isian tersimpan di tab');
      await t.tap(find.text('Profil').last);
      await t.pumpAndSettle();
      expect(t.state(find.byType(LayarProfil)), same(profil));
      await t.tap(find.text('Lapor').last);
      await t.pumpAndSettle();
      expect(t.state(find.byType(LayarBuatLaporan)), same(laporan));
      expect(find.text('Isian tersimpan di tab'), findsOneWidget);
      expect(find.byType(CitizenNavigation), findsOneWidget);
    },
  );
  testWidgets('Keluar membuang sesi lama dan masuk demo membuat state baru', (
    t,
  ) async {
    await t.pumpWidget(const SiagaBanjirApp());
    await t.pumpAndSettle();
    await t.tap(find.text('Profil').last);
    await t.pumpAndSettle();
    await t.tap(find.text('Edit Profil'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextFormField).first, 'Nama Sesi Lama');
    await t.tap(find.text('Simpan Perubahan'));
    await t.pumpAndSettle();
    await t.pump(const Duration(seconds: 3));
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('Keluar dari Akun'));
    await t.pumpAndSettle();
    await t.tap(find.text('Keluar dari Akun'));
    await t.pumpAndSettle();
    await t.tap(find.text('Keluar'));
    await t.pumpAndSettle();
    expect(find.byType(CitizenNavigation), findsNothing);
    await t.enterText(find.byType(TextFormField).at(0), 'uji@example.com');
    await t.enterText(find.byType(TextFormField).at(1), 'contoh');
    await t.ensureVisible(find.text('Masuk ke SiagaBanjir'));
    await t.tap(find.text('Masuk ke SiagaBanjir'));
    await t.pumpAndSettle();
    await t.tap(find.text('Profil').last);
    await t.pumpAndSettle();
    expect(find.text('Nama Sesi Lama'), findsNothing);
    expect(find.text('Rahmat Hidayat'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
