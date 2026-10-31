import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../domain/state_admin_siaga.dart';
import 'tabs/tab_dashboard_ringkasan.dart';
import 'tabs/tab_laporan_individu.dart';
import 'tabs/tab_pengaturan_profil.dart';
import 'tabs/tab_pusat_operasional.dart';
import 'tabs/tab_wilayah_klaster_ai.dart';
import 'widgets/admin_sidebar.dart';

/// Kerangka Dashboard Web Admin SiagaBanjir untuk lingkungan desktop browser.
class KerangkaAdminWeb extends StatefulWidget {
  const KerangkaAdminWeb({
    super.key,
    this.onLogout,
    this.onSwitchToCitizenMode,
  });

  final VoidCallback? onLogout;
  final VoidCallback? onSwitchToCitizenMode;

  @override
  State<KerangkaAdminWeb> createState() => _KerangkaAdminWebState();
}

class _KerangkaAdminWebState extends State<KerangkaAdminWeb> {
  AdminMenuTab _currentTab = AdminMenuTab.dashboard;
  final _state = StateAdminSiaga.instance;

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _handleLogout() {
    showDialog<void>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Konfirmasi Keluar Sesi Admin'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari Portal Pusdalops Admin? Anda dapat masuk kembali dengan peran Petugas atau Warga.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onLogout?.call();
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  String _getTabTitle(AdminMenuTab tab) {
    switch (tab) {
      case AdminMenuTab.dashboard:
        return 'Dashboard Ringkasan Operasional';
      case AdminMenuTab.klasterWilayah:
        return 'Wilayah Laporan Terbanyak (Klaster AI)';
      case AdminMenuTab.laporanIndividu:
        return 'Daftar Laporan Warga Per-Individu';
      case AdminMenuTab.pusatOperasional:
        return 'Pusat Aksi & Kontrol Operasional';
      case AdminMenuTab.pengaturanProfil:
        return 'Pengaturan Profil Petugas BPBD';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // 1. Sidebar Kiri Tetap (260 px)
          AdminSidebar(
            selectedTab: _currentTab,
            onSelectTab: (tab) => setState(() => _currentTab = tab),
            onLogout: _handleLogout,
            state: _state,
          ),

          // 2. Main Content Area di Kanan
          Expanded(
            child: Column(
              children: [
                // Top App Bar Web
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Breadcrumb Judul Tab Aktif
                      Text(
                        _getTabTitle(_currentTab),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),

                      // Chip Status Siaga Padang
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _state.sungaiSorotan.status.badgeBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _state.sungaiSorotan.status.badgeForeground.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _state.sungaiSorotan.status.badgeForeground,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Kota Padang: ${_state.sungaiSorotan.statusLabel}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _state.sungaiSorotan.status.badgeForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Tombol Beralih ke Tampilan Warga (Sangat berguna saat demo)
                      if (widget.onSwitchToCitizenMode != null)
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563EB),
                            side: const BorderSide(color: Color(0xFFBFDBFE)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onPressed: widget.onSwitchToCitizenMode,
                          icon: const Icon(Icons.phone_android_rounded, size: 16),
                          label: const Text(
                            'Mode Tampilan Warga',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Dynamic Body Content Pane
                Expanded(
                  child: switch (_currentTab) {
                    AdminMenuTab.dashboard => TabDashboardRingkasan(
                        state: _state,
                        onNavigateToTab: (t) => setState(() => _currentTab = t),
                      ),
                    AdminMenuTab.klasterWilayah => TabWilayahKlasterAi(
                        state: _state,
                      ),
                    AdminMenuTab.laporanIndividu => TabLaporanIndividu(
                        state: _state,
                      ),
                    AdminMenuTab.pusatOperasional => TabPusatOperasional(
                        state: _state,
                      ),
                    AdminMenuTab.pengaturanProfil => TabPengaturanProfil(
                        state: _state,
                      ),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
