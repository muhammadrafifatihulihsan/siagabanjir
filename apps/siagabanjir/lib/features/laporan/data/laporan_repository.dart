import 'dart:typed_data';

import '../../../core/jaringan/endpoint_api.dart';
import '../../../core/jaringan/klien_api.dart';
import '../domain/entri_riwayat_laporan.dart';

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
    if (json.containsKey('quota') && json['quota'] is Map) {
      final quota = json['quota'] as Map<String, dynamic>;
      final remaining = (quota['remaining'] as num?)?.toInt() ?? 0;
      final used = (quota['used'] as num?)?.toInt() ?? 0;
      return StatusKuotaLaporan(
        diizinkan: (json['ktpSatisfied'] == true || json['allowed'] == true) &&
            remaining > 0,
        sisaKuota: remaining,
        laporanAktif: used,
        alasan: json['reason'] as String?,
      );
    }
    return StatusKuotaLaporan(
      diizinkan: json['allowed'] as bool? ?? false,
      sisaKuota: (json['remainingQuota'] as num?)?.toInt() ?? 0,
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
      status:
          json['analysisState'] as String? ??
          json['state'] as String? ??
          json['status'] as String? ??
          'SUBMITTED',
      waktuBuat:
          DateTime.tryParse(json['acceptedAt'] as String? ?? json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      mediaId: json['mediaId'] as String?,
    );
  }

  EntriRiwayatLaporan toEntri() {
    return EntriRiwayatLaporan(
      waktu: waktuBuat,
      kategori: kategori,
      deskripsi: deskripsi,
      kebutuhan: const [],
      foto: null,
    );
  }
}

/// Repositori penghubung fitur Pelaporan Warga ke endpoint Fastify Backend.
class LaporanRepository {
  LaporanRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  Future<Map<String, dynamic>> statusPengiriman(String id) async {
    final res = await _klien.get(EndpointApi.meSubmission(id));
    final dynamic data = (res is Map && res['data'] is Map) ? res['data'] : res;
    return Map<String, dynamic>.from(data as Map);
  }

  /// Memeriksa status kuota dan kelayakan pelaporan warga via `GET /api/v1/me/reporting-status`.
  Future<StatusKuotaLaporan> periksaStatusKuota() async {
    final res = await _klien.get(EndpointApi.meReportingStatus);
    final data = res['data'] as Map<String, dynamic>? ?? (res is Map<String, dynamic> ? res : <String, dynamic>{});
    return StatusKuotaLaporan.fromJson(data);
  }

  /// Mengunggah berkas foto bukti laporan warga via `PUT /api/v1/me/uploads/{uploadId}`.
  Future<String> unggahFotoBukti({
    required String uploadId,
    required Uint8List bytes,
    String contentType = 'image/jpeg',
  }) async {
    final res = await _klien.uploadBytes(
      EndpointApi.meUpload(uploadId),
      bytes: bytes,
      contentType: contentType,
    );
    final data = res['data'] as Map<String, dynamic>? ?? (res is Map<String, dynamic> ? res : <String, dynamic>{});
    return data['mediaId'] as String? ?? data['id'] as String? ?? uploadId;
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
    String? waktuSinyal,
  }) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final effectiveMediaId = mediaId ?? submissionId;
    final payload = {
      'category': kategori,
      'needs': kebutuhan,
      'mediaId': effectiveMediaId,
      'uploadIds': [effectiveMediaId],
      'description':
          '$kategori\n$deskripsi${kebutuhan.isEmpty ? '' : '\nKebutuhan: ${kebutuhan.join(', ')}'}${alamat != null ? '\nLokasi: $alamat' : ''}',
      'point': {
        'latitude': latitude ?? -0.9471,
        'longitude': longitude ?? 100.4172,
        'source': 'GPS',
      },
      'occurredAt': waktuSinyal ?? nowIso,
      'deviceSignals': {
        'mockLocation': 'NOT_DETECTED',
        'developerMode': 'NOT_DETECTED',
        'observedAt': waktuSinyal ?? nowIso,
        'buildId': 'siagabanjir-1.0.0',
      },
    };

    final res = await _klien.put(
      EndpointApi.meSubmission(submissionId),
      body: payload,
      headers: {'Idempotency-Key': submissionId},
    );
    return res as Map<String, dynamic>;
  }

  /// Membaca riwayat laporan yang dikirimkan akun warga via `GET /api/v1/me/reports`.
  Future<List<ItemRiwayatLaporanServer>> ambilRiwayatLaporan() async {
    final res = await _klien.get(EndpointApi.meReports);
    final dynamic itemsData = (res is Map && res['data'] is Map)
        ? res['data']['items']
        : (res is Map ? res['items'] : null);
    final list = (itemsData as List<dynamic>? ?? []);
    return list
        .map(
          (e) => ItemRiwayatLaporanServer.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
