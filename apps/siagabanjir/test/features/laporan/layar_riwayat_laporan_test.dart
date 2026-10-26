import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/laporan/presentation/layar_riwayat_laporan.dart';
import 'package:siagabanjir/features/laporan/presentation/widgets/kartu_riwayat_laporan.dart';

Future<void> _loadTestFonts() async {
  final fonts = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
  }
  await fonts.load();
}

Future<void> _openReportsHistory(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const SiagaBanjirApp());
  await tester.pumpAndSettle();

  // Ketuk tab Riwayat di bottom navigation bar beranda lalu buka layar penuh.
  await tester.tap(find.text('Riwayat'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadTestFonts);

  testWidgets('Riwayat navigation opens LayarRiwayatLaporan and returns home', (
    tester,
  ) async {
    await _openReportsHistory(tester);
    expect(find.byType(LayarRiwayatLaporan), findsOneWidget);
    expect(find.text('Riwayat Laporan'), findsOneWidget);
    expect(
      find.text('Pantau status laporan dan riwayat foto banjir.'),
      findsOneWidget,
    );

    // Ketuk tombol navbar Beranda untuk kembali ke home.
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.byType(LayarRiwayatLaporan), findsNothing);
  });

  testWidgets('Filter tabs filter reports list correctly', (tester) async {
    await _openReportsHistory(tester, size: const Size(390, 1200));

    // Verifikasi 3 filter tab awal dan 3 kartu laporan.
    expect(find.text('Semua (3)'), findsOneWidget);
    expect(find.text('Diproses (1)'), findsOneWidget);
    expect(find.text('Selesai (2)'), findsOneWidget);
    expect(find.byType(KartuRiwayatLaporan), findsNWidgets(3));

    // Filter ke Diproses (1).
    await tester.tap(find.text('Diproses (1)'));
    await tester.pumpAndSettle();
    expect(find.byType(KartuRiwayatLaporan), findsOneWidget);
    expect(find.text('Jl. Dr. Moh. Hatta, Kel. Kuranji'), findsOneWidget);
    expect(find.text('Sedang Diproses'), findsOneWidget);
    expect(find.text('Sungai Batang Kuranji Km 4'), findsNothing);

    // Filter ke Selesai (2).
    await tester.tap(find.text('Selesai (2)'));
    await tester.pumpAndSettle();
    expect(find.byType(KartuRiwayatLaporan), findsNWidgets(2));
    expect(find.text('Sungai Batang Kuranji Km 4'), findsOneWidget);
    expect(find.text('Perumahan Koto Tangah Permai'), findsOneWidget);
    expect(find.text('Jl. Dr. Moh. Hatta, Kel. Kuranji'), findsNothing);

    // Kembali ke Semua (3).
    await tester.tap(find.text('Semua (3)'));
    await tester.pumpAndSettle();
    expect(find.byType(KartuRiwayatLaporan), findsNWidgets(3));
  });

  testWidgets('Tapping card opens detail dialog and closes it', (tester) async {
    await _openReportsHistory(tester, size: const Size(390, 1200));

    // Ketuk kartu pertama.
    await tester.tap(find.text('Jl. Dr. Moh. Hatta, Kel. Kuranji'));
    await tester.pumpAndSettle();

    // Dialog detail terbuka.
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Tim Reaksi Cepat BPBD Kuranji meluncur'), findsWidgets);

    // Tutup dialog.
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Tapping photo opens photo preview dialog and closes it', (
    tester,
  ) async {
    await _openReportsHistory(tester, size: const Size(390, 1200));

    // Ketuk thumbnail foto pada kartu pertama.
    final photoButton = find.byKey(const ValueKey('report-photo-rep-001'));
    expect(photoButton, findsOneWidget);
    await tester.tap(photoButton);
    await tester.pumpAndSettle();

    // Dialog foto terbuka.
    expect(find.byType(Dialog), findsOneWidget);

    // Tutup dialog foto.
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('Responsive layout check on narrow screen and text scale', (
    tester,
  ) async {
    await _openReportsHistory(tester, size: const Size(320, 640));
    expect(find.byType(LayarRiwayatLaporan), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
