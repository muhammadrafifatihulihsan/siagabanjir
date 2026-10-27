import 'package:flutter/material.dart';

import '../../../../shared/widgets/citizen_navigation.dart';
import '../aksi_beranda.dart';

// Adapter home menerjemahkan destinasi bersama ke aksi fitur yang sudah tersedia.
class NavigasiBeranda extends StatelessWidget {
  const NavigasiBeranda({
    super.key,
    required this.onOpen,
    required this.onHome,
    this.currentAction,
  });

  final ValueChanged<AksiBeranda> onOpen;
  final VoidCallback onHome;
  final AksiBeranda? currentAction;

  @override
  Widget build(BuildContext context) {
    final selected = switch (currentAction) {
      AksiBeranda.report => CitizenDestination.report,
      AksiBeranda.history => CitizenDestination.history,
      AksiBeranda.profile => CitizenDestination.profile,
      _ => CitizenDestination.home,
    };

    return CitizenNavigation(
      selected: selected,
      onSelect: (destination) {
        switch (destination) {
          case CitizenDestination.home:
            onHome();
          case CitizenDestination.report:
            onOpen(AksiBeranda.report);
          case CitizenDestination.history:
            onOpen(AksiBeranda.history);
          case CitizenDestination.profile:
            onOpen(AksiBeranda.profile);
        }
      },
    );
  }
}
