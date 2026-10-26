import 'package:flutter/material.dart';

import '../../../../shared/widgets/citizen_navigation.dart';
import '../home_action.dart';

// Adapter home menerjemahkan destinasi bersama ke aksi fitur yang sudah tersedia.
class HomeNavigation extends StatelessWidget {
  const HomeNavigation({
    super.key,
    required this.onOpen,
    required this.onHome,
    this.currentAction,
  });

  final ValueChanged<HomeAction> onOpen;
  final VoidCallback onHome;
  final HomeAction? currentAction;

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    final isProfile = currentAction == HomeAction.profile;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFE1EDFF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item(
              'Beranda',
              'home',
              onHome,
              selected: !isProfile,
            ),
            _item(
              'Lapor',
              'report',
              () => onOpen(HomeAction.report),
            ),
            _item(
              'Riwayat',
              'history',
              () => onOpen(HomeAction.history),
            ),
            _item(
              'Profil',
              'profile',
              () => onOpen(HomeAction.profile),
              selected: isProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    String label,
    String icon,
    VoidCallback onTap, {
    bool selected = false,
  }) => Expanded(
    child: Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HomeIcon(icon),
                const SizedBox(height: 5),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? SiagaTheme.blue : SiagaTheme.mutedOnTint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
=======
  Widget build(BuildContext context) => CitizenNavigation(
    selected: CitizenDestination.home,
    onSelect: (destination) {
      switch (destination) {
        case CitizenDestination.home:
          onHome();
        case CitizenDestination.report:
          onOpen(HomeAction.report);
        case CitizenDestination.history:
          onOpen(HomeAction.history);
        case CitizenDestination.profile:
          onOpen(HomeAction.profile);
      }
    },
>>>>>>> 74e0c57a1cb95a0ac90b91d61d52fa0f5698c652
  );
}
