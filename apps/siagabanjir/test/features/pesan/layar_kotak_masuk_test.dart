import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/pesan/presentation/layar_kotak_masuk.dart';
import 'package:siagabanjir/features/pesan/presentation/widgets/kartu_pesan.dart';

Future<void> _loadTestFonts() async {
  final fonts = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
  }
  await fonts.load();
}

Future<void> _openInbox(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const SiagaBanjirApp());
  await tester.pumpAndSettle();

  // Ketuk tombol notifikasi di header beranda.
  await tester.tap(find.byTooltip('Notifikasi'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadTestFonts);

  testWidgets('Notifications button opens LayarKotakMasuk and returns home', (
    tester,
  ) async {
    await _openInbox(tester);
    expect(find.byType(LayarKotakMasuk), findsOneWidget);
    expect(find.text('Peringatan Siaga'), findsOneWidget);
    expect(find.text('2 Baru'), findsOneWidget);

    // Ketuk tombol kembali di header.
    await tester.tap(find.bySemanticsLabel('Kembali'));
    await tester.pumpAndSettle();
    expect(find.byType(LayarKotakMasuk), findsNothing);

    // Buka kembali dan uji tombol navbar Beranda.
    await tester.tap(find.byTooltip('Notifikasi'));
    await tester.pumpAndSettle();
    expect(find.byType(LayarKotakMasuk), findsOneWidget);
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.byType(LayarKotakMasuk), findsNothing);
  });

  testWidgets('Filter tabs filter messages list correctly', (tester) async {
    // Layar lebih tinggi agar 4 kartu terrender sekaligus tanpa lazy-load.
    await _openInbox(tester, size: const Size(390, 1200));

    // Verifikasi 4 filter tab awal dan 4 kartu pesan.
    expect(find.text('Semua (3)'), findsOneWidget);
    expect(find.text('Darurat (1)'), findsOneWidget);
    expect(find.text('Cuaca BMKG (1)'), findsOneWidget);
    expect(find.text('Posko (1)'), findsNothing);
    expect(find.byType(KartuPesan), findsNWidgets(3));

    // Filter ke Darurat.
    await tester.ensureVisible(find.text('Darurat (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Darurat (1)'));
    await tester.pumpAndSettle();
    expect(find.byType(KartuPesan), findsOneWidget);
    expect(
      find.text('Waspada Luapan Sungai Lubuk Kilangan & Kuranji'),
      findsOneWidget,
    );

    // Filter ke Cuaca BMKG.
    await tester.ensureVisible(find.text('Cuaca BMKG (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuaca BMKG (1)'));
    await tester.pumpAndSettle();
    expect(find.byType(KartuPesan), findsOneWidget);
    expect(
      find.text('Peringatan Dini Cuaca Ekstrem Kota Padang'),
      findsOneWidget,
    );

    // Kembalikan ke Semua.
    await tester.ensureVisible(find.text('Semua (3)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Semua (3)'));
    await tester.pumpAndSettle();
    expect(find.byType(KartuPesan), findsNWidgets(3));
  });

  testWidgets('Action buttons and card tap trigger dialogs properly', (
    tester,
  ) async {
    await _openInbox(tester);

    expect(find.text('Rute Evakuasi'), findsNothing);
    // Aksi berbagi masih tersedia.
    await tester.tap(find.text('Bagikan'));
    await tester.pumpAndSettle();
    expect(find.text('Salin Pesan'), findsOneWidget);
    expect(find.text('Mengerti'), findsOneWidget);
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();
    expect(find.text('Mengerti'), findsNothing);

    // Ketuk kartu pertama untuk melihat detail pesan.
    await tester.tap(
      find.text('Waspada Luapan Sungai Lubuk Kilangan & Kuranji'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tutup'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.text('Tutup'), findsNothing);
  });

  testWidgets('Responsive layout check on narrow screen', (tester) async {
    await _openInbox(tester, size: const Size(320, 640));
    expect(find.byType(LayarKotakMasuk), findsOneWidget);
    expect(find.text('Peringatan Siaga'), findsOneWidget);
    expect(find.byType(KartuPesan), findsWidgets);
  });
}
