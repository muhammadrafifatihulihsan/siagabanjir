import 'package:flutter/material.dart';

import '../features/admin/presentation/kerangka_admin_web.dart';
import '../features/autentikasi/domain/peran_pengguna.dart';
import '../shared/theme/siaga_theme.dart';
import '../shared/theme/perilaku_gulir.dart';
import 'kerangka_warga.dart';

class SiagaBanjirApp extends StatelessWidget {
  const SiagaBanjirApp({super.key, this.initialRole});

  final PeranPengguna? initialRole;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SiagaBanjir',
    debugShowCheckedModeBanner: false,
    theme: SiagaTheme.light,
    scrollBehavior: const PerilakuGulirSiaga(),
    routes: {
      '/admin': (_) => const KerangkaAdminWeb(),
      '/warga': (_) => const KerangkaWarga(),
    },
    home: initialRole == PeranPengguna.admin
        ? const KerangkaAdminWeb()
        : const KerangkaWarga(),
  );
}
