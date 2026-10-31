import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../../app/kerangka_warga.dart';
import '../../autentikasi/domain/peran_pengguna.dart';
import '../../autentikasi/presentation/layar_masuk.dart';
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

  void _switchToCitizenMode() {
    if (widget.onSwitchToCitizenMode != null) {
      widget.onSwitchToCitizenMode!();
    } else {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const KerangkaWarga()),
        (_) => false,
      );
    }
  }

  void _performLogout() {
    if (widget.onLogout != null) {
      widget.onLogout!();
    } else {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (ctx) => LayarMasuk(
            initialRole: PeranPengguna.admin,
            onLoginWithRole: (user, role) {
              if (role == PeranPengguna.admin) {
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => KerangkaAdminWeb(
                      onLogout: _performLogout,
                      onSwitchToCitizenMode: _switchToCitizenMode,
                    ),
                  ),
                  (_) => false,
                );
              } else {
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (_) => const KerangkaWarga()),
                  (_) => false,
                );
              }
            },
            onLoginSuccess: (_) => Navigator.of(ctx).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const KerangkaWarga()),
              (_) => false,
            ),
          ),
        ),
        (_) => false,
      );
    }
  }

  void _handleLogout() {
    showDialog<void>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari Portal Admin?',
          style: TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _performLogout();
            },
            child: const Text(
              'Keluar',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _getTabTitle(AdminMenuTab tab) {
    switch (tab) {
      case AdminMenuTab.dashboard:
        return 'Dashboard Ringkasan';
      case AdminMenuTab.klasterWilayah:
        return 'Klaster Wilayah';
      case AdminMenuTab.laporanIndividu:
        return 'Laporan Warga';
      case AdminMenuTab.pusatOperasional:
        return 'Pusat Aksi';
      case AdminMenuTab.pengaturanProfil:
        return 'Profil Admin';
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
                          fontFamily: 'Inter',
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
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFB45309).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFB45309),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Kota Padang: ${_state.labelSiagaKota}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Tombol Beralih ke Tampilan Warga
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
                        onPressed: _switchToCitizenMode,
                        icon: const Icon(Icons.phone_android_rounded, size: 16),
                        label: const Text(
                          'Mode Warga',
                          style: TextStyle(
                            fontFamily: 'Inter',
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
