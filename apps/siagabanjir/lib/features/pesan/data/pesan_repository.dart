import 'package:flutter/material.dart';

import '../../../core/jaringan/endpoint_api.dart';
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
    // Backend mengirim item inbox berbentuk `{message: {...}, read: bool}`.
    // Bentuk datar tetap didukung agar kompatibel dengan data lama.
    final pesan = json['message'] as Map<String, dynamic>? ?? json;
    final sudahDibaca =
        json['read'] as bool? ?? pesan['read'] as bool? ?? false;
    final waktuTerbit = pesan['publishedAt'] as String? ??
        pesan['createdAt'] as String? ??
        '';

    return ItemPesanInbox(
      id: pesan['id'] as String? ?? '',
      judul: pesan['title'] as String? ?? 'Peringatan Siaga',
      isi: pesan['body'] as String? ?? '',
      tingkat: pesan['severity'] as String? ?? 'INFO',
      sudahDibaca: sudahDibaca,
      waktuBuat:
          DateTime.tryParse(waktuTerbit)?.toLocal() ?? DateTime.now(),
    );
  }

  PesanSiaga toPesanSiaga() {
    final isCritical = tingkat == 'CRITICAL';
    final isWarning = tingkat == 'WARNING';
    final jamMenit =
        '${waktuBuat.hour.toString().padLeft(2, '0')}:${waktuBuat.minute.toString().padLeft(2, '0')} WIB';

    return PesanSiaga(
      id: id,
      category: isCritical
          ? KategoriPesan.emergency
          : (isWarning ? KategoriPesan.weather : KategoriPesan.all),
      badgeLabel: isCritical
          ? 'Bahaya (Siaga 1)'
          : (isWarning ? 'Waspada (Siaga 2)' : 'Informasi'),
      badgeBackground: isCritical
          ? const Color(0xFFFEE2E2)
          : (isWarning ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9)),
      badgeTextColor: isCritical
          ? const Color(0xFFDC2626)
          : (isWarning ? const Color(0xFFD97706) : const Color(0xFF475569)),
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
    final res = await _klien.get(EndpointApi.meInbox);
    final dynamic itemsData = (res is Map && res['data'] is Map)
        ? res['data']['items']
        : (res is Map ? res['items'] : null);
    final list = (itemsData as List<dynamic>? ?? []);
    return list
        .map((e) => ItemPesanInbox.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Menandai pesan telah dibaca warga via `PUT /api/v1/me/inbox/{messageId}/read`.
  Future<void> tandaiDibaca(String messageId, {int versi = 1}) async {
    final payload = {'contentVersion': versi};
    await _klien.put(EndpointApi.meInboxRead(messageId), body: payload);
  }
}
