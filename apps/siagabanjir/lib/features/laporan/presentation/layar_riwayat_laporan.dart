import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/widgets/citizen_header.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/entri_riwayat_laporan.dart';
import 'widgets/kartu_riwayat_laporan.dart';
import 'widgets/dialog_riwayat_laporan.dart';

// Layar Riwayat Laporan Warga sesuai desain SVG reports_history.
class LayarRiwayatLaporan extends StatefulWidget {
  const LayarRiwayatLaporan({
    super.key,
    this.riwayat,
    this.scrollController,
    required this.onNotifications,
    required this.onReport,
    required this.onProfile,
    this.onHome,
  });

  final ValueNotifier<List<EntriRiwayatLaporan>>? riwayat;
  final VoidCallback onNotifications;
  final VoidCallback onReport;
  final VoidCallback onProfile;
  final VoidCallback? onHome;

  final ScrollController? scrollController;

  @override
  State<LayarRiwayatLaporan> createState() => _LayarRiwayatLaporanState();
}

class _LayarRiwayatLaporanState extends State<LayarRiwayatLaporan> {
  late final _scrollController = widget.scrollController ?? ScrollController();
  late final _riwayat =
      widget.riwayat ?? ValueNotifier<List<EntriRiwayatLaporan>>([]);

  @override
  void dispose() {
    if (widget.scrollController == null) _scrollController.dispose();
    if (widget.riwayat == null) _riwayat.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _riwayat,
    builder: (context, daftar, _) => Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                if (!LingkupNavigasi.aktif(context))
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
                            fontSize: SiagaTheme.judulHalaman,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Catatan yang Anda simpan selama sesi demo. Ketuk laporan untuk melihat detail.',
                          style: TextStyle(
                            fontSize: SiagaTheme.isi,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (daftar.isEmpty)
                          _buildEmptyState()
                        else
                          for (final item in daftar) ...[
                            KartuRiwayatLaporan(
                              item: item,
                              onTap: () =>
                                  showReportHistoryDetailDialog(context, item),
                            ),
                            const SizedBox(height: 14),
                          ],
                      ],
                    ),
                  ),
                ),
                if (!LingkupNavigasi.aktif(context))
                  CitizenNavigation(
                    selected: CitizenDestination.history,
                    onSelect: _onNavigationSelect,
                  ),
              ],
            ),
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
            fontSize: SiagaTheme.judulBagian,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Isi formulir Lapor untuk menambahkan catatan pertama Anda.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: SiagaTheme.isi, color: Color(0xFF64748B)),
        ),
      ],
    ),
  );
}
