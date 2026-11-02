import 'dart:convert';
import 'dart:typed_data';

import '../../../core/jaringan/endpoint_api.dart';
import '../../../core/jaringan/klien_api.dart';
import '../../../core/jaringan/pengecualian_api.dart';
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
    final deskripsiMentah = (json['description'] as String? ?? '').trim();
    final baris = deskripsiMentah.split('\n');
    // Deskripsi dikirim sebagai "Kategori\nDeskripsi..." agar riwayat dapat
    // memisahkan kategori tanpa field tambahan pada kontrak.
    final kategoriMentah = baris.length > 1 ? baris.first.trim() : '';
    final deskripsiBersih = baris.length > 1
        ? baris.skip(1).join('\n').trim()
        : deskripsiMentah;

    return ItemRiwayatLaporanServer(
      id: json['id'] as String? ?? '',
      kategori: kategoriMentah.isEmpty ? 'Laporan Warga' : kategoriMentah,
      deskripsi: deskripsiBersih.isEmpty ? deskripsiMentah : deskripsiBersih,
      status:
          json['analysisState'] as String? ??
          json['state'] as String? ??
          json['status'] as String? ??
          'SUBMITTED',
      waktuBuat:
          DateTime.tryParse(
            json['acceptedAt'] as String? ??
                json['createdAt'] as String? ??
                '',
          ) ??
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
  ///
  /// Backend menerima `multipart/form-data` dengan field `purpose`/`origin`
  /// serta berkas pada field `file`. `purpose=REPORT` menolak `origin=FILE`,
  /// sehingga unggahan laporan memakai `CAMERA` secara default.
  Future<String> unggahFotoBukti({
    required String uploadId,
    required Uint8List bytes,
    String contentType = 'image/jpeg',
    String asal = 'CAMERA',
  }) async {
    final boundary = 'siaga-$uploadId';
    final data = BytesBuilder();
    for (final field in {'purpose': 'REPORT', 'origin': asal}.entries) {
      data.add(
        utf8.encode(
          '--$boundary\r\nContent-Disposition: form-data; name="${field.key}"\r\n\r\n${field.value}\r\n',
        ),
      );
    }
    data.add(
      utf8.encode(
        '--$boundary\r\nContent-Disposition: form-data; name="file"; filename="bukti.jpg"\r\nContent-Type: $contentType\r\n\r\n',
      ),
    );
    data.add(bytes);
    data.add(utf8.encode('\r\n--$boundary--\r\n'));

    final res = await _klien.uploadBytes(
      EndpointApi.meUpload(uploadId),
      bytes: data.toBytes(),
      contentType: 'multipart/form-data; boundary=$boundary',
      headers: {'Idempotency-Key': uploadId},
    );
    final dataRes =
        res['data'] as Map<String, dynamic>? ??
        (res is Map<String, dynamic> ? res : <String, dynamic>{});
    return dataRes['id'] as String? ?? uploadId;
  }

  /// Mengirim laporan warga ke server via `PUT /api/v1/me/submissions/{submissionId}`.
  ///
  /// Payload mengikuti kontrak `SubmissionInput`: `uploadIds`, `description`,
  /// `point`, `occurredAt` dan `deviceSignals` saja.
  Future<Map<String, dynamic>> kirimLaporan({
    required String submissionId,
    required String kategori,
    required String deskripsi,
    List<String> kebutuhan = const [],
    List<String> uploadIds = const [],
    double? latitude,
    double? longitude,
    String? alamat,
    String? waktuSinyal,
  }) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final bagian = <String>[kategori, deskripsi];
    if (kebutuhan.isNotEmpty) {
      bagian.add('Kebutuhan: ${kebutuhan.join(', ')}');
    }
    if (alamat != null && alamat.trim().isNotEmpty) {
      bagian.add('Lokasi: ${alamat.trim()}');
    }
    var description = bagian.join('\n').trim();
    if (description.length > 2000) {
      description = description.substring(0, 2000);
    }

    if (latitude == null || longitude == null) {
      throw const PengecualianApi(
        pesan:
            'Titik GPS belum tersedia. Tekan Perbarui Lokasi sebelum mengirim laporan.',
      );
    }

    final payload = {
      'uploadIds': uploadIds,
      'description': description,
      'point': {
        'latitude': latitude,
        'longitude': longitude,
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
          (e) => e as Map<String, dynamic>,
        )
        .where((item) => item['state'] != 'DELETED')
        .map((item) => ItemRiwayatLaporanServer.fromJson(item))
        .toList();
  }
}
