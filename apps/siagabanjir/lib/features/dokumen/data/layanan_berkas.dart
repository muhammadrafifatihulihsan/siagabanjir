import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_saver/file_saver.dart';
import 'package:file_selector/file_selector.dart';

class BerkasPilihan {
  const BerkasPilihan(this.nama, this.bytes);
  final String nama;
  final Uint8List bytes;
  String get ekstensi => nama.split('.').last.toLowerCase();
  String get ukuran => '${(bytes.length / 1024).ceil()} KB';
}

/// Berkas hanya berada di memori sampai pengguna mengekspornya sendiri.
class LayananBerkas {
  static String namaDokumen(String nama) => nama
      .trim()
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');

  Future<BerkasPilihan?> pilih() async {
    final file = await openFile(
      acceptedTypeGroups: [
        const XTypeGroup(
          label: 'PDF atau gambar',
          extensions: ['pdf', 'jpg', 'jpeg', 'png'],
          mimeTypes: ['application/pdf', 'image/jpeg', 'image/png'],
        ),
      ],
    );
    if (file == null) return null;
    if (await file.length() > 5 * 1024 * 1024) {
      throw StateError('Maksimal 5 MB per berkas.');
    }
    final berkas = BerkasPilihan(file.name, await file.readAsBytes());
    validasi(berkas);
    return berkas;
  }

  static void validasi(BerkasPilihan file) {
    final b = file.bytes;
    final pdf = b.length >= 5 && String.fromCharCodes(b.take(5)) == '%PDF-';
    final png =
        b.length >= 8 && b[0] == 137 && b[1] == 80 && b[2] == 78 && b[3] == 71;
    final jpg = b.length >= 3 && b[0] == 255 && b[1] == 216 && b[2] == 255;
    if (b.isEmpty ||
        b.length > 5 * 1024 * 1024 ||
        !(file.ekstensi == 'pdf' && pdf ||
            file.ekstensi == 'png' && png ||
            ['jpg', 'jpeg'].contains(file.ekstensi) && jpg)) {
      throw StateError('Gunakan PDF, JPG, atau PNG yang valid, maksimal 5 MB.');
    }
  }

  static Uint8List buatZip(Map<String, BerkasPilihan> berkas) {
    if (berkas.isEmpty) {
      throw StateError('Pilih minimal satu berkas terlebih dahulu.');
    }
    final arsip = Archive();
    for (final entri in berkas.entries) {
      validasi(entri.value);
      final nama = entri.value.nama.split(RegExp(r'[/\\]')).last;
      arsip.addFile(
        ArchiveFile(
          '${entri.key}_$nama',
          entri.value.bytes.length,
          entri.value.bytes,
        ),
      );
    }
    return Uint8List.fromList(ZipEncoder().encode(arsip));
  }

  Future<bool> ekspor(Map<String, BerkasPilihan> berkas) async {
    final hasil = await FileSaver.instance.saveAs(
      name: 'dokumen_siaga',
      bytes: buatZip(berkas),
      fileExtension: 'zip',
      mimeType: MimeType.zip,
    );
    return hasil != null;
  }
}
