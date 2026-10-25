import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import 'report_section.dart';

// Label menetap dan contoh spesifik membantu warga menulis keterangan kejadian.
class ReportDescriptionSection extends StatelessWidget {
  const ReportDescriptionSection({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => ReportSection(
    title: 'Deskripsi Kejadian',
    hint: 'Ceritakan kondisi air dan dampaknya di sekitar Anda.',
    child: TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      minLines: 3,
      maxLines: 6,
      maxLength: 2000,
      style: const TextStyle(fontSize: 14, height: 1.4, color: SiagaTheme.ink),
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      // Sentuhan di luar input menutup keyboard tanpa menghapus isi form.
      onTapOutside: (_) => focusNode.unfocus(),
      scrollPadding: const EdgeInsets.all(24),
      buildCounter:
          (context, {required currentLength, required isFocused, maxLength}) =>
              Text(
                '$currentLength / $maxLength karakter',
                semanticsLabel: '$currentLength dari $maxLength karakter',
                style: const TextStyle(
                  fontSize: 12,
                  color: SiagaTheme.mutedOnTint,
                ),
              ),
      decoration: InputDecoration(
        labelText: 'Keterangan kejadian',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Contoh: Air masuk ke rumah dan menutup jalan.',
        hintStyle: const TextStyle(color: SiagaTheme.mutedOnTint),
        filled: true,
        fillColor: SiagaTheme.background,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: _border(SiagaTheme.muted),
        focusedBorder: _border(SiagaTheme.blue, width: 2),
        border: _border(SiagaTheme.muted),
      ),
    ),
  );

  // Batas input berkontras; garis lebih tebal menunjukkan fokus keyboard.
  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
}
