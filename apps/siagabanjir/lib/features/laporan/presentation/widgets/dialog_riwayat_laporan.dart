import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:siagabanjir/shared/widgets/dialog_siaga.dart';
import 'package:flutter/material.dart';

import '../../domain/entri_riwayat_laporan.dart';

Future<void> showReportHistoryPhotoDialog(
  BuildContext context,
  EntriRiwayatLaporan item,
) => showDialog<void>(
  context: context,
  builder: (context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.asset(
                item.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFE2E8F0),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filled(
                tooltip: 'Tutup foto',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.location,
                style: const TextStyle(
                  fontSize: SiagaTheme.judulBagian,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Status: ${item.statusLabel} • ${item.timestamp}',
                style: const TextStyle(
                  fontSize: SiagaTheme.isi,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

Future<void> showReportHistoryDetailDialog(
  BuildContext context,
  EntriRiwayatLaporan item,
) => showDialog<void>(
  context: context,
  builder: (context) => DialogSiaga(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Text(
      item.location,
      style: const TextStyle(
        fontSize: SiagaTheme.judulBagian,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Status: ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: SiagaTheme.isi,
              ),
            ),
            Text(
              item.statusLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: SiagaTheme.isi,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Waktu: ${item.timestamp}',
          style: const TextStyle(
            fontSize: SiagaTheme.isi,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Kondisi: ${item.waterLevel} (${item.floodType})',
          style: const TextStyle(
            fontSize: SiagaTheme.isi,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            item.progressNote,
            style: const TextStyle(
              fontSize: SiagaTheme.isi,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Tutup',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ],
  ),
);
