import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/guide_step.dart';

// Kartu tahapan evakuasi mandiri dengan nomor urut, judul, dan detail yang dapat dibuka/tutup.
class GuidesStepCard extends StatelessWidget {
  const GuidesStepCard({
    super.key,
    required this.step,
    required this.isExpanded,
    required this.onToggle,
  });

  final GuideStep step;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: SiagaTheme.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${step.number}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: SiagaTheme.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: SiagaTheme.ink,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: SiagaTheme.muted,
                  size: 22,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: SiagaTheme.border),
              const SizedBox(height: 10),
              Text(
                step.summary,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              for (final item in step.instructions) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 8),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: SiagaTheme.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    ),
  );
}
