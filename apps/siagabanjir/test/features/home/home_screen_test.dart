import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/home/presentation/home_preview_sheet.dart';
import 'package:siagabanjir/features/home/presentation/widgets/home_feature_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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

  Future<void> openHome(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double scale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const SiagaBanjirApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Home bundles images locally without development labels', (
    tester,
  ) async {
    await openHome(tester);
    expect(find.text('SiagaBanjir'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('SiagaBanjir')))
          .textTheme
          .bodyMedium
          ?.fontFamily,
      'Inter',
    );
    expect(find.text('Data contoh'), findsNothing);
    expect(find.textContaining('Mockup beranda'), findsNothing);
    final images = tester.widgetList<Image>(find.byType(Image));
    expect(images, isNotEmpty);
    expect(images.every((image) => image.image is AssetImage), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Every home entry opens its preview and returns without losing scroll',
    (tester) async {
      await openHome(tester);
      for (final label in [
        'Pantau Status',
        'Pantau Wilayah',
        'Kontak Darurat',
        'Tas Siaga',
        'Panduan Selamat',
        'Dokumen Siaga Keluarga',
        'Riwayat',
        'Profil',
      ]) {
        final target = find.text(label);
        await tester.ensureVisible(target);
        await tester.pumpAndSettle();
        await tester.tap(target);
        await tester.pumpAndSettle();
        expect(find.byType(HomePreviewSheet), findsOneWidget, reason: label);
        expect(find.text('PRATINJAU FITUR'), findsOneWidget);
        await tester.tap(find.byTooltip('Tutup pratinjau'));
        await tester.pumpAndSettle();
        expect(find.byType(HomePreviewSheet), findsNothing);
        expect(tester.takeException(), isNull, reason: label);
      }
      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Sungai Batang Kuranji')).dy,
        lessThan(250),
      );
    },
  );

  testWidgets(
    'Notifications opens MessagesInboxScreen and complete access sheet works',
    (tester) async {
      await openHome(tester);

      // Ketuk tombol notifikasi → harus membuka MessagesInboxScreen.
      await tester.tap(find.byTooltip('Notifikasi'));
      await tester.pumpAndSettle();
      expect(find.text('Peringatan Siaga'), findsOneWidget);

      // Kembali ke beranda.
      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();
      expect(find.text('Peringatan Siaga'), findsNothing);

      // Buka sheet Lengkap dan navigasi ke Data Keluarga.
      await tester.tap(find.text('Lengkap'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Data Keluarga'));
      await tester.tap(find.text('Data Keluarga'));
      await tester.pumpAndSettle();
      expect(find.text('Data Keluarga'), findsOneWidget);
      expect(
        find.text('Tempat melengkapi anggota dan kebutuhan keluarga.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Kembali ke Beranda'));
      await tester.pumpAndSettle();
      expect(find.byType(HomePreviewSheet), findsNothing);
    },
  );

  for (final scenario in [
    (const Size(320, 640), 1.0),
    (const Size(390, 1097), 1.0),
    (const Size(1024, 768), 1.0),
    (const Size(320, 640), 2.0),
    (const Size(360, 800), 1.3),
    (const Size(390, 844), 2.0),
  ]) {
    testWidgets('No overflow at ${scenario.$1}, text scale ${scenario.$2}', (
      tester,
    ) async {
      await openHome(tester, size: scenario.$1, scale: scenario.$2);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Lapor Banjir Cepat'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Lapor Banjir Cepat'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Card status aligns to the trailing edge without wrapping', (
    tester,
  ) async {
    await openHome(tester);
    for (final status in ['3/3 Berkas Siaga', 'Sisa kuota: 1/2']) {
      final label = find.text(status);
      await tester.ensureVisible(label);
      await tester.pumpAndSettle();
      final action = find
          .byType(HomeFeatureAction)
          .at(status.startsWith('3/3') ? 0 : 1);
      expect(
        tester.getRect(label).right,
        closeTo(tester.getRect(action).right, 1),
      );
      expect(tester.getSize(label).height, lessThan(20));
    }
  });

  testWidgets('Small screens give feature descriptions room to read', (
    tester,
  ) async {
    await openHome(tester, size: const Size(320, 640));
    for (final badge in ['Checklist', 'Panduan']) {
      expect(tester.getSize(find.text(badge)).height, lessThan(16));
    }
    for (final description in [
      'Scan KK, KTP & berkas penting',
      'Kamera AI Vision deteksi ketinggian genangan',
    ]) {
      final text = find.text(description);
      await tester.ensureVisible(text);
      await tester.pumpAndSettle();
      expect(tester.getSize(text).width, greaterThan(200));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Visible controls have labels and Android touch targets', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await openHome(tester);
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await tester.ensureVisible(find.text('Lapor Banjir Cepat'));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    } finally {
      semantics.dispose();
    }
  });
}
