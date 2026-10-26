import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/contact_entry.dart';

// Tab filter kategori kontak — pill horizontal sesuai pola messages_inbox.
class ContactsFilterTabs extends StatelessWidget {
  const ContactsFilterTabs({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.counts,
  });

  // null = Semua
  final ContactCategory? selected;
  final ValueChanged<ContactCategory?> onSelect;
  final Map<ContactCategory?, int> counts;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
    child: Row(
      children: [
        _pill(context, null, 'Semua'),
        const SizedBox(width: 8),
        _pill(context, ContactCategory.emergency, 'Darurat'),
        const SizedBox(width: 8),
        _pill(context, ContactCategory.health, 'Kesehatan'),
        const SizedBox(width: 8),
        _pill(context, ContactCategory.infrastructure, 'Infrastruktur'),
        const SizedBox(width: 8),
        _pill(context, ContactCategory.posko, 'Posko'),
      ],
    ),
  );

  Widget _pill(BuildContext context, ContactCategory? cat, String label) {
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
                  fontSize: 13,
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