import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../sesi/pengelola_sesi.dart';
import 'konfigurasi_api.dart';
import 'pengecualian_api.dart';

/// Klien HTTP bersama untuk berkomunikasi dengan Fastify Backend SiagaBanjir.
class KlienApi {
  KlienApi({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? KonfigurasiApi.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Uri _bangunUri(String path, [Map<String, dynamic>? queryParams]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final urlString = '$_baseUrl$cleanPath';
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
      final res = await _client
          .get(_bangunUri(path, query), headers: _bangunHeaders(headers))
          .timeout(KonfigurasiApi.batasWaktu);
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
    final res = await _client
        .get(_bangunUri(path), headers: _bangunHeaders({'Accept': '*/*'}))
        .timeout(KonfigurasiApi.batasWaktu);
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
      final res = await _client
          .post(
            _bangunUri(path),
            headers: _bangunHeaders(headers),
            body: payload ?? '{}',
          )
          .timeout(KonfigurasiApi.batasWaktu);
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
      final res = await _client
          .put(
            _bangunUri(path),
            headers: _bangunHeaders(headers),
            body: payload ?? '{}',
          )
          .timeout(KonfigurasiApi.batasWaktu);
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
      final res = await _client
          .patch(
            _bangunUri(path),
            headers: _bangunHeaders(headers),
            body: payload ?? '{}',
          )
          .timeout(KonfigurasiApi.batasWaktu);
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
      final res = await _client
          .delete(_bangunUri(path), headers: _bangunHeaders(headers))
          .timeout(KonfigurasiApi.batasWaktu);
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
      final res = await _client
          .put(_bangunUri(path), headers: allHeaders, body: bytes)
          .timeout(const Duration(seconds: 30));
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
