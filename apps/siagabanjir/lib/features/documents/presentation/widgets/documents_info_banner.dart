import 'package:flutter/material.dart';

// Banner informasi perlindungan berkas sipil dan prosedur dinas pasca-banjir.
class DocumentsInfoBanner extends StatelessWidget {
  const DocumentsInfoBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF6FF),
      border: Border.all(color: const Color(0xFFBFDBFE)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.shield_outlined,
          size: 24,
          color: Color(0xFF2563EB),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            const TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1E3A8A),
                height: 1.45,
              ),
              children: [
                TextSpan(
                  text: 'Perlindungan Berkas Sipil: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'Berkas tersimpan terenkripsi pada perangkat Anda. Saat dokumen fisik '
                      'hilang/rusak akibat banjir, Anda dapat langsung mengunduh paket dinas atau '
                      'mencetaknya untuk pengajuan ke Disdukcapil atau Kelurahan terdekat.',
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
