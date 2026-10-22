import 'package:app/app/siaga_banjir_app.dart';
import 'package:app/features/home/presentation/home_preview_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  testWidgets('Home labels mock data and bundles every image locally', (
    tester,
  ) async {
    await openHome(tester);
    expect(find.text('SiagaBanjir'), findsOneWidget);
    expect(find.text('Data contoh'), findsOneWidget);
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
        'Lapor Banjir Cepat',
        'Lapor',
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
    'Notifications and complete access sheet have working destinations',
    (tester) async {
      await openHome(tester);
      await tester.tap(find.byTooltip('Notifikasi'));
      await tester.pumpAndSettle();
      expect(find.text('Contoh pembaruan wilayah'), findsOneWidget);
      await tester.tap(find.byTooltip('Tutup pratinjau'));
      await tester.pumpAndSettle();
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

  testWidgets('Visible controls have labels and Android touch targets', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await openHome(tester);
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    } finally {
      semantics.dispose();
    }
  });
}
