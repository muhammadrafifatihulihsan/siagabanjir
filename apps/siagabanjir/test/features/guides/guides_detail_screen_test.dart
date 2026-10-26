import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/guides/domain/guide_step.dart';
import 'package:siagabanjir/features/guides/presentation/guides_detail_screen.dart';

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
    'Panduan Selamat tile opens GuidesDetailScreen with audio banner, 5 steps, and do/dont cards',
    (tester) async {
      await _openGuidesDetail(tester);
      expect(find.byType(GuidesDetailScreen), findsOneWidget);
      expect(find.text('Panduan Selamat'), findsWidgets);

      // Verifikasi banner audio darurat
      expect(find.text('Instruksi Suara Darurat'), findsOneWidget);
      expect(
        find.text('Dengarkan instruksi suara dalam situasi darurat'),
        findsOneWidget,
      );
      expect(find.text('Dengarkan Panduan'), findsOneWidget);

      // Verifikasi judul bagian langkah evakuasi
      expect(find.text('Langkah Evakuasi Mandiri'), findsOneWidget);

      // Verifikasi 5 tahapan evakuasi
      for (final step in kDefaultGuideSteps) {
        final stepTitle = find.text(step.title);
        await tester.ensureVisible(stepTitle);
        await tester.pumpAndSettle();
        expect(stepTitle, findsOneWidget);
      }

      // Verifikasi kartu Lakukan dan Hindari
      final doTitle = find.text('Lakukan');
      await tester.ensureVisible(doTitle);
      await tester.pumpAndSettle();
      expect(doTitle, findsOneWidget);
      expect(find.text('Hindari'), findsOneWidget);

      // Ketuk tombol kembali untuk kembali ke beranda
      final backButton = find.bySemanticsLabel('Kembali');
      await tester.ensureVisible(backButton);
      await tester.pumpAndSettle();
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(GuidesDetailScreen), findsNothing);
    },
  );

  testWidgets(
    'Audio banner toggles playback state and displays feedback snackbar',
    (tester) async {
      await _openGuidesDetail(tester);

      final audioButton = find.text('Dengarkan Panduan');
      await tester.ensureVisible(audioButton);
      await tester.pumpAndSettle();

      // Mulai pemutaran audio
      await tester.tap(audioButton);
      await tester.pumpAndSettle();

      expect(find.text('Hentikan Instruksi Suara'), findsOneWidget);
      expect(
        find.text('Memutar instruksi suara evakuasi darurat...'),
        findsOneWidget,
      );

      // Hentikan pemutaran audio
      final stopButton = find.text('Hentikan Instruksi Suara');
      await tester.tap(stopButton);
      await tester.pumpAndSettle();

      expect(find.text('Dengarkan Panduan'), findsOneWidget);
      expect(find.text('Instruksi suara dihentikan.'), findsOneWidget);
    },
  );

  testWidgets(
    'Toggling step card accordion expands and collapses details',
    (tester) async {
      await _openGuidesDetail(tester);

      // Langkah 1 terbuka secara default
      expect(
        find.text(kDefaultGuideSteps[0].instructions[0]),
        findsOneWidget,
      );

      // Langkah 2 tertutup di awal
      expect(
        find.text(kDefaultGuideSteps[1].instructions[0]),
        findsNothing,
      );

      // Buka langkah 2
      final step2Header = find.text(kDefaultGuideSteps[1].title);
      await tester.ensureVisible(step2Header);
      await tester.pumpAndSettle();
      await tester.tap(step2Header);
      await tester.pumpAndSettle();

      // Instruksi langkah 2 sekarang terlihat
      expect(
        find.text(kDefaultGuideSteps[1].instructions[0]),
        findsOneWidget,
      );

      // Tutup langkah 2 kembali
      await tester.tap(step2Header);
      await tester.pumpAndSettle();

      expect(
        find.text(kDefaultGuideSteps[1].instructions[0]),
        findsNothing,
      );
    },
  );

  testWidgets(
    'GuidesDetailScreen layout is responsive and free of overflow across screen sizes',
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
        final scrollTarget = find.text('Hindari');
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

  testWidgets(
    'Text scaling 2.0 does not cause overflow or broken layout',
    (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await _openGuidesDetail(tester);
      expect(tester.takeException(), isNull);

      final scrollTarget = find.text('Lakukan');
      await tester.ensureVisible(scrollTarget);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
