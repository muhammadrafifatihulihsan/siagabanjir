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
import 'tema_admin.dart';
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
    _state.sinkronkanDariBackend();
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
                  MaterialPageRoute<void>(
                    builder: (_) => const KerangkaWarga(),
                  ),
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
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
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
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectTab(AdminMenuTab tab) => setState(() => _currentTab = tab);

  Widget _body() => IndexedStack(
    index: _currentTab.index,
    children: [
      TabDashboardRingkasan(state: _state, onNavigateToTab: _selectTab),
      TabWilayahKlasterAi(state: _state),
      TabLaporanIndividu(state: _state),
      TabPusatOperasional(state: _state),
      TabPengaturanProfil(state: _state),
    ],
  );

  @override
  Widget build(BuildContext context) => Theme(
    data: temaAdmin(Theme.of(context)),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final sidebarVisible = constraints.maxWidth / scale >= 1100;
        final sidebar = AdminSidebar(
          selectedTab: _currentTab,
          state: _state,
          onLogout: _handleLogout,
          onSelectTab: (tab) {
            if (!sidebarVisible) Navigator.of(context).pop();
            _selectTab(tab);
          },
        );
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          drawer: sidebarVisible
              ? null
              : Drawer(child: SafeArea(child: sidebar)),
          body: Row(
            children: [
              if (sidebarVisible) sidebar,
              Expanded(
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 64),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (!sidebarVisible)
                            Builder(
                              builder: (context) => IconButton(
                                tooltip: 'Buka navigasi',
                                icon: const Icon(Icons.menu),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                              ),
                            ),
                          const Expanded(
                            child: Text(
                              'Portal Admin',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _switchToCitizenMode,
                            icon: const Icon(
                              Icons.phone_android_outlined,
                              size: 20,
                            ),
                            label: const Text('Mode Warga'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: _body()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
