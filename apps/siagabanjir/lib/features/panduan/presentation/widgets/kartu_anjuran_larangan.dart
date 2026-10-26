import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

import '../../domain/langkah_panduan.dart';

// Kartu petunjuk "Wajib" (hijau) dan "Dilarang" (merah) persis sesuai desain referensi guides_detail.svg.
class KartuAnjuranLarangan extends StatelessWidget {
  const KartuAnjuranLarangan({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final textScale = MediaQuery.textScalerOf(context).scale(1);
      final isNarrow = constraints.maxWidth / textScale < 280;
      final wajibCard = _buildCard(
        title: 'Wajib',
        icon: Icons.check_circle_outline_rounded,
        accentColor: const Color(0xFF059669),
        backgroundColor: const Color(0xFFECFDF5),
        borderColor: const Color(0xFFA7F3D0),
        items: kGuideWajibItems,
      );
      final dilarangCard = _buildCard(
        title: 'Dilarang',
        icon: Icons.highlight_off_rounded,
        accentColor: const Color(0xFFDC2626),
        backgroundColor: const Color(0xFFFEF2F2),
        borderColor: const Color(0xFFFECACA),
        items: kGuideDilarangItems,
      );

      if (isNarrow) {
        return Column(
          children: [wajibCard, const SizedBox(height: 12), dilarangCard],
        );
      }

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: wajibCard),
            const SizedBox(width: 12),
            Expanded(child: dilarangCard),
          ],
        ),
      );
    },
  );

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required Color backgroundColor,
    required Color borderColor,
    required List<String> items,
  }) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: accentColor, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: SiagaTheme.isi,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final item in items) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    fontSize: SiagaTheme.isi,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: SiagaTheme.keterangan,
                      height: 1.35,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}
