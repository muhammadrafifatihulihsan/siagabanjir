import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../sesi/pengelola_sesi.dart';
import 'konfigurasi_api.dart';
import 'pengecualian_api.dart';

/// Klien HTTP bersama untuk berkomunikasi dengan Fastify Backend SiagaBanjir.
class KlienApi {
  KlienApi({http.Client? client, this._baseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String? _baseUrl;

  Uri _bangunUri(
    String path, [
    Map<String, dynamic>? queryParams,
    String? baseUrlOverride,
  ]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final targetBase = baseUrlOverride ?? _baseUrl ?? KonfigurasiApi.baseUrl;
    final urlString = '$targetBase$cleanPath';
    final uri = Uri.parse(urlString);
    if (queryParams == null || queryParams.isEmpty) return uri;

    final stringParams = queryParams.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    return uri.replace(queryParameters: stringParams);
  }

  Map<String, String> _bangunHeaders([Map<String, String>? headersTambahan]) {
    final token = PengelolaSesi.instance.tokenSesi;
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      ...?headersTambahan,
    };
  }

  bool _adalahMasalahKoneksi(Object error) {
    if (error is TimeoutException) return true;
    final nama = error.runtimeType.toString();
    if (nama.contains('SocketException') ||
        nama.contains('ClientException') ||
        nama.contains('HttpException')) {
      return true;
    }
    final pesan = error.toString().toLowerCase();
    return pesan.contains('failed host lookup') ||
        pesan.contains('connection refused') ||
        pesan.contains('network is unreachable') ||
        pesan.contains('clientexception') ||
        pesan.contains('xmlhttprequest error');
  }

  Future<http.Response> _eksekusiDenganFallback(
    Future<http.Response> Function(String base) aksi,
  ) async {
    final hostUtama = _baseUrl ?? KonfigurasiApi.baseUrl;
    final hostLokal = KonfigurasiApi.defaultLocalUrl;

    // Jika baseUrl diset manual di luar default remote (misal test mock), langsung panggil
    if (_baseUrl != null && _baseUrl != KonfigurasiApi.defaultRemoteUrl) {
      return await aksi(_baseUrl);
    }
    if (hostUtama == hostLokal) {
      return await aksi(hostUtama);
    }

    try {
      return await aksi(hostUtama);
    } catch (e) {
      if (_adalahMasalahKoneksi(e)) {
        KonfigurasiApi.setBaseUrl(hostLokal);
        return await aksi(hostLokal);
      }
      rethrow;
    }
  }

  dynamic _prosesRespons(http.Response res) {
    dynamic body;
    if (res.body.isNotEmpty) {
      try {
        body = jsonDecode(utf8.decode(res.bodyBytes));
      } catch (_) {
        body = res.body;
      }
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body;
    }

    String pesanError = 'Terjadi kesalahan komunikasi (${res.statusCode})';
    String? kodeError;
    if (body is Map<String, dynamic>) {
      pesanError = (body['message'] ?? body['error'] ?? pesanError).toString();
      kodeError = body['code']?.toString();
    }

    throw PengecualianApi(
      pesan: pesanError,
      kodeStatus: res.statusCode,
      kodeError: kodeError,
      rincian: body,
    );
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final generasi = PengelolaSesi.instance.generasi;
    try {
      final res = await _eksekusiDenganFallback((base) {
        return _client
            .get(
              _bangunUri(path, query, base),
              headers: _bangunHeaders(headers),
            )
            .timeout(KonfigurasiApi.batasWaktu);
      });
      if (generasi != PengelolaSesi.instance.generasi) {
        throw const PengecualianApi(
          pesan: 'Sesi telah berubah. Silakan muat ulang.',
        );
      }
      return _prosesRespons(res);
    } on TimeoutException {
      throw const PengecualianApi(pesan: 'Batas waktu koneksi habis.');
    }
  }

  Future<Uint8List> unduh(String path) async {
    final generasi = PengelolaSesi.instance.generasi;
    final res = await _eksekusiDenganFallback((base) {
      return _client
          .get(
            _bangunUri(path, null, base),
            headers: _bangunHeaders({'Accept': '*/*'}),
          )
          .timeout(KonfigurasiApi.batasWaktu);
    });
    if (generasi != PengelolaSesi.instance.generasi) {
      throw const PengecualianApi(pesan: 'Sesi telah berubah.');
    }
    if (res.statusCode < 200 || res.statusCode >= 300) _prosesRespons(res);
    return res.bodyBytes;
  }

  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final generasi = PengelolaSesi.instance.generasi;
    try {
      final payload = body != null ? jsonEncode(body) : null;
      final res = await _eksekusiDenganFallback((base) {
        return _client
            .post(
              _bangunUri(path, null, base),
              headers: _bangunHeaders(headers),
              body: payload ?? '{}',
            )
            .timeout(KonfigurasiApi.batasWaktu);
      });
      if (generasi != PengelolaSesi.instance.generasi) {
        throw const PengecualianApi(
          pesan: 'Sesi telah berubah. Silakan muat ulang.',
        );
      }
      return _prosesRespons(res);
    } on TimeoutException {
      throw const PengecualianApi(pesan: 'Batas waktu koneksi habis.');
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final generasi = PengelolaSesi.instance.generasi;
    try {
      final payload = body != null ? jsonEncode(body) : null;
      final res = await _eksekusiDenganFallback((base) {
        return _client
            .put(
              _bangunUri(path, null, base),
              headers: _bangunHeaders(headers),
              body: payload ?? '{}',
            )
            .timeout(KonfigurasiApi.batasWaktu);
      });
      if (generasi != PengelolaSesi.instance.generasi) {
        throw const PengecualianApi(
          pesan: 'Sesi telah berubah. Silakan muat ulang.',
        );
      }
      return _prosesRespons(res);
    } on TimeoutException {
      throw const PengecualianApi(pesan: 'Batas waktu koneksi habis.');
    }
  }

  Future<dynamic> patch(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final generasi = PengelolaSesi.instance.generasi;
    try {
      final payload = body != null ? jsonEncode(body) : null;
      final res = await _eksekusiDenganFallback((base) {
        return _client
            .patch(
              _bangunUri(path, null, base),
              headers: _bangunHeaders(headers),
              body: payload ?? '{}',
            )
            .timeout(KonfigurasiApi.batasWaktu);
      });
      if (generasi != PengelolaSesi.instance.generasi) {
        throw const PengecualianApi(
          pesan: 'Sesi telah berubah. Silakan muat ulang.',
        );
      }
      return _prosesRespons(res);
    } on TimeoutException {
      throw const PengecualianApi(pesan: 'Batas waktu koneksi habis.');
    }
  }

  Future<dynamic> delete(String path, {Map<String, String>? headers}) async {
    final generasi = PengelolaSesi.instance.generasi;
    try {
      // DELETE tanpa body tidak boleh mengirim Content-Type JSON: Fastify
      // menolaknya sebagai body JSON kosong yang tidak valid (HTTP 400),
      // sehingga penghapusan kontak/dokumen selalu gagal.
      final headerAksi = _bangunHeaders(headers)..remove('Content-Type');
      final res = await _eksekusiDenganFallback((base) {
        return _client
            .delete(_bangunUri(path, null, base), headers: headerAksi)
            .timeout(KonfigurasiApi.batasWaktu);
      });
      if (generasi != PengelolaSesi.instance.generasi) {
        throw const PengecualianApi(
          pesan: 'Sesi telah berubah. Silakan muat ulang.',
        );
      }
      return _prosesRespons(res);
    } on TimeoutException {
      throw const PengecualianApi(pesan: 'Batas waktu koneksi habis.');
    }
  }

  Future<dynamic> uploadBytes(
    String path, {
    required Uint8List bytes,
    required String contentType,
    Map<String, String>? headers,
  }) async {
    final generasi = PengelolaSesi.instance.generasi;
    try {
      final allHeaders = _bangunHeaders({
        'Content-Type': contentType,
        ...?headers,
      });
      final res = await _eksekusiDenganFallback((base) {
        return _client
            .put(_bangunUri(path, null, base), headers: allHeaders, body: bytes)
            .timeout(const Duration(seconds: 30));
      });
      if (generasi != PengelolaSesi.instance.generasi) {
        throw const PengecualianApi(
          pesan: 'Sesi telah berubah. Silakan muat ulang.',
        );
      }
      return _prosesRespons(res);
    } on TimeoutException {
      throw const PengecualianApi(pesan: 'Batas waktu unggah berkas habis.');
    }
  }
}
