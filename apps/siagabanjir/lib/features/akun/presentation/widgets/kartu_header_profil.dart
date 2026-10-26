import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/profil_pengguna.dart';

class KartuHeaderProfil extends StatelessWidget {
  const KartuHeaderProfil({
    super.key,
    required this.profile,
    required this.onEdit,
    this.onChangeAvatar,
  });

  final ProfilPengguna profile;
  final VoidCallback onEdit;
  final VoidCallback? onChangeAvatar;

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
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFFBFDBFE),
                  child: Text(
                    profile.initials,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Material(
                    color: SiagaTheme.blue,
                    shape: const CircleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onChangeAvatar ?? onEdit,
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: SiagaTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profile.phone,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: SiagaTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(width: 6, height: 6),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            profile.location,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ],
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
          height: 44,
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: SiagaTheme.blue,
            ),
            label: const Text(
              'Edit Profil',
              style: TextStyle(
                fontSize: 14,
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
