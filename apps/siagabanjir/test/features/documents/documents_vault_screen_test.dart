import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/features/documents/domain/document_entry.dart';
import 'package:siagabanjir/features/documents/presentation/documents_vault_screen.dart';

Future<void> _loadTestFonts() async {
  final fonts = FontLoader('Inter');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    fonts.addFont(rootBundle.load('assets/fonts/inter/Inter-$weight.otf'));
  }
  await fonts.load();
}

Future<void> _openDocumentsVault(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const SiagaBanjirApp());
  await tester.pumpAndSettle();

  // Ketuk kartu fitur Dokumen Siaga Keluarga pada beranda.
  final docTarget = find.text('Dokumen Siaga Keluarga');
  await tester.ensureVisible(docTarget);
  await tester.pumpAndSettle();
  await tester.tap(docTarget);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadTestFonts);

  testWidgets(
    'Documents feature card opens DocumentsVaultScreen matching exact SVG design elements',
    (tester) async {
      await _openDocumentsVault(tester);
      expect(find.byType(DocumentsVaultScreen), findsOneWidget);
      expect(find.text('Dokumen Siaga'), findsOneWidget);

      // Verifikasi kartu ringkasan dokumen siaga keluarga persis sesuai SVG
      expect(find.text('Dokumen Siaga Keluarga'), findsOneWidget);
      expect(
        find.text('Simpan dokumen berharga ke dalam kantong kedap air'),
        findsOneWidget,
      );
      expect(find.text('3 dari 3 Berkas Tersimpan'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('Siap Darurat'), findsOneWidget);

      // Verifikasi 3 dokumen siaga persis sesuai SVG
      for (final doc in kDefaultDocumentEntries) {
        final docFile = find.text(doc.fileName);
        await tester.ensureVisible(docFile);
        await tester.pumpAndSettle();
        expect(docFile, findsOneWidget);

        final categoryTitle = find.text('${doc.categoryNumber}. ${doc.categoryTitle}');
        expect(categoryTitle, findsOneWidget);

        expect(
          find.text('${doc.format.label} • ${doc.fileSize} • ${doc.updateStatus}'),
          findsOneWidget,
        );
      }

      // Verifikasi badge Vital pada dokumen KTP
      expect(find.text('Vital'), findsWidgets);

      // Verifikasi banner panduan keamanan dokumen
      final bannerTitle = find.text('Panduan Keamanan Dokumen');
      await tester.ensureVisible(bannerTitle);
      await tester.pumpAndSettle();
      expect(bannerTitle, findsOneWidget);

      for (final guideline in kDocumentSecurityGuidelines) {
        final guidelineFinder = find.text(guideline);
        await tester.ensureVisible(guidelineFinder);
        await tester.pumpAndSettle();
        expect(guidelineFinder, findsOneWidget);
      }

      // Verifikasi dua tombol aksi utama
      final saveButton = find.text('Simpan & Enkripsi Dokumen Siaga');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      expect(saveButton, findsOneWidget);

      final zipButton = find.text('Unduh Semua Berkas Digital (ZIP)');
      await tester.ensureVisible(zipButton);
      await tester.pumpAndSettle();
      expect(zipButton, findsOneWidget);

      // Ketuk tombol kembali untuk kembali ke beranda
      final backButton = find.bySemanticsLabel('Kembali');
      await tester.ensureVisible(backButton);
      await tester.pumpAndSettle();
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(DocumentsVaultScreen), findsNothing);
    },
  );

  testWidgets(
    'Interactive actions: Ganti berkas, Simpan Enkripsi, dan Unduh ZIP memberikan respon UI',
    (tester) async {
      await _openDocumentsVault(tester);

      // 1. Ketuk tombol Ganti pada kartu pertama
      final gantiButton = find.text('Ganti').first;
      await tester.ensureVisible(gantiButton);
      await tester.pumpAndSettle();
      await tester.tap(gantiButton);
      await tester.pumpAndSettle();

      expect(find.text('Ganti Kartu Keluarga (KK)'), findsOneWidget);
      expect(find.text('Pilih Berkas'), findsOneWidget);

      await tester.tap(find.text('Pilih Berkas'));
      await tester.pumpAndSettle();
      expect(
        find.text('Berkas Kartu Keluarga (KK) berhasil diperbarui.'),
        findsOneWidget,
      );

      // 2. Ketuk tombol Simpan & Enkripsi Dokumen Siaga
      final saveButton = find.text('Simpan & Enkripsi Dokumen Siaga');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Seluruh dokumen siaga telah diamankan & dienkripsi secara lokal.'),
        findsOneWidget,
      );

      // 3. Ketuk tombol Unduh Semua Berkas Digital (ZIP)
      final zipButton = find.text('Unduh Semua Berkas Digital (ZIP)');
      await tester.ensureVisible(zipButton);
      await tester.pumpAndSettle();
      await tester.tap(zipButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Mengunduh arsip berkas digital terenkripsi (ZIP)...'),
        findsOneWidget,
      );
    },
  );
}
