import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/features/dokumen/data/layanan_berkas.dart';
import 'package:siagabanjir/features/dokumen/presentation/layar_dokumen_siaga.dart';
import 'package:siagabanjir/shared/theme/siaga_theme.dart';

class BerkasUji extends LayananBerkas {
  final dokumen = BerkasPilihan(
    'uji.pdf',
    Uint8List.fromList(utf8.encode('%PDF-1.7\ncontoh')),
  );
  Map<String, BerkasPilihan>? diekspor;
  @override
  Future<BerkasPilihan?> pilih() async => dokumen;
  @override
  Future<bool> ekspor(Map<String, BerkasPilihan> berkas) async {
    diekspor = berkas;
    return true;
  }
}

void main() {
  test('ZIP hanya memuat berkas pilihan dan mempertahankan isi', () {
    final file = BerkasUji().dokumen;
    final zip = LayananBerkas.buatZip({'doc_kk': file});
    final arsip = ZipDecoder().decodeBytes(zip);
    expect(arsip.files.single.name, 'doc_kk_uji.pdf');
    expect(arsip.files.single.content, file.bytes);
    expect(
      () => LayananBerkas.validasi(
        BerkasPilihan('palsu.pdf', Uint8List.fromList([1, 2, 3])),
      ),
      throwsStateError,
    );
    expect(() => LayananBerkas.buatZip({}), throwsStateError);
  });
  testWidgets(
    'Pilih berkas memperbarui kartu dan ekspor membutuhkan konfirmasi',
    (t) async {
      final layanan = BerkasUji();
      await t.pumpWidget(
        MaterialApp(
          theme: SiagaTheme.light,
          home: LayarDokumenSiaga(layananBerkas: layanan),
        ),
      );
      await t.tap(find.text('Ganti').first);
      await t.pumpAndSettle();
      await t.tap(find.text('Pilih Berkas'));
      await t.pumpAndSettle();
      expect(find.text('uji.pdf'), findsOneWidget);
      await t.ensureVisible(find.text('Unduh Semua Berkas untuk Dinas (ZIP)'));
      await t.tap(find.text('Unduh Semua Berkas untuk Dinas (ZIP)'));
      await t.pumpAndSettle();
      expect(layanan.diekspor, isNull);
      await t.tap(find.text('Ekspor ZIP'));
      await t.pumpAndSettle();
      expect(layanan.diekspor!.keys, ['doc_kk']);
      expect(layanan.diekspor!['doc_kk']!.bytes, layanan.dokumen.bytes);
    },
  );
}
