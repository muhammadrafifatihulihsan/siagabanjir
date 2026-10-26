import 'package:flutter/material.dart';
import 'package:siagabanjir/shared/widgets/local_icon.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../aksi_beranda.dart';
import 'aksi_fitur_beranda.dart';

class KartuFiturBeranda extends StatelessWidget {
  const KartuFiturBeranda({
    super.key,
    required this.action,
    required this.onTap,
  });

  final AksiBeranda action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final documents = action == AksiBeranda.documents;
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    LocalIcon(
                      documents ? 'document_badge' : 'ai_badge',
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        documents ? 'Dokumen Siaga' : 'AI Vision',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                documents ? '3/3 Berkas Siaga' : 'Sisa kuota: 1/2',
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  color: SiagaTheme.mutedOnTint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AksiFiturBeranda(action: action, onTap: onTap),
        ],
      ),
    );
  }
}
