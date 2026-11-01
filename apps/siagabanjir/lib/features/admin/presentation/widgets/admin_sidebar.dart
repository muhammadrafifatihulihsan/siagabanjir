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
  Widget build(BuildContext context) => Container(
    width: 240,
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(Icons.water_drop_outlined, color: Color(0xFF2563EB)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'SiagaBanjir',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _menu(
                AdminMenuTab.dashboard,
                Icons.dashboard_outlined,
                'Dashboard',
              ),
              _menu(
                AdminMenuTab.klasterWilayah,
                Icons.map_outlined,
                'Klaster Wilayah',
              ),
              _menu(
                AdminMenuTab.laporanIndividu,
                Icons.assignment_outlined,
                'Laporan Warga',
              ),
              _menu(
                AdminMenuTab.pusatOperasional,
                Icons.tune_outlined,
                'Pusat Aksi',
              ),
              _menu(
                AdminMenuTab.pengaturanProfil,
                Icons.person_outline,
                'Profil',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                state.profilAdmin.nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Keluar'),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _menu(AdminMenuTab tab, IconData icon, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Material(
      color: Colors.transparent,
      child: ListTile(
        selected: selectedTab == tab,
        selectedTileColor: const Color(0xFFE1EDFF),
        selectedColor: const Color(0xFF1D4ED8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon, size: 24),
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onTap: () => onSelectTab(tab),
      ),
    ),
  );
}
