import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import 'models/data_pantau_wilayah.dart';
import 'widgets/kartu_sorotan_pantau.dart';
import 'widgets/header_pantau.dart';
import 'widgets/kartu_infrastruktur_pantau.dart';
import 'widgets/bagian_pos_sungai.dart';

/// Halaman Pantau Wilayah sesuai desain spesifikasi monitor_public.svg.
/// Menampilkan data pemantauan publik:
/// 1. Status tinggi air sungai utama yang disorot (Sungai Batang Kuranji) dengan
///    indikator batas normal, waspada, bahaya, dan sisa jarak ke batas luapan tanggul.
/// 2. Daftar pos pantau sungai lainnya (Sungai Lubuk Kilangan, Sungai Batang Arau).
/// 3. Status kesiapan operasional infrastruktur (Pintu Air dan Pompa Air Bergerak).
/// 4. Navigasi bawah terintegrasi (Beranda, Lapor, Riwayat, Profil).
class LayarPantauWilayah extends StatelessWidget {
  const LayarPantauWilayah({
    super.key,
    this.onHome,
    this.onReport,
    this.onHistory,
    this.onProfile,
    this.featuredRiver = kDefaultFeaturedRiver,
    this.riverPosts = kDefaultRiverPosts,
    this.infrastructureItems = kDefaultInfrastructureItems,
  });

  final VoidCallback? onHome;
  final VoidCallback? onReport;
  final VoidCallback? onHistory;
  final VoidCallback? onProfile;
  final StatusSungaiSorotan featuredRiver;
  final List<PosSungai> riverPosts;
  final List<ItemInfrastruktur> infrastructureItems;

  void _onNavigationSelect(
    BuildContext context,
    CitizenDestination destination,
  ) {
    switch (destination) {
      case CitizenDestination.home:
        if (onHome != null) {
          onHome!();
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      case CitizenDestination.report:
        onReport?.call();
      case CitizenDestination.history:
        onHistory?.call();
      case CitizenDestination.profile:
        onProfile?.call();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: SiagaTheme.background,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // Header atas dengan tombol kembali dan judul halaman
              HeaderPantau(
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else if (onHome != null) {
                    onHome!();
                  }
                },
              ),

              // Area konten pemantauan yang dapat di-scroll
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('region-monitor-scroll'),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Kartu utama pemantauan tinggi air sungai yang disorot
                      KartuSorotanPantau(featuredRiver: featuredRiver),
                      const SizedBox(height: 20),

                      // Bagian daftar pos pantau sungai
                      BagianPosSungai(riverPosts: riverPosts),
                      const SizedBox(height: 16),

                      // Kartu status infrastruktur pompa & pintu air
                      KartuInfrastrukturPantau(items: infrastructureItems),
                    ],
                  ),
                ),
              ),

              // Navigasi bawah bersama
              if (!LingkupNavigasi.aktif(context))
                CitizenNavigation(
                  selected: CitizenDestination.home,
                  onSelect: (dest) => _onNavigationSelect(context, dest),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
