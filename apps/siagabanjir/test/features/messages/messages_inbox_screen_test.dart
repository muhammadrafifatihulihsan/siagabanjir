import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/messages/presentation/messages_inbox_screen.dart';
import 'package:siagabanjir/features/messages/presentation/widgets/message_card.dart';

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

  testWidgets('Notifications button opens MessagesInboxScreen and returns home', (
    tester,
  ) async {
    await _openInbox(tester);
    expect(find.byType(MessagesInboxScreen), findsOneWidget);
    expect(find.text('Peringatan Siaga'), findsOneWidget);
    expect(find.text('3 Baru'), findsOneWidget);

    // Ketuk tombol kembali di header.
    await tester.tap(find.bySemanticsLabel('Kembali'));
    await tester.pumpAndSettle();
    expect(find.byType(MessagesInboxScreen), findsNothing);

    // Buka kembali dan uji tombol navbar Beranda.
    await tester.tap(find.byTooltip('Notifikasi'));
    await tester.pumpAndSettle();
    expect(find.byType(MessagesInboxScreen), findsOneWidget);
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.byType(MessagesInboxScreen), findsNothing);
  });

  testWidgets('Filter tabs filter messages list correctly', (tester) async {
    await _openInbox(tester);

    // Verifikasi 4 filter tab awal dan 4 kartu pesan.
    expect(find.text('Semua (4)'), findsOneWidget);
    expect(find.text('Darurat (1)'), findsOneWidget);
    expect(find.text('Cuaca BMKG (1)'), findsOneWidget);
    expect(find.text('Posko (1)'), findsOneWidget);
    expect(find.byType(MessageCard), findsNWidgets(4));

    // Filter ke Darurat.
    await tester.tap(find.text('Darurat (1)'));
    await tester.pumpAndSettle();
    expect(find.byType(MessageCard), findsOneWidget);
    expect(
      find.text('Waspada Luapan Sungai Lubuk Kilangan & Kuranji'),
      findsOneWidget,
    );

    // Filter ke Cuaca BMKG.
    await tester.tap(find.text('Cuaca BMKG (1)'));
    await tester.pumpAndSettle();
    expect(find.byType(MessageCard), findsOneWidget);
    expect(
      find.text('Peringatan Dini Cuaca Ekstrem Kota Padang'),
      findsOneWidget,
    );

    // Filter ke Posko.
    await tester.tap(find.text('Posko (1)'));
    await tester.pumpAndSettle();
    expect(find.byType(MessageCard), findsOneWidget);
    expect(
      find.text('Pembukaan Posko Pengungsian di SMPN 12 Padang'),
      findsOneWidget,
    );

    // Kembalikan ke Semua.
    await tester.tap(find.text('Semua (4)'));
    await tester.pumpAndSettle();
    expect(find.byType(MessageCard), findsNWidgets(4));
  });

  testWidgets('Action buttons and card tap trigger dialogs properly', (
    tester,
  ) async {
    await _openInbox(tester);

    // Ketuk tombol aksi Rute Evakuasi.
    await tester.tap(find.text('Rute Evakuasi'));
    await tester.pumpAndSettle();
    expect(find.text('Rute Evakuasi'), findsWidgets);
    expect(find.text('Mengerti'), findsOneWidget);
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();
    expect(find.text('Mengerti'), findsNothing);

    // Ketuk kartu pertama untuk melihat detail pesan.
    await tester.tap(find.text('Waspada Luapan Sungai Lubuk Kilangan & Kuranji'));
    await tester.pumpAndSettle();
    expect(find.text('Tutup'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.text('Tutup'), findsNothing);
  });

  testWidgets('Responsive layout check on narrow screen', (tester) async {
    await _openInbox(tester, size: const Size(320, 640));
    expect(find.byType(MessagesInboxScreen), findsOneWidget);
    expect(find.text('Peringatan Siaga'), findsOneWidget);
    expect(find.byType(MessageCard), findsWidgets);
  });
}
