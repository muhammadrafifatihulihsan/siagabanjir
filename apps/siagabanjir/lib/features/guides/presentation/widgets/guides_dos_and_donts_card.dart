import 'package:flutter/material.dart';

import '../../domain/guide_step.dart';

// Kartu petunjuk "Lakukan" (hijau) dan "Hindari" (merah) sesuai desain referensi guides_detail.svg.
class GuidesDosAndDontsCard extends StatelessWidget {
  const GuidesDosAndDontsCard({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final textScale = MediaQuery.textScalerOf(context).scale(1);
      final isNarrow = constraints.maxWidth / textScale < 280;
      final doCard = _buildCard(
        title: 'Lakukan',
        icon: Icons.check_circle_outline_rounded,
        accentColor: const Color(0xFF059669),
        backgroundColor: const Color(0xFFECFDF5),
        borderColor: const Color(0xFFA7F3D0),
        items: kGuideDoItems,
      );
      final dontCard = _buildCard(
        title: 'Hindari',
        icon: Icons.highlight_off_rounded,
        accentColor: const Color(0xFFDC2626),
        backgroundColor: const Color(0xFFFEF2F2),
        borderColor: const Color(0xFFFECACA),
        items: kGuideDontItems,
      );

      if (isNarrow) {
        return Column(
          children: [
            doCard,
            const SizedBox(height: 12),
            dontCard,
          ],
        );
      }

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: doCard),
            const SizedBox(width: 12),
            Expanded(child: dontCard),
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
                  fontSize: 14,
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12.5,
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
