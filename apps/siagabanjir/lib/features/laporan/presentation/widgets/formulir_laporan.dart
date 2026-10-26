import 'package:flutter/material.dart';

import 'dart:typed_data';

import '../../../../shared/theme/siaga_theme.dart';
import 'bagian_pilihan_laporan.dart';
import 'bagian_deskripsi_laporan.dart';
import 'bagian_bukti_laporan.dart';

// Menyusun bagian form; nilai dan callback dimiliki layar, bukan disalin di widget.
class FormulirLaporan extends StatelessWidget {
  const FormulirLaporan({
    super.key,
    required this.description,
    required this.descriptionFocus,
    required this.category,
    required this.needs,
    required this.onDescriptionChanged,
    required this.onCategoryChanged,
    required this.onNeedChanged,
    required this.onCamera,
    required this.onLocation,
    required this.onSubmit,
    this.foto,
    this.memuatFoto = false,
  });

  final TextEditingController description;
  final FocusNode descriptionFocus;
  final String? category;
  final Set<String> needs;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onNeedChanged;
  final VoidCallback onCamera;
  final VoidCallback onLocation;
  final VoidCallback onSubmit;
  final Uint8List? foto;
  final bool memuatFoto;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Judul konteks tampil sebelum langkah form agar tujuan layar mudah dipahami.
      Semantics(
        header: true,
        child: const Text(
          'Lapor Kejadian Banjir',
          style: TextStyle(
            fontSize: SiagaTheme.judulHalaman,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Lengkapi foto, lokasi, dan kondisi kejadian.',
        style: TextStyle(
          fontSize: SiagaTheme.isi,
          height: 1.4,
          color: SiagaTheme.mutedOnTint,
        ),
      ),
      const SizedBox(height: 16),
      BagianBuktiLaporan(
        onCamera: onCamera,
        onLocation: onLocation,
        foto: foto,
        memuatFoto: memuatFoto,
      ),
      // Pilihan tunggal dan jamak diberi petunjuk berbeda untuk mencegah salah isi.
      BagianPilihanLaporan(
        title: 'Kategori Luapan Banjir',
        hint: 'Pilih satu yang sesuai kondisi.',
        options: const ['Luapan Sungai', 'Banjir Bandang', 'Genangan Hujan'],
        selected: {?category},
        onSelect: onCategoryChanged,
      ),
      BagianPilihanLaporan(
        title: 'Kebutuhan Evakuasi Mendesak',
        hint: 'Boleh pilih lebih dari satu, jika diperlukan.',
        options: const [
          'Perahu Karet',
          'Evakuasi Balita',
          'Bantuan Logistik',
          'Medis Darurat',
        ],
        selected: needs,
        onSelect: onNeedChanged,
        multiple: true,
      ),
      BagianDeskripsiLaporan(
        controller: description,
        focusNode: descriptionFocus,
        onChanged: onDescriptionChanged,
      ),
      // Kirim adalah satu-satunya tombol utama; aksi masih menjelaskan batas pratinjau.
      FilledButton.icon(
        onPressed: onSubmit,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.send_outlined, size: 20),
        label: const Text(
          'Kirim Laporan Banjir',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: SiagaTheme.judulBagian,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Pratinjau desain. Laporan belum disimpan atau dikirim.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: SiagaTheme.isi,
          height: 1.4,
          color: SiagaTheme.mutedOnTint,
        ),
      ),
    ],
  );
}
