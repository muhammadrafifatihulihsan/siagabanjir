import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import 'bagian_laporan.dart';

// Menyusun pilihan berdasarkan ruang baca, bukan mengecilkan ukuran huruf.
class BagianPilihanLaporan extends StatelessWidget {
  const BagianPilihanLaporan({
    super.key,
    required this.title,
    required this.hint,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.multiple = false,
  });

  final String title;
  final String hint;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onSelect;
  final bool multiple;

  @override
  Widget build(BuildContext context) => BagianLaporan(
    title: title,
    hint: hint,
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Dua kolom hanya jika label dan indikator tetap mendapat ruang cukup.
        final columns =
            constraints.maxWidth / MediaQuery.textScalerOf(context).scale(1) >=
                300
            ? 2
            : 1;
        final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              SizedBox(
                width: width,
                child: _PilihanLaporan(
                  minHeight: columns == 2
                      ? MediaQuery.textScalerOf(context).scale(14) * 2.8 + 32
                      : 56,
                  label: option,
                  selected: selected.contains(option),
                  multiple: multiple,
                  onTap: () => onSelect(option),
                ),
              ),
          ],
        );
      },
    ),
  );
}

// Satu pilihan memiliki indikator bentuk, status aksesibel, dan fokus keyboard.
class _PilihanLaporan extends StatefulWidget {
  const _PilihanLaporan({
    required this.minHeight,
    required this.label,
    required this.selected,
    required this.multiple,
    required this.onTap,
  });

  final String label;
  // Ruang dua baris membuat tinggi pilihan sederet sejajar tanpa memotong teks.
  final double minHeight;
  final bool selected;
  final bool multiple;
  final VoidCallback onTap;

  @override
  State<_PilihanLaporan> createState() => _PilihanLaporanState();
}

class _PilihanLaporanState extends State<_PilihanLaporan> {
  // Fokus ditandai garis tegas, bukan hanya perubahan warna latar.
  bool _focused = false;

  @override
  Widget build(BuildContext context) => Semantics(
    checked: widget.selected,
    inMutuallyExclusiveGroup: !widget.multiple,
    label: widget.label,
    child: Material(
      color: widget.selected ? SiagaTheme.selectionBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _focused || widget.selected
              ? SiagaTheme.blue
              : SiagaTheme.muted,
          width: _focused ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      // InkWell mempertahankan aktivasi Enter/Space dan semantics fokus bawaan.
      child: InkWell(
        onTap: widget.onTap,
        onFocusChange: (value) => setState(() => _focused = value),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.minHeight),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  Icon(
                    widget.multiple
                        ? (widget.selected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank)
                        : (widget.selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked),
                    size: 22,
                    color: widget.selected
                        ? SiagaTheme.blue
                        : SiagaTheme.mutedOnTint,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: widget.selected
                            ? SiagaTheme.deepBlue
                            : SiagaTheme.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
