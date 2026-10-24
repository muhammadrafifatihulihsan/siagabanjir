import 'package:flutter/material.dart';

import '../theme/siaga_theme.dart';
import 'local_icon.dart';

// Destinasi UI bersama tanpa dependensi ke fitur atau data akun.
enum CitizenDestination { home, report, history, profile }

// Navbar yang sama menjaga ikon, jarak, dan perilaku kedua halaman konsisten.
class CitizenNavigation extends StatelessWidget {
  const CitizenNavigation({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final CitizenDestination selected;
  final ValueChanged<CitizenDestination> onSelect;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: SiagaTheme.navigationBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _item(CitizenDestination.home, 'Beranda', 'home'),
          _item(CitizenDestination.report, 'Lapor', 'report'),
          _item(CitizenDestination.history, 'Riwayat', 'history'),
          _item(CitizenDestination.profile, 'Profil', 'profile'),
        ],
      ),
    ),
  );

  // Label tetap terlihat; semantics menyampaikan destinasi yang sedang aktif.
  Widget _item(CitizenDestination destination, String label, String icon) {
    final active = selected == destination;
    return Expanded(
      child: Semantics(
        selected: active,
        button: true,
        child: Material(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onSelect(destination),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocalIcon(
                    icon,
                    color: active ? SiagaTheme.blue : SiagaTheme.mutedOnTint,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: active ? SiagaTheme.blue : SiagaTheme.mutedOnTint,
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
}
