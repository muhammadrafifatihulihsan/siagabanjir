import 'package:flutter/material.dart';

import 'dart:typed_data';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/profil_pengguna.dart';

class KartuHeaderProfil extends StatelessWidget {
  const KartuHeaderProfil({
    super.key,
    required this.profile,
    required this.onEdit,
    this.onChangeAvatar,
    this.foto,
    this.memuatFoto = false,
  });

  final ProfilPengguna profile;
  final VoidCallback onEdit;
  final VoidCallback? onChangeAvatar;
  final Uint8List? foto;
  final bool memuatFoto;

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
                Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 8),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: const Color(0xFFBFDBFE),
                    backgroundImage: foto == null ? null : MemoryImage(foto!),
                    child: foto != null
                        ? null
                        : Text(
                            profile.initials,
                            style: const TextStyle(
                              fontSize: SiagaTheme.judulHalaman,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: SiagaTheme.blue,
                    shape: const CircleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      tooltip: 'Ambil foto profil',
                      onPressed: memuatFoto ? null : onChangeAvatar,
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      icon: memuatFoto
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.camera_alt_rounded,
                              size: 20,
                              color: Colors.white,
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
                              fontSize: SiagaTheme.keterangan,
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
