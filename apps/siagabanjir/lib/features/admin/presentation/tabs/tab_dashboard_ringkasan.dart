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
    final terverifikasi = state.semuaLaporan
        .where(
          (l) => l.statusVerifikasi == StatusVerifikasiWilayah.terverifikasi,
        )
        .length;
    final selesai = state.semuaLaporan
        .where((l) => l.statusVerifikasi == StatusVerifikasiWilayah.selesai)
        .length;
    final aktif =
        state.klasterList
            .where((k) => k.statusVerifikasi != StatusVerifikasiWilayah.selesai)
            .toList()
          ..sort((a, b) => b.totalLaporan.compareTo(a.totalLaporan));

    // Agregasi kebutuhan darurat dominan dari klaster aktif
    final rekapKebutuhan = <String, int>{};
    for (final k in aktif) {
      for (final need in k.kebutuhanDominan) {
        rekapKebutuhan[need] = (rekapKebutuhan[need] ?? 0) + 1;
      }
    }
    final daftarKebutuhan = rekapKebutuhan.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final metrik = [
      (
        'Menunggu Verifikasi',
        menunggu,
        AdminMenuTab.laporanIndividu,
        Icons.pending_actions_outlined,
        'Perlu tindakan segera',
      ),
      (
        'Total Laporan',
        state.semuaLaporan.length,
        AdminMenuTab.laporanIndividu,
        Icons.assignment_outlined,
        'Akumulasi seluruh warga',
      ),
      (
        'Wilayah Aktif',
        aktif.length,
        AdminMenuTab.klasterWilayah,
        Icons.location_on_outlined,
        'Area terdampak banjir',
      ),
      (
        'Siaran Aktif',
        state.pesanSiaga.length,
        AdminMenuTab.pusatOperasional,
        Icons.campaign_outlined,
        'Sedang mengudara',
      ),
    ];

    // Palet akses cepat Beranda warga; urutan metrik tetap sama.
    const palet = [
      (Color(0xFFFFEEEE), Color(0xFFFECACA), Color(0xFFB91C1C)),
      (Color(0xFFD6F0FF), Color(0xFFBAE6FD), Color(0xFF0369A1)),
      (Color(0xFFEDE9FE), Color(0xFFDDD6FE), Color(0xFF5145CD)),
      (Color(0xFFDCF0E2), Color(0xFFBBE5C9), Color(0xFF15803D)),
    ];

    return HalamanAdmin(
      children: [
        const JudulAdmin(
          'Dashboard',
          description: 'Ringkasan laporan dan tinjauan wilayah.',
        ),
        // Strip status kesiagaan komando operasional
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD97706),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    'Status: ${state.labelSiagaKota}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const Wrap(
                spacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  Text(
                    'Pusdalops BPBD Kota Padang',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 4 Kartu KPI Metrik
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
                for (final (i, m) in metrik.indexed)
                  SizedBox(
                    width: (constraints.maxWidth - (count - 1) * 16) / count,
                    child: Material(
                      color: palet[i].$1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                        side: BorderSide(color: palet[i].$2),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => onNavigateToTab(m.$3),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(m.$4, size: 22, color: palet[i].$3),
                              const SizedBox(height: 10),
                              Text(
                                m.$1,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${m.$2}',
                                style: TextStyle(
                                  color: palet[i].$3,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                m.$5,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: palet[i].$3.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
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
        // Layout 2-kolom responsif: Wilayah Prioritas (Kiri) & Komando Logistik (Kanan)
        LayoutBuilder(
          builder: (context, constraints) {
            final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final isDesktop = constraints.maxWidth / scale >= 960;

            final kolomKiri = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    const Text(
                      'Wilayah dengan Laporan Terbanyak',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          onNavigateToTab(AdminMenuTab.klasterWilayah),
                      child: const Text('Lihat Semua Wilayah'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (aktif.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('Tidak ada wilayah aktif.'),
                  ),
                for (final k in aktif.take(3))
                  KartuKlasterAdmin(klaster: k, state: state),
              ],
            );

            final kolomKanan = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Panel 1: Distribusi Status Laporan
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribusi Status Laporan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Total ${state.semuaLaporan.length} laporan warga masuk',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            height: 10,
                            child: Row(
                              children: [
                                if (menunggu > 0)
                                  Expanded(
                                    flex: menunggu,
                                    child: Container(
                                      color: const Color(0xFFDC2626),
                                    ),
                                  ),
                                if (terverifikasi > 0)
                                  Expanded(
                                    flex: terverifikasi,
                                    child: Container(
                                      color: const Color(0xFF2563EB),
                                    ),
                                  ),
                                if (selesai > 0)
                                  Expanded(
                                    flex: selesai,
                                    child: Container(
                                      color: const Color(0xFF16A34A),
                                    ),
                                  ),
                                if (state.semuaLaporan.isEmpty)
                                  Expanded(
                                    child: Container(
                                      color: const Color(0xFFCBD5E1),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _IndikatorStatus(
                              warna: const Color(0xFFDC2626),
                              label: 'Belum Ditinjau: $menunggu',
                            ),
                            _IndikatorStatus(
                              warna: const Color(0xFF2563EB),
                              label: 'Terverifikasi: $terverifikasi',
                            ),
                            _IndikatorStatus(
                              warna: const Color(0xFF16A34A),
                              label: 'Selesai: $selesai',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Panel 2: Agregasi Kebutuhan Darurat
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kebutuhan Darurat Lapangan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Akumulasi permintaan warga dari klaster aktif',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (daftarKebutuhan.isEmpty)
                          const Text(
                            'Tidak ada logistik darurat yang dibutuhkan saat ini.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final item in daftarKebutuhan)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Wrap(
                                    spacing: 6,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.emergency_outlined,
                                        size: 15,
                                        color: Color(0xFF1D4ED8),
                                      ),
                                      Text(
                                        '${item.key} (${item.value} wilayah)',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Panel 3: Siaran Peringatan Mengudara
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            const Text(
                              'Siaran Mengudara',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            TextButton(
                              onPressed: () => onNavigateToTab(
                                AdminMenuTab.pusatOperasional,
                              ),
                              child: const Text('Kelola'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (state.pesanSiaga.isEmpty)
                          const Text(
                            'Belum ada siaran darurat aktif.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          )
                        else
                          for (final pesan in state.pesanSiaga.take(2))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      alignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: pesan.badgeBackground,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            pesan.badgeLabel,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: pesan.badgeTextColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          pesan.timestamp,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      pesan.title,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F172A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Panel 4: Aksi Cepat Operasional
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Aksi Cepat Operasional',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => onNavigateToTab(
                                AdminMenuTab.pusatOperasional,
                              ),
                              icon: const Icon(
                                Icons.campaign_outlined,
                                size: 18,
                              ),
                              label: const Text('Kirim Siaran Baru'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => onNavigateToTab(
                                AdminMenuTab.laporanIndividu,
                              ),
                              icon: const Icon(
                                Icons.format_list_bulleted_outlined,
                                size: 18,
                              ),
                              label: const Text('Buka Semua Laporan'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: kolomKiri),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: kolomKanan),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                kolomKiri,
                const SizedBox(height: 24),
                kolomKanan,
              ],
            );
          },
        ),
      ],
    );
  }
}

class _IndikatorStatus extends StatelessWidget {
  const _IndikatorStatus({required this.warna, required this.label});
  final Color warna;
  final String label;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
      ),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF475569),
        ),
      ),
    ],
  );
}
