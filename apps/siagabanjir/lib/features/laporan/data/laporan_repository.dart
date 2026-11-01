import 'dart:typed_data';

import '../../../core/jaringan/klien_api.dart';

/// Status kelayakan dan kuota pelaporan warga dari server.
class StatusKuotaLaporan {
  const StatusKuotaLaporan({
    required this.diizinkan,
    required this.sisaKuota,
    required this.laporanAktif,
    this.alasan,
  });

  final bool diizinkan;
  final int sisaKuota;
  final int laporanAktif;
  final String? alasan;

  factory StatusKuotaLaporan.fromJson(Map<String, dynamic> json) {
    return StatusKuotaLaporan(
      diizinkan: json['allowed'] as bool? ?? true,
      sisaKuota: (json['remainingQuota'] as num?)?.toInt() ?? 3,
      laporanAktif: (json['activeReports'] as num?)?.toInt() ?? 0,
      alasan: json['reason'] as String?,
    );
  }
}

/// Item riwayat laporan warga yang tersimpan di server backend.
class ItemRiwayatLaporanServer {
  const ItemRiwayatLaporanServer({
    required this.id,
    required this.kategori,
    required this.deskripsi,
    required this.status,
    required this.waktuBuat,
    this.mediaId,
  });

  final String id;
  final String kategori;
  final String deskripsi;
  final String status;
  final DateTime waktuBuat;
  final String? mediaId;

  factory ItemRiwayatLaporanServer.fromJson(Map<String, dynamic> json) {
    return ItemRiwayatLaporanServer(
      id: json['id'] as String? ?? '',
      kategori: json['category'] as String? ?? 'Banjir',
      deskripsi: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'SUBMITTED',
      waktuBuat: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      mediaId: json['mediaId'] as String?,
    );
  }
}

/// Repositori penghubung fitur Pelaporan Warga ke endpoint Fastify Backend.
class LaporanRepository {
  LaporanRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  /// Memeriksa status kuota dan kelayakan pelaporan warga via `GET /api/v1/me/reporting-status`.
  Future<StatusKuotaLaporan> periksaStatusKuota() async {
    final res = await _klien.get('/api/v1/me/reporting-status');
    final data = res['data'] as Map<String, dynamic>? ?? res;
    return StatusKuotaLaporan.fromJson(data);
  }

  /// Mengunggah berkas foto bukti laporan warga via `PUT /api/v1/me/uploads/{uploadId}`.
  Future<String> unggahFotoBukti({
    required String uploadId,
    required Uint8List bytes,
    String contentType = 'image/jpeg',
  }) async {
    final res = await _klien.uploadBytes(
      '/api/v1/me/uploads/$uploadId',
      bytes: bytes,
      contentType: contentType,
    );
    final data = res['data'] as Map<String, dynamic>? ?? res;
    return data['mediaId'] as String? ?? uploadId;
  }

  /// Mengirim laporan warga ke server via `PUT /api/v1/me/submissions/{submissionId}`.
  Future<Map<String, dynamic>> kirimLaporan({
    required String submissionId,
    required String kategori,
    required String deskripsi,
    List<String> kebutuhan = const [],
    String? mediaId,
    double? latitude,
    double? longitude,
    String? alamat,
  }) async {
    final payload = {
      'category': kategori,
      'description': deskripsi,
      'needs': kebutuhan,
      'mediaId': ?mediaId,
      if (latitude != null && longitude != null)
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'address': ?alamat,
        },
    };

    final res = await _klien.put(
      '/api/v1/me/submissions/$submissionId',
      body: payload,
    );
    return res as Map<String, dynamic>;
  }

  /// Membaca riwayat laporan yang dikirimkan akun warga via `GET /api/v1/me/reports`.
  Future<List<ItemRiwayatLaporanServer>> ambilRiwayatLaporan() async {
    final res = await _klien.get('/api/v1/me/reports');
    final list = (res['items'] as List<dynamic>? ?? []);
    return list
        .map((e) => ItemRiwayatLaporanServer.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
