import '../../../core/jaringan/klien_api.dart';

/// Data hasil pemeriksaan kesehatan server dan basis data.
class StatusKesehatanSistem {
  const StatusKesehatanSistem({
    required this.sehat,
    required this.statusServer,
    required this.nodeVersion,
    required this.statusDatabase,
    required this.latencyDbMs,
    required this.migrasiDiterapkan,
  });

  final bool sehat;
  final String statusServer;
  final String nodeVersion;
  final String statusDatabase;
  final double latencyDbMs;
  final int migrasiDiterapkan;

  factory StatusKesehatanSistem.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final server = data['server'] as Map<String, dynamic>? ?? {};
    final db = data['database'] as Map<String, dynamic>? ?? {};
    final mig = data['migrations'] as Map<String, dynamic>? ?? {};

    return StatusKesehatanSistem(
      sehat: data['status'] == 'healthy',
      statusServer: server['status'] as String? ?? 'DOWN',
      nodeVersion: server['nodeVersion'] as String? ?? '',
      statusDatabase: db['status'] as String? ?? 'DOWN',
      latencyDbMs: (db['latencyMs'] as num?)?.toDouble() ?? 0.0,
      migrasiDiterapkan: (mig['appliedCount'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Repositori penghubung pemeriksaan kesehatan sistem dan metadata Fastify.
class MetaRepository {
  MetaRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  /// Memeriksa status kesehatan server dan konektivitas MySQL via `GET /health`.
  Future<StatusKesehatanSistem> periksaKesehatan() async {
    final res = await _klien.get('/health');
    return StatusKesehatanSistem.fromJson(res as Map<String, dynamic>);
  }

  /// Membaca metadata resmi layanan Fastify via `GET /api/v1/meta`.
  Future<Map<String, dynamic>> ambilMetadata() async {
    final res = await _klien.get('/api/v1/meta');
    return res as Map<String, dynamic>;
  }
}
