import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Bagian tautan bawah untuk mendaftar akun baru bagi warga yang belum memiliki akun.
class FooterMasuk extends StatelessWidget {
  const FooterMasuk({super.key, required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) => Center(
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Belum punya akun? ',
          style: TextStyle(
            fontSize: SiagaTheme.isi,
            fontWeight: FontWeight.w400,
            color: SiagaTheme.muted,
          ),
        ),
        Semantics(
          button: true,
          label: 'Daftar Sekarang, buka formulir pendaftaran akun',
          child: InkWell(
            onTap: onRegister,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                'Daftar Sekarang',
                style: TextStyle(
                  fontSize: SiagaTheme.isi,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
