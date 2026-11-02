import 'dart:convert';
import 'dart:typed_data';

import 'identitas_aksi.dart';
import 'klien_api.dart';

/// Akses envelope, versi dan identitas aksi bersama untuk repository fitur.
class LayananRepository {
  LayananRepository({KlienApi? klien}) : klien = klien ?? KlienApi();
  final KlienApi klien;
  Future<Map<String, dynamic>> baca(String path) async =>
      Map<String, dynamic>.from((await klien.get(path))['data'] as Map);
  Future<Map<String, dynamic>> ubah(
    String path,
    Map<String, dynamic> body, {
    String metode = 'POST',
    int? versi,
    String? identitas,
  }) async {
    final headers = {
      'Idempotency-Key': identitas ?? identitasAksi(),
      if (versi != null) 'If-Match': '"$versi"',
    };
    final dynamic res = switch (metode) {
      'PUT' => await klien.put(path, body: body, headers: headers),
      'PATCH' => await klien.patch(path, body: body, headers: headers),
      _ => await klien.post(path, body: body, headers: headers),
    };
    return Map<String, dynamic>.from(res['data'] as Map);
  }

  Future<Map<String, dynamic>> unggah(
    Uint8List bytes, {
    required String tujuan,
    String asal = 'FILE',
    String? id,
  }) async {
    final uploadId = id ?? identitasAksi();
    final boundary = 'siaga-$uploadId';
    final data = BytesBuilder();
    for (final field in {'purpose': tujuan, 'origin': asal}.entries) {
      data.add(
        utf8.encode(
          '--$boundary\r\nContent-Disposition: form-data; name="${field.key}"\r\n\r\n${field.value}\r\n',
        ),
      );
    }
    data.add(
      utf8.encode(
        '--$boundary\r\nContent-Disposition: form-data; name="file"; filename="bukti"\r\nContent-Type: application/octet-stream\r\n\r\n',
      ),
    );
    data.add(bytes);
    data.add(utf8.encode('\r\n--$boundary--\r\n'));
    final res = await klien.uploadBytes(
      '/api/v1/me/uploads/$uploadId',
      bytes: data.toBytes(),
      contentType: 'multipart/form-data; boundary=$boundary',
      headers: {'Idempotency-Key': uploadId},
    );
    return Map<String, dynamic>.from(res['data'] as Map);
  }
}
