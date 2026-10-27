import 'package:flutter/material.dart';

import 'dart:typed_data';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/profil_pengguna.dart';

class KartuHeaderProfil extends StatelessWidget {
  const KartuHeaderProfil({
    super.key,
    required this.profile,
    required this.onEdit,
    this.foto,
  });

  final ProfilPengguna profile;
  final VoidCallback onEdit;
  final Uint8List? foto;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
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
        Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: SiagaTheme.selectionBackground,
              backgroundImage: foto == null ? null : MemoryImage(foto!),
              child: foto == null
                  ? Text(
                      profile.initials,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: SiagaTheme.blue,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: SiagaTheme.judulBagian,
                      fontWeight: FontWeight.w800,
                      color: SiagaTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profile.phone,
                    style: const TextStyle(
                      fontSize: SiagaTheme.isi,
                      fontWeight: FontWeight.w500,
                      color: SiagaTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profile.location,
                    style: const TextStyle(
                      fontSize: SiagaTheme.isi,
                      color: SiagaTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              size: 24,
              color: SiagaTheme.blue,
            ),
            label: const Text(
              'Edit Profil',
              style: TextStyle(
                fontSize: SiagaTheme.isi,
                fontWeight: FontWeight.w700,
                color: SiagaTheme.blue,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFF8FAFC),
              side: const BorderSide(color: Color(0xFFBFDBFE)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
