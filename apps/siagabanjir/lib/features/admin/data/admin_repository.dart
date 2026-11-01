import '../../../core/jaringan/klien_api.dart';

/// Item laporan warga yang dikelola oleh admin dari server.
class LaporanAdminServer {
  const LaporanAdminServer({
    required this.id,
    required this.namaPelapor,
    required this.kategori,
    required this.deskripsi,
    required this.status,
    required this.waktu,
    this.idKlaster,
    this.mediaId,
  });

  final String id;
  final String namaPelapor;
  final String kategori;
  final String deskripsi;
  final String status;
  final DateTime waktu;
  final String? idKlaster;
  final String? mediaId;

  factory LaporanAdminServer.fromJson(Map<String, dynamic> json) {
    return LaporanAdminServer(
      id: json['id'] as String? ?? '',
      namaPelapor: json['reporterName'] as String? ?? 'Warga Pelapor',
      kategori: json['category'] as String? ?? 'Banjir',
      deskripsi: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'SUBMITTED',
      waktu: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      idKlaster: json['groupId'] as String?,
      mediaId: json['mediaId'] as String?,
    );
  }
}

/// Klaster kelompok kejadian banjir dari server.
class KlasterAdminServer {
  const KlasterAdminServer({
    required this.id,
    required this.namaLokasi,
    required this.tingkat,
    required this.status,
    required this.jumlahLaporan,
  });

  final String id;
  final String namaLokasi;
  final String tingkat;
  final String status;
  final int jumlahLaporan;

  factory KlasterAdminServer.fromJson(Map<String, dynamic> json) {
    return KlasterAdminServer(
      id: json['id'] as String? ?? '',
      namaLokasi: json['locationLabel'] as String? ?? 'Wilayah Insiden',
      tingkat: json['level'] as String? ?? 'MEDIUM',
      status: json['state'] as String? ?? 'ACTIVE',
      jumlahLaporan: (json['reportCount'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Repositori penghubung Portal Admin Web ke endpoint Fastify Backend.
class AdminRepository {
  AdminRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  /// Membaca daftar seluruh laporan masuk untuk ditinjau via `GET /api/v1/admin/reports`.
  Future<List<LaporanAdminServer>> ambilDaftarLaporan({
    String? status,
    String? groupId,
    String? query,
  }) async {
    final queryParams = <String, dynamic>{
      'status': ?status,
      'groupId': ?groupId,
      'q': ?query,
    };

    final res = await _klien.get('/api/v1/admin/reports', query: queryParams);
    final list = (res['items'] as List<dynamic>? ?? []);
    return list
        .map((e) => LaporanAdminServer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Membaca daftar klaster kelompok kejadian via `GET /api/v1/admin/groups`.
  Future<List<KlasterAdminServer>> ambilKlasterWilayah() async {
    final res = await _klien.get('/api/v1/admin/groups');
    final list = (res['items'] as List<dynamic>? ?? []);
    return list
        .map((e) => KlasterAdminServer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Menerbitkan pesan siaran peringatan banjir baru via `POST /api/v1/admin/messages`.
  Future<Map<String, dynamic>> terbitkanPesanSiaga({
    required String judul,
    required String isi,
    required String tingkat, // 'CRITICAL' | 'WARNING' | 'INFO'
    String? idempotencyKey,
  }) async {
    final payload = {
      'title': judul,
      'body': isi,
      'severity': tingkat,
    };

    final headers = <String, String>{
      'Idempotency-Key': ?idempotencyKey,
    };

    final res = await _klien.post(
      '/api/v1/admin/messages',
      body: payload,
      headers: headers,
    );
    return res as Map<String, dynamic>;
  }

  /// Mencatat tinjauan versi laporan warga via `PUT /api/v1/admin/reports/{reportId}/review`.
  Future<void> tinjauLaporan(String reportId, {required int version}) async {
    final payload = {'version': version};
    await _klien.put('/api/v1/admin/reports/$reportId/review', body: payload);
  }
}
