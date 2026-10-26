import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/panduan/domain/langkah_panduan.dart';
import 'package:siagabanjir/features/panduan/presentation/layar_detail_panduan.dart';

Future<void> _loadTestFonts() async {
  final fonts = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
  }
  await fonts.load();
}

Future<void> _openGuidesDetail(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const SiagaBanjirApp());
  await tester.pumpAndSettle();

  // Ketuk kartu "Panduan Selamat" pada akses cepat beranda.
  final guidesTarget = find.text('Panduan Selamat');
  await tester.ensureVisible(guidesTarget);
  await tester.pumpAndSettle();
  await tester.tap(guidesTarget);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadTestFonts);

  testWidgets(
    'Panduan Selamat tile opens LayarDetailPanduan matching exact SVG design elements',
    (tester) async {
      await _openGuidesDetail(tester);
      expect(find.byType(LayarDetailPanduan), findsOneWidget);
      expect(find.text('Panduan Selamat'), findsWidgets);

      // Verifikasi banner audio darurat persis sesuai SVG
      expect(find.text('Bantuan Suara Panduan'), findsOneWidget);
      expect(
        find.text('Dengarkan instruksi dan panduan suara'),
        findsOneWidget,
      );
      expect(find.text('Dengarkan Panduan Suara'), findsOneWidget);

      // Verifikasi judul bagian langkah evakuasi persis sesuai SVG
      expect(find.text('Langkah Menghadapi Banjir'), findsOneWidget);

      // Verifikasi 5 tahapan evakuasi persis sesuai SVG
      for (final step in kDefaultGuideSteps) {
        final stepTitle = find.text(step.title);
        await tester.ensureVisible(stepTitle);
        await tester.pumpAndSettle();
        expect(stepTitle, findsOneWidget);
        expect(find.text(step.description), findsOneWidget);
      }

      // Verifikasi kartu Wajib dan Dilarang persis sesuai SVG
      final wajibTitle = find.text('Wajib');
      await tester.ensureVisible(wajibTitle);
      await tester.pumpAndSettle();
      expect(wajibTitle, findsOneWidget);
      expect(find.text('Dilarang'), findsOneWidget);

      expect(find.text('Prioritaskan keselamatan jiwa.'), findsOneWidget);
      expect(find.text('Menerobos arus deras di atas betis'), findsOneWidget);

      // Ketuk tombol kembali untuk kembali ke beranda
      final backButton = find.bySemanticsLabel('Kembali');
      await tester.ensureVisible(backButton);
      await tester.pumpAndSettle();
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(LayarDetailPanduan), findsNothing);
    },
  );

  testWidgets(
    'Audio banner toggles playback state and displays feedback snackbar',
    (tester) async {
      await _openGuidesDetail(tester);

      final audioButton = find.text('Dengarkan Panduan Suara');
      await tester.ensureVisible(audioButton);
      await tester.pumpAndSettle();

      // Mulai pemutaran audio
      await tester.tap(audioButton);
      await tester.pumpAndSettle();

      expect(find.text('Hentikan Panduan Suara'), findsOneWidget);
      expect(find.text('Memutar instruksi suara panduan...'), findsOneWidget);

      // Hentikan pemutaran audio
      final stopButton = find.text('Hentikan Panduan Suara');
      await tester.tap(stopButton);
      await tester.pumpAndSettle();

      expect(find.text('Dengarkan Panduan Suara'), findsOneWidget);
      expect(find.text('Panduan suara dihentikan.'), findsOneWidget);
    },
  );

  testWidgets('Toggling step card accordion collapses and re-expands details', (
    tester,
  ) async {
    await _openGuidesDetail(tester);

    // Langkah 1 terbuka secara default
    expect(find.text(kDefaultGuideSteps[0].description), findsOneWidget);

    // Tutup langkah 1
    final step1Header = find.text(kDefaultGuideSteps[0].title);
    await tester.ensureVisible(step1Header);
    await tester.pumpAndSettle();
    await tester.tap(step1Header);
    await tester.pumpAndSettle();

    // Deskripsi langkah 1 sekarang tertutup
    expect(find.text(kDefaultGuideSteps[0].description), findsNothing);

    // Buka langkah 1 kembali
    await tester.tap(step1Header);
    await tester.pumpAndSettle();

    expect(find.text(kDefaultGuideSteps[0].description), findsOneWidget);
  });

  testWidgets(
    'LayarDetailPanduan layout is responsive and free of overflow across screen sizes',
    (tester) async {
      const testSizes = [
        Size(360, 640),
        Size(390, 844),
        Size(412, 915),
        Size(768, 1024),
      ];

      for (final size in testSizes) {
        await _openGuidesDetail(tester, size: size);
        expect(tester.takeException(), isNull);

        // Gulir hingga bawah
        final scrollTarget = find.text('Dilarang');
        await tester.ensureVisible(scrollTarget);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Kembali ke beranda
        final backButton = find.bySemanticsLabel('Kembali');
        await tester.ensureVisible(backButton);
        await tester.pumpAndSettle();
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }
    },
  );

  testWidgets('Text scaling 2.0 does not cause overflow or broken layout', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _openGuidesDetail(tester);
    expect(tester.takeException(), isNull);

    final scrollTarget = find.text('Wajib');
    await tester.ensureVisible(scrollTarget);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
