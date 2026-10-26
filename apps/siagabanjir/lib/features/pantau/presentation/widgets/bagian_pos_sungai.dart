import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

import '../models/data_pantau_wilayah.dart';

/// Bagian daftar Pos Pantau Sungai yang menampilkan status berbagai pos pengamatan.
class BagianPosSungai extends StatelessWidget {
  const BagianPosSungai({
    super.key,
    this.riverPosts = kDefaultRiverPosts,
    this.lastUpdatedText = '5 mnt lalu',
  });

  final List<PosSungai> riverPosts;
  final String lastUpdatedText;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Header bagian pos pantau
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8,
        runSpacing: 8,
        children: [
          const Text(
            'Pos Pantau Sungai',
            style: TextStyle(
              fontSize: SiagaTheme.judulBagian,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            lastUpdatedText,
            style: const TextStyle(
              fontSize: SiagaTheme.isi,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      // Daftar kartu pos sungai
      for (final post in riverPosts) ...[
        _KartuPosSungai(post: post),
        const SizedBox(height: 10),
      ],
    ],
  );
}

class _KartuPosSungai extends StatelessWidget {
  const _KartuPosSungai({required this.post});

  final PosSungai post;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Informasi pos dan lokasi
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                post.name,
                style: const TextStyle(
                  fontSize: SiagaTheme.judulBagian,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                post.postLocation,
                style: const TextStyle(
                  fontSize: SiagaTheme.keterangan,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Metrik angka ketinggian & badge status
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${post.waterLevelCm} cm',
                style: const TextStyle(
                  fontSize: SiagaTheme.judulBagian,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2.5,
                ),
                decoration: BoxDecoration(
                  color: post.status.badgeBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  post.displayStatus,
                  style: TextStyle(
                    fontSize: SiagaTheme.keterangan,
                    fontWeight: FontWeight.w700,
                    color: post.status.badgeForeground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
