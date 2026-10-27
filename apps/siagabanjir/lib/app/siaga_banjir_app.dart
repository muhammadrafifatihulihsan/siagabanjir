import 'package:flutter/material.dart';

import '../shared/theme/siaga_theme.dart';
import '../shared/theme/perilaku_gulir.dart';
import 'kerangka_warga.dart';

class SiagaBanjirApp extends StatelessWidget {
  const SiagaBanjirApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SiagaBanjir',
    debugShowCheckedModeBanner: false,
    theme: SiagaTheme.light,
    scrollBehavior: const PerilakuGulirSiaga(),
    home: const KerangkaWarga(),
  );
}
