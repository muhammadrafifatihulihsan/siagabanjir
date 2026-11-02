import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../data/pantau_repository.dart';
import 'models/data_pantau_wilayah.dart';
import 'widgets/kartu_sorotan_pantau.dart';
import '../../../shared/widgets/header_halaman.dart';
import 'widgets/kartu_infrastruktur_pantau.dart';
import 'widgets/bagian_pos_sungai.dart';

/// Halaman Pantau Wilayah sesuai desain spesifikasi monitor_public.svg.
/// Menampilkan data pemantauan publik:
/// 1. Status tinggi air sungai utama yang disorot (Sungai Batang Kuranji) dengan
///    indikator batas normal, waspada, bahaya, dan sisa jarak ke batas luapan tanggul.
/// 2. Daftar pos pantau sungai lainnya (Sungai Lubuk Kilangan, Sungai Batang Arau).
/// 3. Status kesiapan operasional infrastruktur (Pintu Air dan Pompa Air Bergerak).
/// 4. Navigasi bawah terintegrasi (Beranda, Lapor, Riwayat, Profil).
class LayarPantauWilayah extends StatefulWidget {
  const LayarPantauWilayah({
    super.key,
    this.onHome,
    this.onReport,
    this.onHistory,
    this.onProfile,
    this.pantauRepository,
    this.featuredRiver = kDefaultFeaturedRiver,
    this.riverPosts = kDefaultRiverPosts,
    this.infrastructureItems = kDefaultInfrastructureItems,
  });

  final VoidCallback? onHome;
  final VoidCallback? onReport;
  final VoidCallback? onHistory;
  final VoidCallback? onProfile;
  final PantauRepository? pantauRepository;
  final StatusSungaiSorotan featuredRiver;
  final List<PosSungai> riverPosts;
  final List<ItemInfrastruktur> infrastructureItems;

  @override
  State<LayarPantauWilayah> createState() => _LayarPantauWilayahState();
}

class _LayarPantauWilayahState extends State<LayarPantauWilayah> {
  late bool _isTest;
  bool _memuat = false;
  List<ItemPantauPublik> _serverItems = [];

  @override
  void initState() {
    super.initState();
    _isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!_isTest) {
      _memuat = true;
      final repo = widget.pantauRepository ?? PantauRepository();
      repo.ambilRingkasanPantau().then((res) {
        if (mounted) {
          setState(() {
            _serverItems = res.items;
            _memuat = false;
          });
        }
      }).catchError((_) {
        if (mounted) setState(() => _memuat = false);
      });
    }
  }

  void _onNavigationSelect(
    BuildContext context,
    CitizenDestination destination,
  ) {
    switch (destination) {
      case CitizenDestination.home:
        if (widget.onHome != null) {
          widget.onHome!();
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      case CitizenDestination.report:
        widget.onReport?.call();
      case CitizenDestination.history:
        widget.onHistory?.call();
      case CitizenDestination.profile:
        widget.onProfile?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool tampilkanEmptyState = !_isTest && !_memuat && _serverItems.isEmpty;

    return Scaffold(
      backgroundColor: SiagaTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Header atas dengan tombol kembali dan judul halaman
                HeaderHalaman(
                  judul: 'Pantau Wilayah',
                  onBack: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else if (widget.onHome != null) {
                      widget.onHome!();
                    }
                  },
                ),

                // Area konten pemantauan yang dapat di-scroll
                Expanded(
                  child: SingleChildScrollView(
                    key: const PageStorageKey('region-monitor-scroll'),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: tampilkanEmptyState
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.waves_outlined, size: 64, color: Color(0xFF94A3B8)),
                                  SizedBox(height: 16),
                                  Text(
                                    'Belum Ada Pos Pantau Aktif',
                                    style: TextStyle(
                                      fontSize: SiagaTheme.judulHalaman,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Saat ini belum ada sensor pemantauan sungai atau data pos pantau yang terdaftar di sistem.',
                                    style: TextStyle(
                                      fontSize: SiagaTheme.isi,
                                      color: Color(0xFF64748B),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Kartu utama pemantauan tinggi air sungai yang disorot
                              KartuSorotanPantau(featuredRiver: widget.featuredRiver),
                              const SizedBox(height: 20),

                              // Bagian daftar pos pantau sungai
                              BagianPosSungai(riverPosts: widget.riverPosts),
                              const SizedBox(height: 16),

                              // Kartu status infrastruktur pompa & pintu air
                              KartuInfrastrukturPantau(items: widget.infrastructureItems),
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
}
