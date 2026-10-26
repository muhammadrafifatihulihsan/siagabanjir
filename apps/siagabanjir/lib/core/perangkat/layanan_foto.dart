import 'package:flutter/foundation.dart';

import 'package:image_picker/image_picker.dart';

class FotoPilihan {
  const FotoPilihan(this.bytes, this.nama);
  final Uint8List bytes;
  final String nama;
}

/// Kamera sistem; foto hanya berada di memori/cache, tidak dikirim ke server.
class LayananFoto {
  LayananFoto({ImagePicker? picker}) : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;

  Future<FotoPilihan?> ambil() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
      requestFullMetadata: false,
    );
    if (file == null) return null;
    return _baca(file);
  }

  Future<FotoPilihan?> pulihkan() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;
    final hasil = await _picker.retrieveLostData();
    if (hasil.isEmpty) return null;
    if (hasil.exception != null) throw hasil.exception!;
    final files = hasil.files;
    if (files == null || files.isEmpty) return null;
    return _baca(files.first);
  }

  Future<FotoPilihan> _baca(XFile file) async {
    if (await file.length() > 5 * 1024 * 1024) {
      throw StateError('Foto melebihi 5 MB.');
    }
    final bytes = await file.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw StateError(
        'Ukuran foto melebihi 5 MB. Ambil ulang dengan resolusi lebih kecil.',
      );
    }
    return FotoPilihan(bytes, file.name);
  }
}
