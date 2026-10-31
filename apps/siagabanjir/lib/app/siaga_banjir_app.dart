import 'package:flutter/material.dart';

import '../features/admin/presentation/kerangka_admin_web.dart';
import '../features/autentikasi/domain/peran_pengguna.dart';
import '../features/autentikasi/presentation/layar_masuk.dart';
import '../shared/theme/siaga_theme.dart';
import '../shared/theme/perilaku_gulir.dart';
import 'kerangka_warga.dart';

class SiagaBanjirApp extends StatelessWidget {
  const SiagaBanjirApp({
    super.key,
    this.initialRole,
    this.initialRoute,
    this.mulaiDariMasuk = false,
  });

  final PeranPengguna? initialRole;
  final String? initialRoute;
  final bool mulaiDariMasuk;

  @override
  Widget build(BuildContext context) {
    final routeAwal = initialRoute ?? (mulaiDariMasuk ? '/masuk' : null);

    return MaterialApp(
      title: 'SiagaBanjir',
      debugShowCheckedModeBanner: false,
      theme: SiagaTheme.light,
      scrollBehavior: const PerilakuGulirSiaga(),
      initialRoute: routeAwal,
      routes: {
        '/masuk': (_) => const LayarMasukGerbang(),
        '/admin': (_) => const KerangkaAdminWeb(),
        '/warga': (_) => const KerangkaWarga(),
      },
      home: routeAwal != null
          ? null
          : (initialRole == PeranPengguna.admin
              ? const KerangkaAdminWeb()
              : const KerangkaWarga()),
    );
  }
}

/// Gerbang awal masuk ke aplikasi SiagaBanjir.
class LayarMasukGerbang extends StatelessWidget {
  const LayarMasukGerbang({super.key});

  @override
  Widget build(BuildContext context) {
    return LayarMasuk(
      onLoginWithRole: (user, role) {
        if (role == PeranPengguna.admin) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const KerangkaAdminWeb(),
            ),
            (_) => false,
          );
        } else {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const KerangkaWarga(),
            ),
            (_) => false,
          );
        }
      },
      onLoginSuccess: (_) => Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const KerangkaWarga()),
        (_) => false,
      ),
    );
  }
}
