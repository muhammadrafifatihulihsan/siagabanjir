import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../home_action.dart';
import 'home_icon.dart';

class HomeFeatureCard extends StatelessWidget {
  const HomeFeatureCard({super.key, required this.action, required this.onTap});

  final HomeAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final documents = action == HomeAction.documents;
    final accent = documents
        ? const Color(0xFF047857)
        : const Color(0xFF4338CA);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: SiagaTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: documents
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: documents
                          ? const Color(0xFFA7F3D0)
                          : const Color(0xFFC7D2FE),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeIcon(
                        documents ? 'document_badge' : 'ai_badge',
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          documents ? 'Dokumen Siaga' : 'AI Vision',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  documents ? '3/3 Berkas Siaga' : 'Sisa kuota: 1/2',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: SiagaTheme.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomPaint(
            foregroundPainter: const _DottedBorder(),
            child: Material(
              color: SiagaTheme.background,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: documents
                              ? const Color(0xFFEFF6FF)
                              : const Color(0xFFDBEAFE),
                        ),
                        child: Center(child: HomeIcon(action.icon)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              documents ? 'Scan KK, KTP & berkas penting' : 'Kamera AI Vision deteksi ketinggian genangan',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.25,
                                color: SiagaTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (documents)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: HomeIcon('chevron', size: 18),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DottedBorder extends CustomPainter {
  const _DottedBorder();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(.5),
          const Radius.circular(16),
        ),
      );
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in path.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += 3) {
        canvas.drawPath(
          metric.extractPath(start, math.min(start + 1, metric.length)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorder oldDelegate) => false;
}
