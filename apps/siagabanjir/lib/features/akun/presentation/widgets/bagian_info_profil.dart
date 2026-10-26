import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/profil_pengguna.dart';

class BagianInfoProfil extends StatelessWidget {
  const BagianInfoProfil({super.key, required this.profile});

  final ProfilPengguna profile;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Data Pribadi & Domisili',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: SiagaTheme.ink,
        ),
      ),
      const SizedBox(height: 12),
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
            _BarisInfo(
              icon: Icons.credit_card_outlined,
              label: 'NIK KTP',
              value: profile.nik,
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 64),
            _BarisInfo(
              icon: Icons.mail_outline_rounded,
              label: 'Alamat Email',
              value: profile.email,
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 64),
            _BarisInfo(
              icon: Icons.home_outlined,
              label: 'Alamat Tempat Tinggal',
              value: profile.address,
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 64),
            _BarisInfo(
              icon: Icons.location_on_outlined,
              label: 'Titik Evakuasi Mandiri Terdekat',
              value: profile.evacuationPoint,
            ),
          ],
        ),
      ),
    ],
  );
}

class _BarisInfo extends StatelessWidget {
  const _BarisInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: SiagaTheme.blue),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: SiagaTheme.muted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: SiagaTheme.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
