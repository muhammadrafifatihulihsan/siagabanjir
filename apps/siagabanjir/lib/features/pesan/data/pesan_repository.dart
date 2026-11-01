import 'package:flutter/material.dart';

import '../../../core/jaringan/klien_api.dart';
import '../presentation/models/pesan_siaga.dart';

/// Item pesan siaga yang diterima dari endpoint inbox backend.
class ItemPesanInbox {
  const ItemPesanInbox({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tingkat,
    required this.sudahDibaca,
    required this.waktuBuat,
  });

  final String id;
  final String judul;
  final String isi;
  final String tingkat;
  final bool sudahDibaca;
  final DateTime waktuBuat;

  factory ItemPesanInbox.fromJson(Map<String, dynamic> json) {
    return ItemPesanInbox(
      id: json['id'] as String? ?? '',
      judul: json['title'] as String? ?? 'Peringatan Siaga',
      isi: json['body'] as String? ?? '',
      tingkat: json['severity'] as String? ?? 'INFO',
      sudahDibaca: json['isRead'] as bool? ?? false,
      waktuBuat: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  PesanSiaga toPesanSiaga() {
    final isCritical = tingkat == 'CRITICAL';
    final isWarning = tingkat == 'WARNING';
    final jamMenit =
        '${waktuBuat.hour.toString().padLeft(2, '0')}:${waktuBuat.minute.toString().padLeft(2, '0')} WIB';

    return PesanSiaga(
      id: id,
      category: isCritical || isWarning
          ? KategoriPesan.emergency
          : KategoriPesan.weather,
      badgeLabel: isCritical
          ? 'Bahaya (Siaga 1)'
          : (isWarning ? 'Waspada (Siaga 2)' : 'Informasi'),
      badgeBackground: isCritical
          ? const Color(0xFFFEE2E2)
          : const Color(0xFFFEF3C7),
      badgeTextColor: isCritical
          ? const Color(0xFFDC2626)
          : const Color(0xFFD97706),
      timestamp: jamMenit,
      agency: 'Pusdalops BPBD Padang',
      title: judul,
      body: isi,
      isNew: !sudahDibaca,
    );
  }
}

/// Repositori penghubung fitur Pesan Siaga & Kotak Masuk ke endpoint Fastify Backend.
class PesanRepository {
  PesanRepository({KlienApi? klien}) : _klien = klien ?? KlienApi();

  final KlienApi _klien;

  /// Membaca daftar pesan masuk akun warga via `GET /api/v1/me/inbox`.
  Future<List<ItemPesanInbox>> ambilKotakMasuk() async {
    final res = await _klien.get('/api/v1/me/inbox');
    final list = (res['items'] as List<dynamic>? ?? []);
    return list
        .map((e) => ItemPesanInbox.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Menandai pesan telah dibaca warga via `PUT /api/v1/me/inbox/{messageId}/read`.
  Future<void> tandaiDibaca(String messageId, {int versi = 1}) async {
    final payload = {'version': versi};
    await _klien.put('/api/v1/me/inbox/$messageId/read', body: payload);
  }
}
