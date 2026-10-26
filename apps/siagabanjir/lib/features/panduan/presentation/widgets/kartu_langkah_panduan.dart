import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/langkah_panduan.dart';

// Kartu tahapan evakuasi mandiri dengan nomor urut, judul, dan uraian langkah persis sesuai SVG.
class KartuLangkahPanduan extends StatelessWidget {
  const KartuLangkahPanduan({
    super.key,
    required this.step,
    required this.isExpanded,
    required this.onToggle,
  });

  final LangkahPanduan step;
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
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                    borderRadius: BorderRadius.circular(8),
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
                  size: 20,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Text(
                  step.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
