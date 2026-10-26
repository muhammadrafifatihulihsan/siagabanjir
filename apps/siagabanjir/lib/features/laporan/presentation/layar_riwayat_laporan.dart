import 'package:flutter/material.dart';

import '../../../shared/widgets/citizen_header.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/entri_riwayat_laporan.dart';
import 'widgets/kartu_riwayat_laporan.dart';
import 'widgets/dialog_riwayat_laporan.dart';
import 'widgets/tab_filter_riwayat_laporan.dart';

// Layar Riwayat Laporan Warga sesuai desain SVG reports_history.
class LayarRiwayatLaporan extends StatefulWidget {
  const LayarRiwayatLaporan({
    super.key,
    required this.onNotifications,
    required this.onReport,
    required this.onProfile,
    this.onHome,
  });

  final VoidCallback onNotifications;
  final VoidCallback onReport;
  final VoidCallback onProfile;
  final VoidCallback? onHome;

  @override
  State<LayarRiwayatLaporan> createState() => _LayarRiwayatLaporanState();
}

class _LayarRiwayatLaporanState extends State<LayarRiwayatLaporan> {
  final _scrollController = ScrollController();
  FilterRiwayatLaporan _selectedFilter = FilterRiwayatLaporan.all;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Map<FilterRiwayatLaporan, int> get _counts => {
    FilterRiwayatLaporan.all: kSampleReportHistoryItems.length,
    FilterRiwayatLaporan.inProgress: kSampleReportHistoryItems
        .where((i) => i.matchesFilter(FilterRiwayatLaporan.inProgress))
        .length,
    FilterRiwayatLaporan.completed: kSampleReportHistoryItems
        .where((i) => i.matchesFilter(FilterRiwayatLaporan.completed))
        .length,
  };

  List<EntriRiwayatLaporan> get _filteredItems => kSampleReportHistoryItems
      .where((item) => item.matchesFilter(_selectedFilter))
      .toList();

  void _onNavigationSelect(CitizenDestination destination) {
    switch (destination) {
      case CitizenDestination.home:
        if (widget.onHome != null) {
          widget.onHome!();
        } else {
          Navigator.pop(context);
        }
      case CitizenDestination.report:
        widget.onReport();
      case CitizenDestination.history:
        if (MediaQuery.disableAnimationsOf(context)) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      case CitizenDestination.profile:
        widget.onProfile();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8FAFC),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              CitizenHeader(onNotifications: widget.onNotifications),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  key: const PageStorageKey('reports-history-scroll'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Riwayat Laporan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pantau status laporan dan riwayat foto banjir.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TabFilterRiwayatLaporan(
                        selected: _selectedFilter,
                        counts: _counts,
                        onSelect: (filter) =>
                            setState(() => _selectedFilter = filter),
                      ),
                      const SizedBox(height: 16),
                      if (_filteredItems.isEmpty)
                        _buildEmptyState()
                      else
                        for (final item in _filteredItems) ...[
                          KartuRiwayatLaporan(
                            item: item,
                            onTap: () =>
                                showReportHistoryDetailDialog(context, item),
                            onPhotoTap: () =>
                                showReportHistoryPhotoDialog(context, item),
                          ),
                          const SizedBox(height: 14),
                        ],
                    ],
                  ),
                ),
              ),
              CitizenNavigation(
                selected: CitizenDestination.history,
                onSelect: _onNavigationSelect,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildEmptyState() => Container(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    alignment: Alignment.center,
    child: Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(
            Icons.history_outlined,
            size: 28,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tidak ada laporan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Belum ada laporan dengan filter status ini.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
      ],
    ),
  );
}
