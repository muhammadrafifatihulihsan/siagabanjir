import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../models/pesan_siaga.dart';

// Pilihan filter horizontal berbentuk pill tab sesuai desain SVG.
class TabFilterPesan extends StatelessWidget {
  const TabFilterPesan({
    super.key,
    required this.selected,
    required this.onSelect,
    this.emergencyCount = 1,
    this.weatherCount = 1,
    this.totalCount = 3,
  });

  final KategoriPesan selected;
  final ValueChanged<KategoriPesan> onSelect;
  final int totalCount;
  final int emergencyCount;
  final int weatherCount;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Row(
      children: [
        _pill(category: KategoriPesan.all, label: 'Semua ($totalCount)'),
        const SizedBox(width: 8),
        _pill(
          category: KategoriPesan.emergency,
          label: 'Darurat ($emergencyCount)',
        ),
        const SizedBox(width: 8),
        _pill(
          category: KategoriPesan.weather,
          label: 'Cuaca BMKG ($weatherCount)',
        ),
      ],
    ),
  );

  Widget _pill({required KategoriPesan category, required String label}) {
    final active = selected == category;
    return Semantics(
      selected: active,
      button: true,
      label: label,
      child: Material(
        color: active ? SiagaTheme.ink : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: active ? SiagaTheme.ink : SiagaTheme.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onSelect(category),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: SiagaTheme.isi,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                color: active ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
