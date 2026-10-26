import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Bagian tautan bawah untuk masuk bagi warga yang sudah memiliki akun sesuai desain auth_register.svg.
class FooterDaftar extends StatelessWidget {
  const FooterDaftar({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) => Center(
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Sudah punya akun? ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: SiagaTheme.muted,
          ),
        ),
        Semantics(
          button: true,
          label: 'Masuk Sekarang, kembali ke halaman masuk',
          child: InkWell(
            onTap: onLogin,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                'Masuk Sekarang',
                style: TextStyle(
                  fontSize: 14,
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
