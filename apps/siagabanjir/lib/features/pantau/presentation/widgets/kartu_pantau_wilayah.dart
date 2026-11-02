import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../data/pantau_repository.dart';

/// Warna dan label tingkat keparahan klaster dari backend.
({Color background, Color foreground, String label}) gayaTingkat(
  String tingkat,
) {
  switch (tingkat) {
    case 'HIGH':
      return (
        background: const Color(0xFFFEE2E2),
        foreground: const Color(0xFF991B1B),
        label: 'TINGGI',
      );
    case 'MEDIUM':
      return (
        background: const Color(0xFFFEF3C7),
        foreground: const Color(0xFFB45309),
        label: 'SEDANG',
      );
    case 'LOW':
      return (
        background: const Color(0xFFDCFCE7),
        foreground: const Color(0xFF166534),
        label: 'RENDAH',
      );
    default:
      return (
        background: const Color(0xFFE2E8F0),
        foreground: const Color(0xFF334155),
        label: 'BELUM DINILAI',
      );
  }
}

/// Jarak waktu ringkas berbahasa Indonesia untuk umpan pemantauan.
String labelWaktuRelatif(DateTime waktu, {DateTime? sekarang}) {
  final selisih = (sekarang ?? DateTime.now()).difference(waktu);
  if (selisih.inSeconds < 60) return 'baru saja';
  if (selisih.inMinutes < 60) return '${selisih.inMinutes} mnt lalu';
  if (selisih.inHours < 24) return '${selisih.inHours} jam lalu';
  return '${selisih.inDays} hari lalu';
}

/// Kartu satu klaster wilayah pada umpan peringatan Pantau Wilayah.
class KartuPantauWilayah extends StatelessWidget {
  const KartuPantauWilayah({
    super.key,
    required this.item,
    this.onBukaPeta,
    this.sekarang,
  });

  final ItemPantauPublik item;
  final VoidCallback? onBukaPeta;
  final DateTime? sekarang;

  @override
  Widget build(BuildContext context) {
    final gaya = gayaTingkat(item.tingkat);
    final ringkasanAi = item.ringkasanAi?.trim();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.namaLokasi,
                  style: const TextStyle(
                    fontSize: SiagaTheme.judulBagian,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: gaya.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  gaya.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: gaya.foreground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${item.jumlahLaporan} laporan · ${labelWaktuRelatif(item.waktuPembaruan, sekarang: sekarang)}'
            '${item.statusReview == 'NEEDS_REVIEW' ? ' · perlu tinjauan petugas' : ''}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          if (item.ringkasan != null && item.ringkasan!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              item.ringkasan!,
              style: const TextStyle(
                fontSize: SiagaTheme.isi,
                height: 1.4,
                color: Color(0xFF334155),
              ),
            ),
          ],
          if (ringkasanAi != null && ringkasanAi.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kesimpulan AI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ringkasanAi,
                    style: const TextStyle(
                      fontSize: SiagaTheme.isi,
                      height: 1.4,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (item.punyaKoordinat && onBukaPeta != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onBukaPeta,
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text('Buka di Google Maps'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
