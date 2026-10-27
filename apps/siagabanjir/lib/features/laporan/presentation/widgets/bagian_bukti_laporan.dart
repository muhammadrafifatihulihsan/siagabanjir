import 'package:flutter/material.dart';

import 'dart:typed_data';

import '../../../../shared/theme/siaga_theme.dart';
import 'bagian_laporan.dart';

// Area bukti mempertahankan susunan SVG tanpa mengklaim kamera sudah terhubung.
class BagianBuktiLaporan extends StatelessWidget {
  const BagianBuktiLaporan({
    super.key,
    required this.onCamera,
    required this.onLocation,
    this.foto,
    this.memuatFoto = false,
  });

  final VoidCallback onCamera;
  final VoidCallback onLocation;
  final Uint8List? foto;
  final bool memuatFoto;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      BagianLaporan(
        title: 'Foto Kejadian',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (foto != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  foto!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel: 'Foto kejadian yang diambil',
                  errorBuilder: (_, _, _) => const Text(
                    'Foto tidak dapat ditampilkan. Ambil ulang foto.',
                  ),
                ),
              )
            else
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
                      style: TextStyle(
                        fontSize: SiagaTheme.judulBagian,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tampilkan kondisi air dan area di sekitarnya.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SiagaTheme.isi,
                        height: 1.4,
                        color: SiagaTheme.mutedOnTint,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            _action(
              memuatFoto
                  ? 'Membuka Kamera...'
                  : foto == null
                  ? 'Buka Kamera Ponsel'
                  : 'Ambil Ulang Foto',
              Icons.camera_alt_outlined,
              memuatFoto ? null : onCamera,
            ),
            const SizedBox(height: 8),
            // Informasi netral menggantikan perisai hijau yang menyiratkan verifikasi.
            Text(
              foto == null
                  ? 'Ambil foto langsung di lokasi kejadian banjir.'
                  : 'Foto bukti berhasil dilampirkan.',
              style: const TextStyle(
                fontSize: SiagaTheme.isi,
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
                          fontSize: SiagaTheme.isi,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lokasi terdeteksi otomatis melalui GPS',
                        style: TextStyle(
                          fontSize: SiagaTheme.isi,
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
  Widget _action(String label, IconData icon, VoidCallback? onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: SiagaTheme.isi,
            fontWeight: FontWeight.w700,
          ),
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
