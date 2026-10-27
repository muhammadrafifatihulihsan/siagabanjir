import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/entri_riwayat_laporan.dart';

class KartuRiwayatLaporan extends StatelessWidget {
  const KartuRiwayatLaporan({
    super.key,
    required this.item,
    required this.onTap,
  });
  final EntriRiwayatLaporan item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.description_outlined,
              size: 24,
              color: SiagaTheme.blue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.kategori,
                    style: const TextStyle(
                      fontSize: SiagaTheme.judulBagian,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.deskripsi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.timestamp,
                    style: const TextStyle(
                      fontSize: SiagaTheme.keterangan,
                      color: SiagaTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    ),
  );
}
