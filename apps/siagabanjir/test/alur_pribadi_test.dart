import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siagabanjir/app/siaga_banjir_app.dart';
import 'package:siagabanjir/core/perangkat/layanan_foto.dart';
import 'package:siagabanjir/features/akun/presentation/layar_profil.dart';
import 'package:siagabanjir/features/akun/presentation/widgets/kartu_header_profil.dart';
import 'package:siagabanjir/features/dokumen/data/layanan_berkas.dart';
import 'package:siagabanjir/features/dokumen/presentation/layar_dokumen_siaga.dart';
import 'package:siagabanjir/shared/theme/siaga_theme.dart';

import 'features/dokumen/berkas_lokal_test.dart' show BerkasUji;

class GaleriUji extends LayananFoto {
  final foto = FotoPilihan(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=',
    ),
    'uji.png',
  );
  int galeriDipanggil = 0;
  @override
  Future<FotoPilihan?> galeri() async {
    galeriDipanggil++;
    return foto;
  }
}

void main() {
  testWidgets(
    'Foto galeri hanya diterapkan setelah Simpan; Batal menjaga avatar',
    (t) async {
      final layanan = GaleriUji();
      await t.pumpWidget(
        MaterialApp(
          theme: SiagaTheme.light,
          home: LayarProfil(
            layananFoto: layanan,
            onOpen: (_) {},
            onHome: () {},
          ),
        ),
      );
      await t.tap(find.text('Edit Profil'));
      await t.pumpAndSettle();
      await t.tap(find.text('Galeri'));
      await t.pumpAndSettle();
      expect(layanan.galeriDipanggil, 1);
      await t.tap(find.text('Batal'));
      await t.pumpAndSettle();
      expect(
        t.widget<KartuHeaderProfil>(find.byType(KartuHeaderProfil)).foto,
        isNull,
      );
      await t.tap(find.text('Edit Profil'));
      await t.pumpAndSettle();
      await t.tap(find.text('Galeri'));
      await t.pumpAndSettle();
      await t.tap(find.text('Simpan Perubahan'));
      await t.pumpAndSettle();
      expect(
        t.widget<KartuHeaderProfil>(find.byType(KartuHeaderProfil)).foto,
        layanan.foto.bytes,
      );
    },
  );

  testWidgets(
    'Kontak pribadi bertahan saat buka ulang, dapat diedit dan dihapus dengan konfirmasi',
    (t) async {
      await t.pumpWidget(const SiagaBanjirApp());
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Kontak Darurat'));
      await t.tap(find.text('Kontak Darurat'));
      await t.pumpAndSettle();
      await t.tap(find.text('+ Tambah'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextFormField).at(0), 'Kontak Penguji');
      await t.enterText(find.byType(TextFormField).at(1), 'Keluarga');
      await t.enterText(find.byType(TextFormField).at(2), '081234567890');
      await t.tap(find.text('Simpan Kontak'));
      await t.pumpAndSettle();
      await t.tap(find.bySemanticsLabel('Kembali'));
      await t.pumpAndSettle();
      await t.tap(find.text('Kontak Darurat'));
      await t.pumpAndSettle();
      expect(find.text('Kontak Penguji'), findsOneWidget);
      await t.tap(find.byIcon(Icons.more_horiz));
      await t.pumpAndSettle();
      await t.tap(find.text('Edit'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextFormField).first, 'Nama Diperbarui');
      await t.tap(find.text('Simpan Kontak'));
      await t.pumpAndSettle();
      expect(find.text('Nama Diperbarui'), findsOneWidget);
      await t.tap(find.byIcon(Icons.more_horiz));
      await t.pumpAndSettle();
      await t.tap(find.text('Hapus'));
      await t.pumpAndSettle();
      await t.tap(find.text('Batal'));
      await t.pumpAndSettle();
      expect(find.text('Nama Diperbarui'), findsOneWidget);
      await t.tap(find.byIcon(Icons.more_horiz));
      await t.pumpAndSettle();
      await t.tap(find.text('Hapus'));
      await t.pumpAndSettle();
      await t.tap(find.text('Hapus Kontak'));
      await t.pumpAndSettle();
      expect(find.text('Nama Diperbarui'), findsNothing);
    },
  );

  testWidgets(
    'Dokumen lainnya memakai nama tanpa spasi dan batal tidak menambah berkas',
    (t) async {
      final dokumen = ValueNotifier<List<DokumenSesi>>([]);
      addTearDown(dokumen.dispose);
      await t.pumpWidget(
        MaterialApp(
          theme: SiagaTheme.light,
          home: LayarDokumenSiaga(dokumen: dokumen, layananBerkas: BerkasUji()),
        ),
      );
      await t.tap(find.text('Tambah Dokumen'));
      await t.pumpAndSettle();
      await t.tap(find.text('Pilih PDF / Gambar'));
      await t.pumpAndSettle();
      await t.tap(find.byType(DropdownButtonFormField<String>));
      await t.pumpAndSettle();
      await t.tap(find.text('Lainnya').last);
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextFormField), 'pajak kendaraan');
      await t.tap(find.widgetWithText(FilledButton, 'Simpan Dokumen'));
      await t.pumpAndSettle();
      expect(dokumen.value.single.berkas.nama, 'pajakkendaraan.pdf');
      expect(find.textContaining('berhasil ditambahkan'), findsOneWidget);
      expect(
        () => LayananBerkas.validasi(dokumen.value.single.berkas),
        returnsNormally,
      );
      await t.pump(const Duration(seconds: 4));
      await t.tap(find.text('Tambah Dokumen'));
      await t.pumpAndSettle();
      await t.tap(find.text('Pilih PDF / Gambar'));
      await t.pumpAndSettle();
      await t.tap(find.text('Batal'));
      await t.pumpAndSettle();
      expect(dokumen.value, hasLength(1));
    },
  );
}
