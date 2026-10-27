import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/dokumen/presentation/layar_dokumen_siaga.dart';
import 'package:siagabanjir/shared/theme/siaga_theme.dart';

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

  Future<void> openDocumentsVault(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double scale = 1,
    VoidCallback? onHome,
    VoidCallback? onReport,
    VoidCallback? onHistory,
    VoidCallback? onProfile,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        theme: SiagaTheme.light,
        home: LayarDokumenSiaga(
          onHome: onHome,
          onReport: onReport,
          onHistory: onHistory,
          onProfile: onProfile,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Daftar dokumen dimulai kosong tanpa berkas rekaan', (
    tester,
  ) async {
    await openDocumentsVault(tester);
    expect(find.text('Dokumen Siaga'), findsOneWidget);
    expect(find.text('Tambah Dokumen'), findsOneWidget);
    expect(find.textContaining('Belum ada dokumen'), findsOneWidget);
    await tester.tap(find.text('Tambah Dokumen'));
    await tester.pumpAndSettle();
    expect(find.text('Scan dengan Kamera'), findsOneWidget);
    expect(find.text('Pilih PDF / Gambar'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Belum ada dokumen'), findsOneWidget);
  });

  testWidgets(
    'Tile Dokumen Siaga on LayarBeranda opens LayarDokumenSiaga and returns home',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const SiagaBanjirApp());
      await tester.pumpAndSettle();

      // Verifikasi berada di Beranda
      expect(find.text('Dokumen Siaga'), findsOneWidget);

      // Tap kartu Dokumen Siaga Keluarga untuk membuka LayarDokumenSiaga
      await tester.ensureVisible(find.text('Dokumen Siaga Keluarga'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dokumen Siaga Keluarga'));
      await tester.pumpAndSettle();

      // Memastikan layar LayarDokumenSiaga terbuka
      expect(find.text('Tambah Dokumen'), findsOneWidget);

      // Tap tombol kembali untuk kembali ke Beranda
      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();

      // Memastikan kembali ke Beranda
      expect(find.text('Dokumen Siaga Keluarga'), findsOneWidget);
    },
  );

  for (final scenario in [
    (const Size(320, 640), 1.0),
    (const Size(390, 844), 1.0),
    (const Size(390, 1008), 1.0), // Ukuran SVG asli
    (const Size(1024, 768), 1.0),
    (const Size(844, 390), 1.0), // Landscape
    (const Size(320, 640), 2.0), // Layar sempit + text scaling 2.0x
    (const Size(390, 844), 2.0), // Layar standar + text scaling 2.0x
  ]) {
    testWidgets(
      'No overflow on DocumentsVault at ${scenario.$1}, scale ${scenario.$2}',
      (tester) async {
        await openDocumentsVault(tester, size: scenario.$1, scale: scenario.$2);
        expect(tester.takeException(), isNull);

        // Memastikan tombol paling bawah dapat dijangkau tanpa exception overflow
        await tester.ensureVisible(find.text('Tambah Dokumen'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
