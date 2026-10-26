import 'package:flutter/material.dart';

import '../../domain/region_monitor_data.dart';

/// Kartu sorotan utama tinggi air sungai (contoh: Sungai Batang Kuranji).
/// Menampilkan nilai ketinggian air real-time, tren kenaikan, indikator segmen ambang batas,
/// dan peringatan batas luapan tanggul.
class MonitorFeaturedCard extends StatelessWidget {
  const MonitorFeaturedCard({
    super.key,
    this.featuredRiver = kDefaultFeaturedRiver,
  });

  final FeaturedRiverStatus featuredRiver;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baris judul sungai & badge status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                featuredRiver.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: featuredRiver.status.badgeBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                featuredRiver.statusLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: featuredRiver.status.badgeForeground,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Metrik angka ketinggian air & indikator kenaikan
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${featuredRiver.waterLevelCm}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'cm Tinggi Air',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              featuredRiver.formattedChange,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB45309),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Indikator segmen bar berwarna (Hijau, Kuning, Merah)
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Row(
              children: const [
                Expanded(
                  flex: 100,
                  child: ColoredBox(color: Color(0xFFA7F3D0)),
                ),
                Expanded(
                  flex: 50,
                  child: ColoredBox(color: Color(0xFFFCD34D)),
                ),
                Expanded(
                  flex: 50,
                  child: ColoredBox(color: Color(0xFFFCA5A5)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Rentang ambang batas
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 8,
          runSpacing: 4,
          children: const [
            Text(
              'Normal: 0–99 cm',
              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
            ),
            Text(
              'Waspada: 100–149 cm',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB45309),
              ),
            ),
            Text(
              'Bahaya: 150+ cm',
              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Banner batas luapan tanggul
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'Batas luapan tanggul: ${featuredRiver.spillLimitCm} cm',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D4ED8),
                ),
              ),
              Text(
                'Sisa ${featuredRiver.spillRemainingCm} cm',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB45309),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
