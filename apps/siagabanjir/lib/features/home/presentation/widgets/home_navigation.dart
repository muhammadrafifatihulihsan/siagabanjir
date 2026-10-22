import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../home_action.dart';
import 'home_icon.dart';

class HomeNavigation extends StatelessWidget {
  const HomeNavigation({super.key, required this.onOpen, required this.onHome});

  final ValueChanged<HomeAction> onOpen;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) => Padding(
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
          _item('Beranda', 'home', onHome, selected: true),
          _item('Lapor', 'report', () => onOpen(HomeAction.report)),
          _item('Riwayat', 'history', () => onOpen(HomeAction.history)),
          _item('Profil', 'profile', () => onOpen(HomeAction.profile)),
        ],
      ),
    ),
  );

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
  );
}
