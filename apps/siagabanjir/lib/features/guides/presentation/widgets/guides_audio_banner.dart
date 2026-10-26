import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Banner pemutar audio instruksi suara darurat sesuai desain referensi guides_detail.svg.
class GuidesAudioBanner extends StatelessWidget {
  const GuidesAudioBanner({
    super.key,
    required this.isPlaying,
    required this.onTogglePlay,
  });

  final bool isPlaying;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFBFDBFE)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF2563EB).withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                color: SiagaTheme.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instruksi Suara Darurat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: SiagaTheme.ink,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Dengarkan instruksi suara dalam situasi darurat',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SiagaTheme.muted,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Semantics(
          label: isPlaying ? 'Hentikan Instruksi Suara' : 'Dengarkan Panduan',
          button: true,
          child: Material(
            color: isPlaying ? const Color(0xFF1E3A8A) : SiagaTheme.blue,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTogglePlay,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPlaying
                          ? Icons.stop_circle_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isPlaying
                            ? 'Hentikan Instruksi Suara'
                            : 'Dengarkan Panduan',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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
