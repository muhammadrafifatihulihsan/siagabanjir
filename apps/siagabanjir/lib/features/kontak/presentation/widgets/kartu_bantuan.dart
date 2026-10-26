import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../../../shared/widgets/dialog_siaga.dart';

class KartuBantuan extends StatelessWidget {
  const KartuBantuan({super.key, this.posko = false});
  final bool posko;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: posko ? const Color(0xFFEFF6FF) : const Color(0xFFFEF2F2),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: posko ? const Color(0xFFBFDBFE) : const Color(0xFFFECACA),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          posko ? 'Posko Pengungsian' : 'Butuh Bantuan Segera?',
          style: const TextStyle(
            fontSize: SiagaTheme.judulBagian,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          posko
              ? 'SMPN 12 Padang • contoh titik kumpul'
              : 'Layanan darurat terpadu • 112',
          style: const TextStyle(fontSize: SiagaTheme.isi),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: posko ? SiagaTheme.blue : const Color(0xFFB91C1C),
          ),
          onPressed: () => tampilkanInfoSiaga(
            context,
            posko ? 'Informasi posko' : 'Layanan darurat',
            posko
                ? 'Lokasi ini mengikuti ilustrasi desain. Status aktif, kapasitas, dan rute posko belum terhubung ke data petugas.'
                : 'Pratinjau ini tidak melakukan panggilan. Ketersediaan layanan 112 di lokasi Anda belum diverifikasi oleh aplikasi. Gunakan aplikasi Telepon untuk menghubungi layanan yang telah Anda pastikan.',
          ),
          icon: Icon(posko ? Icons.location_on_outlined : Icons.phone_outlined),
          label: Text(
            posko ? 'Lihat Informasi Posko' : 'Informasi Layanan 112',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
