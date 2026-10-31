import 'package:flutter/material.dart';

import '../../domain/state_admin_siaga.dart';

enum AdminMenuTab {
  dashboard,
  klasterWilayah,
  laporanIndividu,
  pusatOperasional,
  pengaturanProfil,
}

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.selectedTab,
    required this.onSelectTab,
    required this.onLogout,
    required this.state,
  });

  final AdminMenuTab selectedTab;
  final ValueChanged<AdminMenuTab> onSelectTab;
  final VoidCallback onLogout;
  final StateAdminSiaga state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Brand SiagaBanjir Admin Portal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.water_drop_rounded,
                      color: Color(0xFF2563EB),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SiagaBanjir',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.admin_panel_settings_outlined,
                            size: 13,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'ADMIN WEB',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Menu Navigasi Utama
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(
                  tab: AdminMenuTab.dashboard,
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  tab: AdminMenuTab.klasterWilayah,
                  icon: Icons.hub_outlined,
                  label: 'Klaster Wilayah',
                  badgeText: '${state.klasterList.length}',
                  badgeColor: const Color(0xFFFEF3C7),
                  badgeTextColor: const Color(0xFFB45309),
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  tab: AdminMenuTab.laporanIndividu,
                  icon: Icons.assignment_outlined,
                  label: 'Laporan Warga',
                  badgeText: '${state.semuaLaporan.length}',
                  badgeColor: const Color(0xFFF1F5F9),
                  badgeTextColor: const Color(0xFF475569),
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  tab: AdminMenuTab.pusatOperasional,
                  icon: Icons.tune_rounded,
                  label: 'Pusat Aksi',
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    'PENGATURAN',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                _buildMenuItem(
                  tab: AdminMenuTab.pengaturanProfil,
                  icon: Icons.manage_accounts_outlined,
                  label: 'Profil',
                ),
              ],
            ),
          ),

          // Footer Sidebar: Admin Profile & Logout
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF2563EB),
                        child: Text(
                          state.profilAdmin.nama.isNotEmpty
                              ? state.profilAdmin.nama[0]
                              : 'A',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.profilAdmin.nama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const Text(
                              'PUSDALOPS BPBD',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: onLogout,
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: const Text(
                        'Keluar',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required AdminMenuTab tab,
    required IconData icon,
    required String label,
    String? sublabel,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    final isSelected = selectedTab == tab;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelectTab(tab),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: const Color(0xFFBFDBFE))
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF64748B),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF1D4ED8)
                            : const Color(0xFF334155),
                      ),
                    ),
                    if (sublabel != null)
                      Text(
                        sublabel,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                  ],
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor ?? const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: badgeTextColor ?? const Color(0xFF475569),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
