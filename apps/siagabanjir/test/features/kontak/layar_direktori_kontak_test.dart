import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/kontak/presentation/models/entri_kontak.dart';
import 'package:siagabanjir/features/kontak/presentation/layar_direktori_kontak.dart';

Future<void> _loadTestFonts() async {
  final fonts = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
  }
  await fonts.load();
}

Future<void> _openContactsDirectory(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const SiagaBanjirApp());
  await tester.pumpAndSettle();

  // Ketuk kartu "Kontak Darurat" pada akses cepat beranda.
  final contactsTarget = find.text('Kontak Darurat');
  await tester.ensureVisible(contactsTarget);
  await tester.pumpAndSettle();
  await tester.tap(contactsTarget);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadTestFonts);

  testWidgets(
    'Kontak Darurat tile opens LayarDirektoriKontak and returns home',
    (tester) async {
      await _openContactsDirectory(tester);
      expect(find.byType(LayarDirektoriKontak), findsOneWidget);

      // Verifikasi info kontak darurat
      expect(
        find.text(
          'Hubungi posko atau instansi tanggap darurat saat membutuhkan bantuan.',
        ),
        findsOneWidget,
      );

      // Ketuk tombol kembali di header.
      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();
      expect(find.byType(LayarDirektoriKontak), findsNothing);

      // Buka kembali dan uji tombol navbar Beranda.
      await tester.tap(find.text('Kontak Darurat'));
      await tester.pumpAndSettle();
      expect(find.byType(LayarDirektoriKontak), findsOneWidget);
      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(find.byType(LayarDirektoriKontak), findsNothing);
    },
  );

  testWidgets('Filter tabs filter contact list by category correctly', (
    tester,
  ) async {
    await _openContactsDirectory(tester, size: const Size(390, 1400));

    // Kondisi awal (Semua): BPBD Kota Padang & Basarnas Padang muncul
    expect(find.text('BPBD Kota Padang'), findsOneWidget);
    expect(find.text('Basarnas Padang'), findsOneWidget);

    // Ketuk tab Darurat
    final daruratTab = find.text('Darurat (4)');
    await tester.ensureVisible(daruratTab);
    await tester.pumpAndSettle();
    await tester.tap(daruratTab);
    await tester.pumpAndSettle();

    expect(find.text('BPBD Kota Padang'), findsOneWidget);
    expect(find.text('Basarnas Padang'), findsOneWidget);
    expect(find.text('Damkar Kota Padang'), findsOneWidget);
    expect(find.text('Polresta Padang'), findsOneWidget);
    expect(find.text('PMI Kota Padang'), findsNothing);

    // Ketuk tab Kesehatan
    final kesehatanTab = find.text('Kesehatan (3)');
    await tester.ensureVisible(kesehatanTab);
    await tester.pumpAndSettle();
    await tester.tap(kesehatanTab);
    await tester.pumpAndSettle();

    expect(find.text('RSUP M. Djamil Padang'), findsOneWidget);
    expect(find.text('PMI Kota Padang'), findsOneWidget);
    expect(find.text('Ambulans Gawat Darurat'), findsOneWidget);
    expect(find.text('BPBD Kota Padang'), findsNothing);

    // Ketuk tab Infrastruktur
    final infraTab = find.text('Infrastruktur (2)');
    await tester.ensureVisible(infraTab);
    await tester.pumpAndSettle();
    await tester.tap(infraTab);
    await tester.pumpAndSettle();

    expect(find.text('PLN UP3 Padang'), findsOneWidget);
    expect(find.text('PDAM Kota Padang'), findsOneWidget);
    expect(find.text('RSUP M. Djamil Padang'), findsNothing);

    // Kembali ke Semua
    final semuaTab = find.text('Semua (9)');
    await tester.ensureVisible(semuaTab);
    await tester.pumpAndSettle();
    await tester.tap(semuaTab);
    await tester.pumpAndSettle();
    expect(find.text('BPBD Kota Padang'), findsOneWidget);
  });

  testWidgets(
    'Tapping copy button copies number to clipboard and displays SnackBar',
    (tester) async {
      // Mock clipboard handler
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (
            methodCall,
          ) async {
            log.add(methodCall);
            if (methodCall.method == 'Clipboard.setData') {
              return null;
            }
            return null;
          });

      await _openContactsDirectory(tester);

      // Cari tombol salin dengan label semantics
      final copyButtons = find.bySemanticsLabel(RegExp(r'^Salin nomor'));
      expect(copyButtons, findsWidgets);

      await tester.tap(copyButtons.first);
      await tester.pump(); // memicu SnackBar

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('disalin'), findsOneWidget);

      // Verifikasi clipboard method dipanggil dengan nomor kontak pertama
      final clipboardCalls = log
          .where((call) => call.method == 'Clipboard.setData')
          .toList();
      expect(clipboardCalls.length, 1);
      final args = clipboardCalls.first.arguments as Map<dynamic, dynamic>;
      expect(args['text'], kPublicContacts.first.phone);
    },
  );
}
