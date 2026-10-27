import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/entri_riwayat_laporan.dart';

Future<void> showReportHistoryDetailDialog(
  BuildContext context,
  EntriRiwayatLaporan item,
) => showDialog<void>(
  context: context,
  builder: (ctx) => DialogSiaga(
    title: Text(item.kategori),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(item.timestamp),
        const SizedBox(height: 16),
        Text(item.deskripsi),
        const SizedBox(height: 16),
        Text(
          'Kebutuhan: ${item.kebutuhan.isEmpty ? 'Tidak dipilih' : item.kebutuhan.join(', ')}',
        ),
        if (item.foto != null) ...[
          const SizedBox(height: 16),
          Image.memory(
            item.foto!,
            fit: BoxFit.contain,
            semanticLabel: 'Foto yang Anda lampirkan',
            errorBuilder: (_, _, _) =>
                const Text('Pratinjau foto tidak tersedia.'),
          ),
        ],
        const SizedBox(height: 16),
        const Text(
          'Catatan sesi demo. Belum dikirim ke petugas; lokasi perangkat belum dibaca.',
        ),
      ],
    ),
    actions: [
      FilledButton(
        onPressed: () => Navigator.pop(ctx),
        child: const Text('Tutup'),
      ),
    ],
  ),
);
