import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../models/entri_kontak.dart';

// Tab filter kategori kontak — pill horizontal sesuai pola messages_inbox.
class TabFilterKontak extends StatelessWidget {
  const TabFilterKontak({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.counts,
  });

  // null = Semua
  final KategoriKontak? selected;
  final ValueChanged<KategoriKontak?> onSelect;
  final Map<KategoriKontak?, int> counts;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(top: 4, bottom: 12),
    child: Row(
      children: [
        _pill(context, null, 'Semua'),
        const SizedBox(width: 8),
        _pill(context, KategoriKontak.emergency, 'Darurat'),
        const SizedBox(width: 8),
        _pill(context, KategoriKontak.health, 'Kesehatan'),
        const SizedBox(width: 8),
        _pill(context, KategoriKontak.infrastructure, 'Infrastruktur'),
        const SizedBox(width: 8),
      ],
    ),
  );

  Widget _pill(BuildContext context, KategoriKontak? cat, String label) {
    final active = selected == cat;
    final count = counts[cat] ?? 0;
    return Semantics(
      selected: active,
      button: true,
      label: '$label, $count kontak',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        child: Material(
          color: active ? SiagaTheme.ink : Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => onSelect(cat),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: active
                  ? null
                  : BoxDecoration(
                      border: Border.all(color: SiagaTheme.border),
                      borderRadius: BorderRadius.circular(20),
                    ),
              child: Text(
                '$label ($count)',
                style: TextStyle(
                  fontSize: SiagaTheme.isi,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
