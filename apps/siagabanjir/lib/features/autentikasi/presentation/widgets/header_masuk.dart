import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/local_icon.dart';

// Bagian header identitas brand SiagaBanjir pada halaman login.
// Menampilkan logo tetes air pada wadah biru muda bertepi serta judul aplikasi.
class HeaderMasuk extends StatelessWidget {
  const HeaderMasuk({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Wadah ikon brand tetes air dengan ukuran 58x58 dan radius 18 sesuai SVG.
      Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          border: Border.all(color: const Color(0xFFBFDBFE)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Center(child: LocalIcon('brand', size: 30)),
      ),
      const SizedBox(height: 14),
      // Judul nama aplikasi dengan warna biru primer dan bobot tebal (ExtraBold/w800).
      const Text(
        'SiagaBanjir',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: SiagaTheme.judulHalaman,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1D4ED8),
          letterSpacing: -0.5,
          height: 1.15,
        ),
      ),
      const SizedBox(height: 4),
      // Tagline deskripsi produk: Tanggap Darurat Banjir Warga.
      const Text(
        'Tanggap Darurat Banjir Warga',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: SiagaTheme.isi,
          fontWeight: FontWeight.w500,
          color: Color(0xFF64748B),
          height: 1.3,
        ),
      ),
    ],
  );
}
