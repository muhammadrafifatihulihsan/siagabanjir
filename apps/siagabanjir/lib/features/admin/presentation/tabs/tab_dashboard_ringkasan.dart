import 'package:flutter/material.dart';

import '../../domain/klaster_wilayah.dart';
import '../../domain/state_admin_siaga.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/modal_bukti_wilayah.dart';

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
    final sungai = state.sungaiSorotan;
    final totalLaporan = state.semuaLaporan.length;
    final klasterAktif = state.klasterList.length;
    final pesanAktif = state.pesanSiaga.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Salam Petugas & Jam Operasional
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A1E3A8A),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: Colors.white70,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'PUSDALOPS-PB BPBD KOTA PADANG',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Selamat Bertugas, ${state.profilAdmin.nama}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pantauan realtime luapan sungai dan laporan banjir warga Kota Padang.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => onNavigateToTab(AdminMenuTab.pusatOperasional),
                  icon: const Icon(Icons.campaign_rounded, size: 18),
                  label: const Text(
                    'Siarkan Peringatan',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Baris 4 Kartu Metrik KPI Utama
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  title: 'Total Laporan Warga',
                  value: '$totalLaporan',
                  sub: 'Laporan terkumpul',
                  icon: Icons.assignment_outlined,
                  color: const Color(0xFF2563EB),
                  bg: const Color(0xFFEFF6FF),
                  onTap: () => onNavigateToTab(AdminMenuTab.laporanIndividu),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKpiCard(
                  title: 'Wilayah Terdampak',
                  value: '$klasterAktif Klaster',
                  sub: 'Dikelompokkan AI',
                  icon: Icons.hub_outlined,
                  color: const Color(0xFFD97706),
                  bg: const Color(0xFFFEF3C7),
                  onTap: () => onNavigateToTab(AdminMenuTab.klasterWilayah),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKpiCard(
                  title: 'Batang Kuranji',
                  value: '${sungai.waterLevelCm} cm',
                  sub: sungai.statusLabel,
                  icon: Icons.water_drop_outlined,
                  color: const Color(0xFFDC2626),
                  bg: const Color(0xFFFEE2E2),
                  onTap: () => onNavigateToTab(AdminMenuTab.pusatOperasional),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKpiCard(
                  title: 'Peringatan Aktif',
                  value: '$pesanAktif Pesan',
                  sub: 'Terkirim ke warga',
                  icon: Icons.notifications_active_outlined,
                  color: const Color(0xFF059669),
                  bg: const Color(0xFFECFDF5),
                  onTap: () => onNavigateToTab(AdminMenuTab.pusatOperasional),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Wilayah Kritis Laporan Terbanyak (Klaster AI)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wilayah dengan Laporan Terbanyak (Klaster AI)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Laporan warga yang dikelompokkan secara otomatis oleh AI berdasarkan jarak & waktu.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => onNavigateToTab(AdminMenuTab.klasterWilayah),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text(
                  'Lihat Semua Wilayah',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List Klaster Wilayah Ringkas
          ...state.klasterList.map(
            (klaster) => _buildKlasterCard(context, klaster),
          ),

          const SizedBox(height: 24),

          // Infrastruktur Pompa & Pintu Air
          const Text(
            'Kesiapan Infrastruktur & Pompa Pengendali Banjir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: state.infrastruktur
                .map(
                  (infra) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.build_circle_outlined,
                              color: Color(0xFF2563EB),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  infra.title,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  infra.status,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x060F172A),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKlasterCard(BuildContext context, KlasterWilayahAi k) {
    final level = k.tingkatTinggiAir;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: level.badgeBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: level.badgeForeground,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      k.namaWilayah,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: level.badgeBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        level.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: level.badgeForeground,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${k.kecamatan} • Estimasi AI: ${k.estimasiKedalaman} • Butuh: ${k.kebutuhanDominan.join(", ")}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${k.totalLaporan} Laporan Warga',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => ModalBuktiWilayah.show(context, klaster: k, state: state),
            child: const Text(
              'Tinjau Wilayah',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
