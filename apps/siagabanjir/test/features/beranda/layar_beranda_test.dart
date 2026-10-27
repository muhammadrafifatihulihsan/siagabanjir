import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/kontak/presentation/layar_direktori_kontak.dart';
import 'package:siagabanjir/features/dokumen/presentation/layar_dokumen_siaga.dart';
import 'package:siagabanjir/features/tas_siaga/presentation/layar_tas_siaga.dart';
import 'package:siagabanjir/features/panduan/presentation/layar_detail_panduan.dart';
import 'package:siagabanjir/features/beranda/presentation/panel_akses_fitur.dart';
import 'package:siagabanjir/features/beranda/presentation/widgets/aksi_fitur_beranda.dart';
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

  testWidgets('Fitur utama langsung terbuka dan kembali ke beranda', (
    tester,
  ) async {
    await openHome(tester);
    for (final label in [
      'Pantau Status',
      'Pantau Wilayah',
      'Riwayat',
      'Profil',
    ]) {
      final target = find.text(label);
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle();
      expect(find.byType(PanelAksesFitur), findsNothing, reason: label);
      await tester.tap(find.text('Beranda').last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: label);
    }
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Sungai Batang Kuranji')).dy,
      lessThan(250),
    );
  });

  testWidgets(
    'Kontak Darurat quick access opens LayarDirektoriKontak and returns home',
    (tester) async {
      await openHome(tester);
      final contactsTarget = find.text('Kontak Darurat');
      await tester.ensureVisible(contactsTarget);
      await tester.pumpAndSettle();
      await tester.tap(contactsTarget);
      await tester.pumpAndSettle();

      expect(find.byType(LayarDirektoriKontak), findsOneWidget);
      expect(find.text('Kontak Darurat'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();
      expect(find.byType(LayarDirektoriKontak), findsNothing);
    },
  );

  testWidgets('Tas Siaga quick access opens LayarTasSiaga and returns home', (
    tester,
  ) async {
    await openHome(tester);
    final bagTarget = find.text('Tas Siaga');
    await tester.ensureVisible(bagTarget);
    await tester.pumpAndSettle();
    await tester.tap(bagTarget);
    await tester.pumpAndSettle();

    expect(find.byType(LayarTasSiaga), findsOneWidget);
    expect(find.text('Tas Siaga Bencana'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Kembali'));
    await tester.pumpAndSettle();
    expect(find.byType(LayarTasSiaga), findsNothing);
  });

  testWidgets(
    'Panduan Selamat quick access opens LayarDetailPanduan and returns home',
    (tester) async {
      await openHome(tester);
      final guidesTarget = find.text('Panduan Selamat');
      await tester.ensureVisible(guidesTarget);
      await tester.pumpAndSettle();
      await tester.tap(guidesTarget);
      await tester.pumpAndSettle();

      expect(find.byType(LayarDetailPanduan), findsOneWidget);
      expect(find.text('Panduan Selamat'), findsWidgets);

      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();
      expect(find.byType(LayarDetailPanduan), findsNothing);
    },
  );

  testWidgets(
    'Dokumen Siaga Keluarga feature card opens LayarDokumenSiaga and returns home',
    (tester) async {
      await openHome(tester);
      final docTarget = find.text('Dokumen Siaga Keluarga');
      await tester.ensureVisible(docTarget);
      await tester.pumpAndSettle();
      await tester.tap(docTarget);
      await tester.pumpAndSettle();

      expect(find.byType(LayarDokumenSiaga), findsOneWidget);
      expect(find.text('Dokumen Siaga'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Kembali'));
      await tester.pumpAndSettle();
      expect(find.byType(LayarDokumenSiaga), findsNothing);
    },
  );

  testWidgets(
    'Notifications opens LayarKotakMasuk and complete access sheet works',
    (tester) async {
      await openHome(tester);

      // Ketuk tombol notifikasi → harus membuka LayarKotakMasuk.
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
      expect(find.text('Tambah Anggota'), findsOneWidget);
      await tester.tap(find.text('Beranda').last);
      await tester.pumpAndSettle();
      expect(find.byType(PanelAksesFitur), findsNothing);
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
          .byType(AksiFiturBeranda)
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
