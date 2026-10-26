import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/region_monitor_data.dart';
import 'widgets/monitor_featured_card.dart';
import 'widgets/monitor_header.dart';
import 'widgets/monitor_infrastructure_card.dart';
import 'widgets/monitor_river_posts_section.dart';

/// Halaman Pantau Wilayah sesuai desain spesifikasi monitor_public.svg.
/// Menampilkan data pemantauan publik:
/// 1. Status tinggi air sungai utama yang disorot (Sungai Batang Kuranji) dengan
///    indikator batas normal, waspada, bahaya, dan sisa jarak ke batas luapan tanggul.
/// 2. Daftar pos pantau sungai lainnya (Sungai Lubuk Kilangan, Sungai Batang Arau).
/// 3. Status kesiapan operasional infrastruktur (Pintu Air dan Pompa Air Bergerak).
/// 4. Navigasi bawah terintegrasi (Beranda, Lapor, Riwayat, Profil).
class RegionMonitorScreen extends StatelessWidget {
  const RegionMonitorScreen({
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
  final FeaturedRiverStatus featuredRiver;
  final List<RiverPost> riverPosts;
  final List<InfrastructureItem> infrastructureItems;

  void _onNavigationSelect(BuildContext context, CitizenDestination destination) {
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
              MonitorHeader(
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
                      MonitorFeaturedCard(featuredRiver: featuredRiver),
                      const SizedBox(height: 20),

                      // Bagian daftar pos pantau sungai
                      MonitorRiverPostsSection(riverPosts: riverPosts),
                      const SizedBox(height: 16),

                      // Kartu status infrastruktur pompa & pintu air
                      MonitorInfrastructureCard(items: infrastructureItems),
                    ],
                  ),
                ),
              ),

              // Navigasi bawah bersama
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
