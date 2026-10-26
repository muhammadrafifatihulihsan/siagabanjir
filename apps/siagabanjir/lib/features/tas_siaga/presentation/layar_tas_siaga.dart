import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/widgets/citizen_navigation.dart';
import 'models/barang_tas_siaga.dart';
import 'widgets/kartu_kategori_tas_siaga.dart';
import 'widgets/header_tas_siaga.dart';
import 'widgets/banner_info_tas_siaga.dart';
import 'widgets/kartu_ringkasan_tas_siaga.dart';

// Layar Checklist Tas Siaga Bencana sesuai desain referensi emergency_bag_checklist.svg.
class LayarTasSiaga extends StatefulWidget {
  const LayarTasSiaga({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<LayarTasSiaga> createState() => _LayarTasSiagaState();
}

class _LayarTasSiagaState extends State<LayarTasSiaga> {
  late List<BarangTasSiaga> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(kDefaultEmergencyBagItems);
  }

  void _toggleItem(String id) {
    setState(() {
      _items = [
        for (final item in _items)
          if (item.id == id)
            item.copyWith(isChecked: !item.isChecked)
          else
            item,
      ];
    });
  }

  int get _checkedCount => _items.where((i) => i.isChecked).length;
  int get _totalCount => _items.length;

  List<BarangTasSiaga> _itemsForCategory(KategoriTasSiaga category) =>
      _items.where((i) => i.category == category).toList();

  void _onNavigationSelect(CitizenDestination destination) {
    switch (destination) {
      case CitizenDestination.home:
        Navigator.pop(context);
      case CitizenDestination.report:
        widget.onReport();
      case CitizenDestination.history:
        widget.onHistory();
      case CitizenDestination.profile:
        widget.onProfile();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              HeaderTasSiaga(onBack: () => Navigator.pop(context)),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('emergency-bag-scroll'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KartuRingkasanTasSiaga(
                        checkedCount: _checkedCount,
                        totalCount: _totalCount,
                      ),
                      const SizedBox(height: 16),
                      for (final category in KategoriTasSiaga.values) ...[
                        KartuKategoriTasSiaga(
                          category: category,
                          items: _itemsForCategory(category),
                          onToggleItem: _toggleItem,
                        ),
                        const SizedBox(height: 16),
                      ],
                      const BannerInfoTasSiaga(),
                    ],
                  ),
                ),
              ),
              if (!LingkupNavigasi.aktif(context))
                CitizenNavigation(
                  selected: CitizenDestination.home,
                  onSelect: _onNavigationSelect,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
