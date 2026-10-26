import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Kartu ringkasan kesiapan logistik keluarga dengan persentase dan progress bar.
class EmergencyBagSummaryCard extends StatelessWidget {
  const EmergencyBagSummaryCard({
    super.key,
    required this.checkedCount,
    required this.totalCount,
  });

  final int checkedCount;
  final int totalCount;

  int get _percentage =>
      totalCount == 0 ? 0 : ((checkedCount * 100) ~/ totalCount);

  double get _progress => totalCount == 0 ? 0.0 : (checkedCount / totalCount);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFDBEAFE)),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                'Kesiapan Logistik Keluarga',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: SiagaTheme.blue,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_percentage%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: SiagaTheme.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '$checkedCount dari $totalCount Barang',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: SiagaTheme.ink,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: _progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(SiagaTheme.blue),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Perlengkapan cukup untuk bertahan hidup mandiri 3 hari saat evakuasi.',
          style: TextStyle(
            fontSize: 13,
            height: 1.35,
            color: SiagaTheme.muted,
          ),
        ),
      ],
    ),
  );
}
