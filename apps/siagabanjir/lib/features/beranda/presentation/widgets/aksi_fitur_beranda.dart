import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:siagabanjir/shared/widgets/local_icon.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../aksi_beranda.dart';

class AksiFiturBeranda extends StatelessWidget {
  const AksiFiturBeranda({
    super.key,
    required this.action,
    required this.onTap,
  });

  final AksiBeranda action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final documents = action == AksiBeranda.documents;
    final description = Text(
      documents
          ? 'Scan KK, KTP & berkas penting'
          : 'Kamera AI Vision deteksi ketinggian genangan',
      style: const TextStyle(
        fontSize: SiagaTheme.isi,
        height: 1.4,
        color: SiagaTheme.mutedOnTint,
      ),
    );
    return CustomPaint(
      foregroundPainter: const _GarisPutusPutus(),
      child: Material(
        color: SiagaTheme.background,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Keep supporting text full-width when the icon would crowd it.
                final stacked =
                    constraints.maxWidth <
                    MediaQuery.textScalerOf(context).scale(260);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: Center(
                            // The document slice has more transparent padding.
                            // These sizes give both glyphs a ~21 px visible span.
                            child: LocalIcon(
                              action.icon,
                              size: documents ? 24 : 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                action.title,
                                style: const TextStyle(
                                  fontSize: SiagaTheme.judulBagian,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                              ),
                              if (!stacked) ...[
                                const SizedBox(height: 6),
                                description,
                              ],
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: LocalIcon('chevron', size: 18),
                        ),
                      ],
                    ),
                    if (stacked) ...[const SizedBox(height: 12), description],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _GarisPutusPutus extends CustomPainter {
  const _GarisPutusPutus();

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
  bool shouldRepaint(covariant _GarisPutusPutus oldDelegate) => false;
}
