import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/document_entry.dart';

// Kartu ringkasan Dokumen Siaga Keluarga persis sesuai desain referensi documents_vault.svg.
class DocumentsSummaryCard extends StatelessWidget {
  const DocumentsSummaryCard({
    super.key,
    required this.entries,
  });

  final List<DocumentEntry> entries;

  @override
  Widget build(BuildContext context) {
    final savedCount = entries.where((e) => e.status == DocumentStatus.saved).length;
    final totalCount = entries.length;
    final progress = totalCount > 0 ? savedCount / totalCount : 0.0;
    final percent = (progress * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: SiagaTheme.border),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dokumen Siaga Keluarga',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: SiagaTheme.ink,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Simpan dokumen berharga ke dalam kantong kedap air',
                      style: TextStyle(
                        fontSize: 13,
                        color: SiagaTheme.muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: SiagaTheme.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(SiagaTheme.blue),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$savedCount dari $totalCount Berkas Tersimpan',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: SiagaTheme.ink,
                ),
              ),
              const Text(
                'Siap Darurat',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
