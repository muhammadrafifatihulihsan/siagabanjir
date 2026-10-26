import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

import '../../domain/entri_riwayat_laporan.dart';

// Tab filter status riwayat laporan sesuai desain SVG reports_history.
class TabFilterRiwayatLaporan extends StatelessWidget {
  const TabFilterRiwayatLaporan({
    super.key,
    required this.selected,
    required this.counts,
    required this.onSelect,
  });

  final FilterRiwayatLaporan selected;
  final Map<FilterRiwayatLaporan, int> counts;
  final ValueChanged<FilterRiwayatLaporan> onSelect;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    child: Row(
      children: [
        for (final filter in FilterRiwayatLaporan.values) ...[
          _filterPill(
            filter: filter,
            count: counts[filter] ?? 0,
            isSelected: selected == filter,
          ),
          const SizedBox(width: 8),
        ],
      ],
    ),
  );

  Widget _filterPill({
    required FilterRiwayatLaporan filter,
    required int count,
    required bool isSelected,
  }) {
    final label = '${filter.label} ($count)';
    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => onSelect(filter),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: isSelected
                  ? null
                  : Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: SiagaTheme.isi,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
