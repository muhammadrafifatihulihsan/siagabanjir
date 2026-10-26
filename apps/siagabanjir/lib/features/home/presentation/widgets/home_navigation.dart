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
  Widget build(BuildContext context) => CitizenNavigation(
    selected: currentAction == HomeAction.profile
        ? CitizenDestination.profile
        : CitizenDestination.home,
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
  );
}
