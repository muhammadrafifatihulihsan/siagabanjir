import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Banner informasi penting penyimpanan tas siaga di dekat pintu utama.
class BannerInfoTasSiaga extends StatelessWidget {
  const BannerInfoTasSiaga({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF6FF),
      border: Border.all(color: const Color(0xFFBFDBFE)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 24, color: SiagaTheme.blue),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Simpan tas di dekat pintu utama yang mudah dijangkau saat sirine siaga berbunyi.',
            style: TextStyle(
              fontSize: SiagaTheme.isi,
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D4ED8),
            ),
          ),
        ),
      ],
    ),
  );
}
