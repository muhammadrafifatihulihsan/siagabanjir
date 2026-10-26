import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/user_profile.dart';

class EmergencyContactsSection extends StatelessWidget {
  const EmergencyContactsSection({
    super.key,
    required this.contacts,
    required this.onAddContact,
    required this.onCallContact,
  });

  final List<EmergencyContact> contacts;
  final VoidCallback onAddContact;
  final ValueChanged<EmergencyContact> onCallContact;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Kontak Darurat Keluarga (SOS)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: SiagaTheme.ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onAddContact,
            style: TextButton.styleFrom(
              foregroundColor: SiagaTheme.blue,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: const Size(48, 40),
            ),
            child: const Text(
              '+ Tambah',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: SiagaTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            for (int i = 0; i < contacts.length; i++) ...[
              if (i > 0)
                const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 64),
              _ContactRow(
                contact: contacts[i],
                isFirst: i == 0,
                onCall: () => onCallContact(contacts[i]),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.contact,
    required this.isFirst,
    required this.onCall,
  });

  final EmergencyContact contact;
  final bool isFirst;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final avatarBg = isFirst
        ? const Color(0xFFFEE2E2)
        : const Color(0xFFDBEAFE);
    final avatarFg = isFirst
        ? const Color(0xFFDC2626)
        : const Color(0xFF2563EB);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarBg,
            child: Text(
              contact.initials,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: avatarFg,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: SiagaTheme.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${contact.relation} • ${contact.phone}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SiagaTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: const Color(0xFFF0FDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFBBF7D0)),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onCall,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
