import 'package:flutter/material.dart';

import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/emergency_bag_item.dart';
import 'widgets/emergency_bag_category_card.dart';
import 'widgets/emergency_bag_header.dart';
import 'widgets/emergency_bag_info_banner.dart';
import 'widgets/emergency_bag_summary_card.dart';

// Layar Checklist Tas Siaga Bencana sesuai desain referensi emergency_bag_checklist.svg.
class EmergencyBagScreen extends StatefulWidget {
  const EmergencyBagScreen({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<EmergencyBagScreen> createState() => _EmergencyBagScreenState();
}

class _EmergencyBagScreenState extends State<EmergencyBagScreen> {
  late List<EmergencyBagItem> _items;

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

  List<EmergencyBagItem> _itemsForCategory(EmergencyBagCategory category) =>
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
              EmergencyBagHeader(
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('emergency-bag-scroll'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EmergencyBagSummaryCard(
                        checkedCount: _checkedCount,
                        totalCount: _totalCount,
                      ),
                      const SizedBox(height: 16),
                      for (final category in EmergencyBagCategory.values) ...[
                        EmergencyBagCategoryCard(
                          category: category,
                          items: _itemsForCategory(category),
                          onToggleItem: _toggleItem,
                        ),
                        const SizedBox(height: 16),
                      ],
                      const EmergencyBagInfoBanner(),
                    ],
                  ),
                ),
              ),
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
