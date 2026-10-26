import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/documents/domain/family_document.dart';
import 'package:siagabanjir/features/documents/presentation/documents_vault_screen.dart';
import 'package:siagabanjir/shared/theme/siaga_theme.dart';

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

  Future<void> openDocumentsVault(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double scale = 1,
    VoidCallback? onHome,
    VoidCallback? onReport,
    VoidCallback? onHistory,
    VoidCallback? onProfile,
    VoidCallback? onSaveDocuments,
    VoidCallback? onDownloadZip,
    ValueChanged<FamilyDocument>? onChangeDocument,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        theme: SiagaTheme.light,
        home: DocumentsVaultScreen(
          onHome: onHome,
          onReport: onReport,
          onHistory: onHistory,
          onProfile: onProfile,
          onSaveDocuments: onSaveDocuments,
          onDownloadZip: onDownloadZip,
          onChangeDocument: onChangeDocument,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DocumentsVaultScreen displays all elements matching SVG design', (
    tester,
  ) async {
    await openDocumentsVault(tester);

    // Header bar & judul halaman
    expect(find.text('Dokumen Siaga'), findsOneWidget);
    expect(find.text('Dokumen Siaga Keluarga'), findsOneWidget);
    expect(
      find.text(
        'Simpan cadangan berkas kependudukan untuk pengurusan pasca-banjir.',
      ),
      findsOneWidget,
    );

    // Tiga berkas dokumen keluarga
    expect(find.text('1. Kartu Keluarga (KK)'), findsOneWidget);
    expect(find.text('scan_kk_asli_keluarga.pdf'), findsOneWidget);
    expect(find.text('PDF • 1.4 MB • Siap cetak dinas'), findsOneWidget);

    expect(find.text('2. KTP Kepala Keluarga / Pasangan'), findsOneWidget);
    expect(find.text('ktp_rahmad_hidayat.jpg'), findsOneWidget);
    expect(find.text('Gambar JPG • 840 KB • Siap cetak dinas'), findsOneWidget);

    expect(find.text('3. Akta Kelahiran Anak / Berkas Vital'), findsOneWidget);
    expect(find.text('akta_kelahiran_anak.pdf'), findsOneWidget);
    expect(find.text('PDF • 920 KB • Siap cetak dinas'), findsOneWidget);

    // Tiga badge format berkas & tiga tombol Ganti
    expect(find.text('Gambar / PDF'), findsNWidgets(3));
    expect(find.text('Ganti'), findsNWidgets(3));

    // Banner perlindungan berkas sipil
    expect(find.textContaining('Perlindungan Berkas Sipil:'), findsOneWidget);
    expect(
      find.textContaining('Berkas tersimpan terenkripsi pada perangkat Anda.'),
      findsOneWidget,
    );

    // Tombol aksi bawah
    expect(find.text('Simpan & Perbarui Dokumen Siaga'), findsOneWidget);
    expect(find.text('Unduh Semua Berkas untuk Dinas (ZIP)'), findsOneWidget);

    // Navigasi warga
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Lapor'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets(
    'Interactions on DocumentsVaultScreen trigger feedback and callbacks',
    (tester) async {
      FamilyDocument? changedDoc;
      var saveCalled = false;
      var downloadCalled = false;
      var reportCalled = false;
      var historyCalled = false;
      var profileCalled = false;
      var homeCalled = false;

      await openDocumentsVault(
        tester,
        onChangeDocument: (doc) => changedDoc = doc,
        onSaveDocuments: () => saveCalled = true,
        onDownloadZip: () => downloadCalled = true,
        onReport: () => reportCalled = true,
        onHistory: () => historyCalled = true,
        onProfile: () => profileCalled = true,
        onHome: () => homeCalled = true,
      );

      // 1. Ganti berkas KK
      await tester.tap(find.text('Ganti').first);
      await tester.pumpAndSettle();
      expect(changedDoc?.id, 'doc_kk');

      // 2. Simpan & Perbarui Dokumen Siaga
      await tester.ensureVisible(find.text('Simpan & Perbarui Dokumen Siaga'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Simpan & Perbarui Dokumen Siaga'));
      await tester.pumpAndSettle();
      expect(saveCalled, isTrue);
      expect(
        find.text('Dokumen siaga keluarga berhasil disimpan dan diperbarui.'),
        findsOneWidget,
      );

      // Sembunyikan snackbar sebelum tap tombol berikutnya
      ScaffoldMessenger.of(
        tester.element(find.byType(DocumentsVaultScreen)),
      ).hideCurrentSnackBar();
      await tester.pumpAndSettle();

      // 3. Unduh Semua Berkas untuk Dinas (ZIP)
      await tester.ensureVisible(
        find.text('Unduh Semua Berkas untuk Dinas (ZIP)'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unduh Semua Berkas untuk Dinas (ZIP)'));
      await tester.pumpAndSettle();
      expect(downloadCalled, isTrue);
      expect(
        find.text(
          'Menyiapkan paket berkas dinas (ZIP) untuk pengurusan Disdukcapil...',
        ),
        findsOneWidget,
      );

      // Sembunyikan snackbar sebelum navigasi
      ScaffoldMessenger.of(
        tester.element(find.byType(DocumentsVaultScreen)),
      ).hideCurrentSnackBar();
      await tester.pumpAndSettle();

      // 4. Navigasi Lapor, Riwayat, Profil, Beranda
      await tester.tap(find.text('Lapor'));
      await tester.pumpAndSettle();
      expect(reportCalled, isTrue);

      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle();
      expect(historyCalled, isTrue);

      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      expect(profileCalled, isTrue);

      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(homeCalled, isTrue);

      // 5. Tombol kembali di header
      await tester.tap(find.bySemanticsLabel('Kembali ke halaman sebelumnya'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'Tile Dokumen Siaga on HomeScreen opens DocumentsVaultScreen and returns home',
    (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SiagaBanjirApp());
    await tester.pumpAndSettle();

    // Verifikasi berada di Beranda
    expect(find.text('Dokumen Siaga'), findsOneWidget);

    // Tap kartu Dokumen Siaga Keluarga untuk membuka HomePreviewSheet
    await tester.ensureVisible(find.text('Dokumen Siaga Keluarga'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dokumen Siaga Keluarga'));
    await tester.pumpAndSettle();

    // Tap tombol Buka Dokumen Siaga Keluarga pada pratinjau untuk membuka DocumentsVaultScreen
    expect(find.text('Buka Dokumen Siaga Keluarga'), findsOneWidget);
    await tester.tap(find.text('Buka Dokumen Siaga Keluarga'));
    await tester.pumpAndSettle();

    // Memastikan layar DocumentsVaultScreen terbuka
    expect(find.text('1. Kartu Keluarga (KK)'), findsOneWidget);

    // Tap tombol kembali untuk kembali ke Beranda
    await tester.tap(find.bySemanticsLabel('Kembali ke halaman sebelumnya'));
    await tester.pumpAndSettle();

    // Memastikan kembali ke Beranda
    expect(find.text('Dokumen Siaga Keluarga'), findsOneWidget);
  });

  for (final scenario in [
    (const Size(320, 640), 1.0),
    (const Size(390, 844), 1.0),
    (const Size(390, 1008), 1.0), // Ukuran SVG asli
    (const Size(1024, 768), 1.0),
    (const Size(844, 390), 1.0), // Landscape
    (const Size(320, 640), 2.0), // Layar sempit + text scaling 2.0x
    (const Size(390, 844), 2.0), // Layar standar + text scaling 2.0x
  ]) {
    testWidgets(
      'No overflow on DocumentsVault at ${scenario.$1}, scale ${scenario.$2}',
      (tester) async {
        await openDocumentsVault(
          tester,
          size: scenario.$1,
          scale: scenario.$2,
        );
        expect(tester.takeException(), isNull);

        // Memastikan tombol paling bawah dapat dijangkau tanpa exception overflow
        await tester.ensureVisible(
          find.text('Unduh Semua Berkas untuk Dinas (ZIP)'),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
