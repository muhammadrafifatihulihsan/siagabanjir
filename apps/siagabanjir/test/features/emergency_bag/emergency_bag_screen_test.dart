import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/emergency_bag/presentation/emergency_bag_screen.dart';

Future<void> _loadTestFonts() async {
  final fonts = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
  }
  await fonts.load();
}

Future<void> _openEmergencyBag(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const SiagaBanjirApp());
  await tester.pumpAndSettle();

  // Ketuk kartu "Tas Siaga" pada akses cepat beranda.
  final bagTarget = find.text('Tas Siaga');
  await tester.ensureVisible(bagTarget);
  await tester.pumpAndSettle();
  await tester.tap(bagTarget);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadTestFonts);

  testWidgets(
    'Tas Siaga tile opens EmergencyBagScreen with 12 of 14 items checked initially and returns home',
    (tester) async {
      await _openEmergencyBag(tester);
      expect(find.byType(EmergencyBagScreen), findsOneWidget);
      expect(find.text('Tas Siaga Bencana'), findsOneWidget);

      // Verifikasi ringkasan awal: 12 dari 14 Barang, 85%
      expect(find.text('Kesiapan Logistik Keluarga'), findsOneWidget);
      expect(find.text('12 dari 14 Barang'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);

      // Verifikasi 4 kategori utama
      expect(find.text('Dokumen Berharga'), findsOneWidget);
      expect(find.text('Obat & P3K Keluarga'), findsOneWidget);
      expect(find.text('Logistik & Komunikasi'), findsOneWidget);
      expect(find.text('Pakaian & Perlengkapan'), findsOneWidget);

      // Verifikasi banner info
      expect(
        find.text(
          'Simpan tas di dekat pintu utama yang mudah dijangkau saat sirine siaga berbunyi.',
        ),
        findsOneWidget,
      );

      // Ketuk tombol kembali di header
      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();
      expect(find.byType(EmergencyBagScreen), findsNothing);

      // Buka kembali dan uji tombol navbar Beranda
      await tester.tap(find.text('Tas Siaga'));
      await tester.pumpAndSettle();
      expect(find.byType(EmergencyBagScreen), findsOneWidget);
      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(find.byType(EmergencyBagScreen), findsNothing);
    },
  );

  testWidgets(
    'Toggling checklist items dynamically updates progress count and category status',
    (tester) async {
      await _openEmergencyBag(tester, size: const Size(390, 1200));

      expect(find.text('12 dari 14 Barang'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);

      // 1. Uncheck satu item pada Dokumen Berharga: "Uang tunai darurat pecahan kecil"
      final docItem = find.text('Uang tunai darurat pecahan kecil');
      expect(docItem, findsOneWidget);
      await tester.tap(docItem);
      await tester.pumpAndSettle();

      // Sekarang 11 dari 14 Barang (78%) dan Dokumen Berharga menjadi 2/3
      expect(find.text('11 dari 14 Barang'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);
      expect(find.text('2/3'), findsOneWidget);

      // 2. Check item kembali: menjadi 12 dari 14 (85%) dan 3/3
      await tester.tap(docItem);
      await tester.pumpAndSettle();
      expect(find.text('12 dari 14 Barang'), findsOneWidget);
      expect(find.text('85%'), findsOneWidget);
      expect(find.text('3/3'), findsNWidgets(2)); // Dokumen dan Obat keduanya 3/3

      // 3. Scroll ke Pakaian & Perlengkapan lalu centang dua item yang belum tercentang
      final plasticBag = find.text('Kantong plastik besar pelindung tas');
      await tester.ensureVisible(plasticBag);
      await tester.pumpAndSettle();
      await tester.tap(plasticBag);
      await tester.pumpAndSettle();

      // Sekarang 13 dari 14 Barang (92%)
      expect(find.text('13 dari 14 Barang'), findsOneWidget);
      expect(find.text('92%'), findsOneWidget);

      final blanket = find.text('Selimut termal darurat');
      await tester.ensureVisible(blanket);
      await tester.pumpAndSettle();
      await tester.tap(blanket);
      await tester.pumpAndSettle();

      // Semua 14 barang tercentang: 14 dari 14 Barang (100%) dan Pakaian menjadi 4/4
      expect(find.text('14 dari 14 Barang'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('4/4'), findsNWidgets(2)); // Logistik & Pakaian keduanya 4/4
    },
  );

  testWidgets(
    'EmergencyBagScreen layout is responsive and free of overflow across small and large screens',
    (tester) async {
      final testSizes = [
        const Size(320, 640),
        const Size(390, 844),
        const Size(844, 390),
        const Size(1024, 768),
      ];

      for (final size in testSizes) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(const SiagaBanjirApp());
        await tester.pumpAndSettle();

        final bagTarget = find.text('Tas Siaga');
        await tester.ensureVisible(bagTarget);
        await tester.pumpAndSettle();
        await tester.tap(bagTarget);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(EmergencyBagScreen), findsOneWidget);

        // Kembali ke beranda untuk ukuran berikutnya
        await tester.tap(find.bySemanticsLabel('Kembali'));
        await tester.pumpAndSettle();
      }
    },
  );

  testWidgets(
    'Text scaling 2.0 does not cause overflow or broken layout',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: const SiagaBanjirApp(),
        ),
      );
      await tester.pumpAndSettle();

      final bagTarget = find.text('Tas Siaga');
      await tester.ensureVisible(bagTarget);
      await tester.pumpAndSettle();
      await tester.tap(bagTarget);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(EmergencyBagScreen), findsOneWidget);
      expect(find.text('Tas Siaga Bencana'), findsOneWidget);
    },
  );
}
