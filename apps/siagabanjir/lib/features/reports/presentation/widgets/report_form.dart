import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import 'report_choice_section.dart';
import 'report_description_section.dart';
import 'report_evidence_sections.dart';

// Menyusun bagian form; nilai dan callback dimiliki layar, bukan disalin di widget.
class ReportForm extends StatelessWidget {
  const ReportForm({
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
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Lengkapi foto, lokasi, dan kondisi kejadian.',
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: SiagaTheme.mutedOnTint,
        ),
      ),
      const SizedBox(height: 16),
      ReportEvidenceSections(onCamera: onCamera, onLocation: onLocation),
      // Pilihan tunggal dan jamak diberi petunjuk berbeda untuk mencegah salah isi.
      ReportChoiceSection(
        title: 'Kategori Luapan Banjir',
        hint: 'Pilih satu yang sesuai kondisi.',
        options: const ['Luapan Sungai', 'Banjir Bandang', 'Genangan Hujan'],
        selected: {?category},
        onSelect: onCategoryChanged,
      ),
      ReportChoiceSection(
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
      ReportDescriptionSection(
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Pratinjau desain. Laporan belum disimpan atau dikirim.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: SiagaTheme.mutedOnTint,
        ),
      ),
    ],
  );
}
