import 'package:flutter/material.dart';

import '../../domain/report_history_item.dart';

// Tab filter status riwayat laporan sesuai desain SVG reports_history.
class ReportsHistoryFilterTabs extends StatelessWidget {
  const ReportsHistoryFilterTabs({
    super.key,
    required this.selected,
    required this.counts,
    required this.onSelect,
  });

  final ReportHistoryFilter selected;
  final Map<ReportHistoryFilter, int> counts;
  final ValueChanged<ReportHistoryFilter> onSelect;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    child: Row(
      children: [
        for (final filter in ReportHistoryFilter.values) ...[
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
    required ReportHistoryFilter filter,
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
                fontSize: 14,
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
