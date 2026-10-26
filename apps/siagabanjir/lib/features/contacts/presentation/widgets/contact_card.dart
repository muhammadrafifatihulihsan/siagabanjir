import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/contact_entry.dart';

// Kartu satu kontak umum dengan aksen garis, badge kategori, dan tombol salin nomor.
// Android dapat membuka dialer atas inisiatif pengguna; mockup tidak melakukan panggilan otomatis.
class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
    required this.onCopy,
  });

  final ContactEntry contact;
  final VoidCallback onCopy;

  Color get _categoryBadgeBg {
    switch (contact.category) {
      case ContactCategory.emergency:
        return const Color(0xFFFFEDED);
      case ContactCategory.health:
        return const Color(0xFFECFDF5);
      case ContactCategory.infrastructure:
        return const Color(0xFFEFF6FF);
      case ContactCategory.posko:
        return const Color(0xFFF5F3FF);
    }
  }

  Color get _categoryBadgeText {
    switch (contact.category) {
      case ContactCategory.emergency:
        return const Color(0xFFDC2626);
      case ContactCategory.health:
        return const Color(0xFF059669);
      case ContactCategory.infrastructure:
        return const Color(0xFF2563EB);
      case ContactCategory.posko:
        return const Color(0xFF7C3AED);
    }
  }

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label:
        '${contact.name}, ${contact.agency}, nomor ${contact.phone}',
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SiagaTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Aksen garis vertikal penanda kategori (4 px, seperti MessageCard).
            Container(
              width: 4,
              color: contact.accentColor ?? SiagaTheme.border,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris atas: badge kategori + nomor telepon.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _categoryBadgeBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            contact.category.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _categoryBadgeText,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Nomor telepon dan tombol salin.
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              contact.phone,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Semantics(
                              label: 'Salin nomor ${contact.phone}',
                              button: true,
                              child: InkWell(
                                onTap: onCopy,
                                borderRadius: BorderRadius.circular(8),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.copy_rounded,
                                    size: 16,
                                    color: SiagaTheme.muted,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Nama instansi sumber.
                    Text(
                      contact.agency,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Nama kontak / unit.
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: SiagaTheme.ink,
                        height: 1.25,
                      ),
                    ),
                    if (contact.description != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        contact.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF334155),
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    // Tombol aksi: salin nomor saja (tidak membuka dialer otomatis).
                    Row(
                      children: [
                        _actionButton(
                          icon: Icons.phone_outlined,
                          label: 'Salin Nomor',
                          onTap: onCopy,
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: isPrimary
            ? const Color(0xFFEFF6FF)
            : const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isPrimary
              ? const BorderSide(color: Color(0xFFBFDBFE))
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isPrimary
                      ? const Color(0xFF2563EB)
                      : SiagaTheme.ink,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPrimary
                        ? const Color(0xFF2563EB)
                        : SiagaTheme.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}