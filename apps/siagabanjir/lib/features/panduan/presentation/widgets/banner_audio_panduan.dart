import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../pengendali_suara.dart';

class BannerAudioPanduan extends StatelessWidget {
  const BannerAudioPanduan({
    super.key,
    required this.pengendali,
    required this.onPutar,
  });
  final PengendaliSuara pengendali;
  final VoidCallback onPutar;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: pengendali,
    builder: (context, _) {
      final status = pengendali.status;
      final aktif = status == StatusNarasi.berbicara;
      final jeda = status == StatusNarasi.jeda;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: SiagaTheme.blue,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bantuan Suara Panduan',
                        style: TextStyle(
                          fontSize: SiagaTheme.judulBagian,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Narasi bahasa Indonesia • kecepatan normal',
                        style: TextStyle(
                          fontSize: SiagaTheme.isi,
                          color: SiagaTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: pengendali.sibuk
                  ? null
                  : aktif
                  ? pengendali.jeda
                  : jeda
                  ? pengendali.lanjut
                  : onPutar,
              icon: Icon(
                aktif ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              label: Text(
                pengendali.sibuk
                    ? 'Menyiapkan Suara...'
                    : aktif
                    ? 'Jeda Panduan Suara'
                    : jeda
                    ? 'Lanjutkan Panduan Suara'
                    : 'Dengarkan Panduan Suara',
                textAlign: TextAlign.center,
              ),
            ),
            if (aktif || jeda || pengendali.sibuk) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: pengendali.hentikan,
                icon: const Icon(Icons.stop_rounded),
                label: const Text('Hentikan Panduan Suara'),
              ),
            ],
            if (pengendali.pesan != null) ...[
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: Text(
                  pengendali.pesan!,
                  style: const TextStyle(
                    fontSize: SiagaTheme.isi,
                    color: Color(0xFF991B1B),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              pengendali.info?.perluJaringan == false
                  ? 'Menggunakan suara Indonesia yang tersedia di perangkat.'
                  : 'Suara mengikuti mesin TTS perangkat dan mungkin membutuhkan internet.',
              style: const TextStyle(
                fontSize: SiagaTheme.isi,
                height: 1.4,
                color: SiagaTheme.muted,
              ),
            ),
          ],
        ),
      );
    },
  );
}
