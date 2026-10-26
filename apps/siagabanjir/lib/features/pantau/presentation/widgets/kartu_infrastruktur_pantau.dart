import 'package:flutter/material.dart';

import '../../../../shared/widgets/local_icon.dart';
import '../models/data_pantau_wilayah.dart';

/// Kartu status kesiapan operasional infrastruktur (Pompa & Pintu Air).
class KartuInfrastrukturPantau extends StatelessWidget {
  const KartuInfrastrukturPantau({
    super.key,
    this.items = kDefaultInfrastructureItems,
  });

  final List<ItemInfrastruktur> items;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul kartu dengan ikon tetesan air
        Row(
          children: const [
            LocalIcon('water', size: 20, color: Color(0xFF2563EB)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Status Pompa & Pintu Air',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Daftar item status pompa dan pintu air
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  items[i].title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                Text(
                  items[i].status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: items[i].highlightColor,
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
