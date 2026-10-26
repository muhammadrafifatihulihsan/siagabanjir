import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import 'bagian_laporan.dart';

// Area bukti mempertahankan susunan SVG tanpa mengklaim kamera sudah terhubung.
class BagianBuktiLaporan extends StatelessWidget {
  const BagianBuktiLaporan({
    super.key,
    required this.onCamera,
    required this.onLocation,
  });

  final VoidCallback onCamera;
  final VoidCallback onLocation;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      BagianLaporan(
        title: 'Foto Kejadian',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SiagaTheme.selectionBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 32,
                    color: SiagaTheme.blue,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Ambil Foto Langsung di Lokasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tampilkan kondisi air dan area di sekitarnya.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: SiagaTheme.mutedOnTint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _action('Buka Kamera Ponsel', Icons.camera_alt_outlined, onCamera),
            const SizedBox(height: 8),
            // Informasi netral menggantikan perisai hijau yang menyiratkan verifikasi.
            const Text(
              'Foto belum ditambahkan. Kamera belum tersedia pada pratinjau ini.',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: SiagaTheme.mutedOnTint,
              ),
            ),
          ],
        ),
      ),
      BagianLaporan(
        title: 'Titik Lokasi Kejadian',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Alamat sintetis diberi label agar tidak dianggap hasil pembacaan GPS.
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: SiagaTheme.blue,
                  size: 24,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jl. Dr. Moh. Hatta No. 42, Koto Tangah, Padang',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lokasi contoh. GPS belum diambil.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: SiagaTheme.mutedOnTint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _action(
              'Sinkronisasi Lokasi GPS',
              Icons.my_location_outlined,
              onLocation,
            ),
          ],
        ),
      ),
    ],
  );

  // Tombol sekunder tetap jelas tetapi tidak menyaingi tindakan utama Kirim.
  Widget _action(String label, IconData icon, VoidCallback onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.all(12),
          foregroundColor: SiagaTheme.blue,
          side: const BorderSide(color: SiagaTheme.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}
