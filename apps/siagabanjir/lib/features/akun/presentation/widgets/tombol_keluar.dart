import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

class TombolKeluar extends StatelessWidget {
  const TombolKeluar({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: Material(
      color: const Color(0xFFFEE2E2),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onLogout,
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout_rounded, size: 24, color: Color(0xFFDC2626)),
              SizedBox(width: 8),
              Text(
                'Keluar dari Akun',
                style: TextStyle(
                  fontSize: SiagaTheme.isi,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
