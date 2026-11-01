import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';

/// Warna kontrol admin mengikuti Beranda tanpa mengubah tema layar warga.
ThemeData temaAdmin(ThemeData base) => base.copyWith(
  colorScheme: base.colorScheme.copyWith(
    primary: SiagaTheme.blue,
    onPrimary: Colors.white,
    secondaryContainer: SiagaTheme.navigationBackground,
    onSecondaryContainer: SiagaTheme.deepBlue,
    surface: Colors.white,
    surfaceTint: Colors.transparent,
    outline: SiagaTheme.border,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: base.outlinedButtonTheme.style?.copyWith(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? null
            : const Color(0xFF1D4ED8),
      ),
      side: WidgetStateProperty.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.disabled)
              ? SiagaTheme.border
              : const Color(0xFFBFDBFE),
        ),
      ),
    ),
  ),
);
