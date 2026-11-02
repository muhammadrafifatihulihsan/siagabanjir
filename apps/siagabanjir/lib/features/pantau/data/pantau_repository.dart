import '../../../core/jaringan/endpoint_api.dart';
import '../../../core/jaringan/klien_api.dart';

/// Item pantau wilayah publik yang diterima dari endpoint Fastify Backend.
class ItemPantauPublik {
  const ItemPantauPublik({
    required this.id,
    required this.namaLokasi,
    required this.tingkat,
    required this.waktuPembaruan,
    required this.statusReview,
    this.jumlahLaporan = 0,
    this.ringkasan,
    this.ringkasanAi,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String namaLokasi;
  final String tingkat;
  final DateTime waktuPembaruan;
  final String statusReview;
  final int jumlahLaporan;

  /// Kesimpulan agregasi deterministik dari backend.
  final String? ringkasan;

  /// Narasi AI best-effort; null bila job ringkasan belum selesai.
  final String? ringkasanAi;
  final double? latitude;
  final double? longitude;

  bool get punyaKoordinat => latitude != null && longitude != null;

  factory ItemPantauPublik.fromJson(Map<String, dynamic> json) {
    double? koordinat(Object? value, double batas) {
      if (value is num) {
        final angka = value.toDouble();
        return angka.abs() <= batas ? angka : null;
      }
      return null;
    }

    return ItemPantauPublik(
      id: json['id'] as String? ?? '',
      namaLokasi: json['locationName'] as String? ?? 'Lokasi Kejadian',
      tingkat: json['level'] as String? ?? 'UNRATED',
      waktuPembaruan:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      statusReview: json['reviewState'] as String? ?? 'REVIEWED',
      jumlahLaporan: (json['reportCount'] as num?)?.toInt() ?? 0,
      ringkasan: json['summary'] as String?,
      ringkasanAi: json['aiSummary'] as String?,
      latitude: koordinat(json['latitude'], 90),
      longitude: koordinat(json['longitude'], 180),
    );
  }
}

/// Hasil query daftar pantau publik dari backend.
class HasilPantauPublik {
  const HasilPantauPublik({
    required this.items,
    this.nextCursor,
    required this.serverTime,
  });

  final List<ItemPantauPublik> items;
  final String? nextCursor;
  final DateTime serverTime;
}

/// Repositori penghubung fitur Pantau Wilayah ke endpoint `/api/v1/public/monitor`.
class PantauRepository {
  PantauRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  /// Membaca ringkasan pantau publik dari `GET /api/v1/public/monitor`.
  Future<HasilPantauPublik> ambilRingkasanPantau({
    String? query,
    String? section,
    String? cursor,
  }) async {
    final queryParams = <String, dynamic>{
      if (query != null && query.isNotEmpty) 'q': query,
      if (section != null && section.isNotEmpty) 'section': section,
      if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
    };

    final res = await _klien.get(EndpointApi.monitorPublik, query: queryParams);
    final dynamic itemsData = (res is Map && res['data'] is Map)
        ? res['data']['items']
        : (res is Map ? res['items'] : null);
    final list = (itemsData as List<dynamic>? ?? []);
    final items = list
        .map((e) => ItemPantauPublik.fromJson(e as Map<String, dynamic>))
        .toList();

    final dynamic nextCursorData = (res is Map && res['data'] is Map)
        ? res['data']['nextCursor']
        : (res is Map ? res['nextCursor'] : null);

    final dynamic serverTimeData = (res is Map && res['data'] is Map)
        ? res['data']['serverTime']
        : (res is Map ? res['serverTime'] : null);

    return HasilPantauPublik(
      items: items,
      nextCursor: nextCursorData as String?,
      serverTime:
          DateTime.tryParse(serverTimeData as String? ?? '') ?? DateTime.now(),
    );
  }

  /// Membaca manifest konten edukasi publik dari `GET /api/v1/public/content/manifest`.
  Future<Map<String, dynamic>> ambilManifestKonten() async {
    final res = await _klien.get(EndpointApi.contentManifest);
    return res as Map<String, dynamic>;
  }
}
