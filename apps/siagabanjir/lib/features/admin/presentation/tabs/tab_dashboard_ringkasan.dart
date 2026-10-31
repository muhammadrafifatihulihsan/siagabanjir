import 'package:flutter/material.dart';

import '../../domain/klaster_wilayah.dart';
import '../../domain/state_admin_siaga.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/kartu_klaster_admin.dart';
import '../widgets/tata_letak_admin.dart';

class TabDashboardRingkasan extends StatelessWidget {
  const TabDashboardRingkasan({
    super.key,
    required this.state,
    required this.onNavigateToTab,
  });
  final StateAdminSiaga state;
  final ValueChanged<AdminMenuTab> onNavigateToTab;

  @override
  Widget build(BuildContext context) {
    final menunggu = state.semuaLaporan
        .where(
          (l) => l.statusVerifikasi == StatusVerifikasiWilayah.menungguTinjauan,
        )
        .length;
    final aktif =
        state.klasterList
            .where((k) => k.statusVerifikasi != StatusVerifikasiWilayah.selesai)
            .toList()
          ..sort((a, b) => b.totalLaporan.compareTo(a.totalLaporan));
    final metrik = [
      ('Menunggu Verifikasi', menunggu, AdminMenuTab.laporanIndividu),
      (
        'Total Laporan',
        state.semuaLaporan.length,
        AdminMenuTab.laporanIndividu,
      ),
      ('Wilayah Aktif', aktif.length, AdminMenuTab.klasterWilayah),
      ('Siaran Aktif', state.pesanSiaga.length, AdminMenuTab.pusatOperasional),
    ];
    return HalamanAdmin(
      children: [
        const JudulAdmin(
          'Dashboard',
          description: 'Ringkasan laporan dan tinjauan wilayah.',
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final count = constraints.maxWidth / scale >= 900
                ? 4
                : constraints.maxWidth / scale >= 420
                ? 2
                : 1;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final m in metrik)
                  SizedBox(
                    width: (constraints.maxWidth - (count - 1) * 16) / count,
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onNavigateToTab(m.$3),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.$1,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${m.$2}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            const Text(
              'Wilayah dengan Laporan Terbanyak',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () => onNavigateToTab(AdminMenuTab.klasterWilayah),
              child: const Text('Lihat Semua Wilayah'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (aktif.isEmpty) const Text('Tidak ada wilayah aktif.'),
        for (final k in aktif.take(3))
          KartuKlasterAdmin(klaster: k, state: state),
      ],
    );
  }
}
