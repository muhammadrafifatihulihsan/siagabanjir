import '../../../core/jaringan/klien_api.dart';

/// Item pantau wilayah publik yang diterima dari endpoint Fastify Backend.
class ItemPantauPublik {
  const ItemPantauPublik({
    required this.namaLokasi,
    required this.tingkat,
    required this.waktuPembaruan,
    required this.statusReview,
  });

  final String namaLokasi;
  final String tingkat;
  final DateTime waktuPembaruan;
  final String statusReview;

  factory ItemPantauPublik.fromJson(Map<String, dynamic> json) {
    return ItemPantauPublik(
      namaLokasi: json['locationName'] as String? ?? 'Lokasi Kejadian',
      tingkat: json['level'] as String? ?? 'UNRATED',
      waktuPembaruan: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      statusReview: json['reviewState'] as String? ?? 'REVIEWED',
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

    final res = await _klien.get('/api/v1/public/monitor', query: queryParams);
    final list = (res['items'] as List<dynamic>? ?? []);
    final items = list
        .map((e) => ItemPantauPublik.fromJson(e as Map<String, dynamic>))
        .toList();

    return HasilPantauPublik(
      items: items,
      nextCursor: res['nextCursor'] as String?,
      serverTime: DateTime.tryParse(res['serverTime'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Membaca manifest konten edukasi publik dari `GET /api/v1/public/content/manifest`.
  Future<Map<String, dynamic>> ambilManifestKonten() async {
    final res = await _klien.get('/api/v1/public/content/manifest');
    return res as Map<String, dynamic>;
  }
}
