import '../../../core/jaringan/endpoint_api.dart';
import '../../../core/jaringan/identitas_aksi.dart';
import '../../../core/jaringan/klien_api.dart';
import '../presentation/models/entri_kontak.dart';

/// Satu kontak direktori dari CMS (publik maupun admin).
class ItemKontakServer {
  const ItemKontakServer({
    required this.id,
    required this.version,
    required this.nama,
    required this.deskripsi,
    required this.telepon,
    this.state = 'PUBLISHED',
  });

  final String id;
  final int version;
  final String nama;
  final String deskripsi;
  final String telepon;
  final String state;

  factory ItemKontakServer.fromJson(Map<String, dynamic> json) {
    final draft = json['draft'] as Map<String, dynamic>?;
    final published = json['published'] as Map<String, dynamic>?;
    final sumber = published ?? draft ?? json;
    return ItemKontakServer(
      id: json['id'] as String? ?? '',
      version: (json['version'] as num?)?.toInt() ?? 1,
      nama: sumber['name'] as String? ?? '',
      deskripsi: sumber['description'] as String? ?? '',
      telepon: sumber['phone'] as String? ?? '',
      state: json['state'] as String? ?? 'PUBLISHED',
    );
  }

  EntriKontak toEntri() => entriKontakDariKonten(
    nama: nama,
    deskripsi: deskripsi,
    telepon: telepon,
  );
}

/// Repositori direktori kontak darurat berbasis CMS.
///
/// Warga membaca konten terbit (`/public/content/{revision}/contacts`),
/// sedangkan admin membuat draf lalu menerbitkannya sehingga tambah/hapus
/// kontak benar-benar tersimpan pada database, bukan hanya di memori.
class KontakRepository {
  KontakRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  static const _jenis = 'contacts';

  Future<List<ItemKontakServer>> ambilKontakPublik() async {
    final revision = await _revisiTerbit();
    final res = await _klien.get(EndpointApi.contentSection('$revision', _jenis));
    return _bacaItems(res);
  }

  Future<List<ItemKontakServer>> ambilKontakAdmin() async {
    final res = await _klien.get(EndpointApi.adminContent(_jenis));
    return _bacaItems(res);
  }

  /// Membuat draf kontak baru lalu langsung menerbitkannya.
  Future<ItemKontakServer?> tambahDanTerbitkan({
    required String nama,
    required String telepon,
    String deskripsi = '',
  }) async {
    final dibuat = await _klien.post(
      EndpointApi.adminContent(_jenis),
      body: {
        'name': nama,
        'description': deskripsi,
        'phone': telepon,
        'source': {
          'label': 'Input admin posko',
          'url': null,
          'checkedAt': DateTime.now().toUtc().toIso8601String(),
          'state': 'EXAMPLE',
        },
      },
      headers: {'Idempotency-Key': identitasAksi()},
    );
    final data = _dataDari(dibuat);
    final id = data['id'] as String?;
    final versi = (data['version'] as num?)?.toInt();
    if (id == null || versi == null) return null;

    final terbit = await _klien.post(
      EndpointApi.adminContentPublish(_jenis, id),
      headers: {
        'Idempotency-Key': identitasAksi(),
        'If-Match': '"$versi"',
      },
    );
    final terbitData = _dataDari(terbit);
    return ItemKontakServer(
      id: id,
      version: (terbitData['version'] as num?)?.toInt() ?? versi + 1,
      nama: nama,
      deskripsi: deskripsi,
      telepon: telepon,
    );
  }

  /// Menarik lalu menghapus kontak agar konten terbit tidak tertinggal.
  Future<void> hapusKontak(String id) async {
    final items = await ambilKontakAdmin();
    ItemKontakServer? target;
    for (final item in items) {
      if (item.id == id) target = item;
    }
    if (target == null) return;

    var versi = target.version;
    if (target.state == 'PUBLISHED') {
      final tarik = await _klien.post(
        EndpointApi.adminContentWithdraw(_jenis, id),
        headers: {
          'Idempotency-Key': identitasAksi(),
          'If-Match': '"$versi"',
        },
      );
      versi = (_dataDari(tarik)['version'] as num?)?.toInt() ?? versi + 1;
    }
    await _klien.delete(
      EndpointApi.adminContentItem(_jenis, id),
      headers: {
        'If-Match': '"$versi"',
        'Idempotency-Key': identitasAksi(),
      },
    );
  }

  Future<int> _revisiTerbit() async {
    try {
      final res = await _klien.get(EndpointApi.contentManifest);
      final revisi = (_dataDari(res)['revision'] as num?)?.toInt();
      return revisi == null || revisi < 1 ? 1 : revisi;
    } catch (_) {
      return 1;
    }
  }

  Map<String, dynamic> _dataDari(dynamic res) => res is Map<String, dynamic>
      ? (res['data'] as Map<String, dynamic>? ?? res)
      : <String, dynamic>{};

  List<ItemKontakServer> _bacaItems(dynamic res) {
    final data = _dataDari(res);
    final items = data['items'] as List<dynamic>? ?? const [];
    return items
        .map((e) => ItemKontakServer.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
