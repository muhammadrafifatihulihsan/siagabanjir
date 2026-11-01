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
  chipTheme: base.chipTheme.copyWith(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    side: const BorderSide(color: SiagaTheme.border),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    labelStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: SiagaTheme.deepBlue,
    ),
  ),
  inputDecorationTheme: base.inputDecorationTheme.copyWith(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: SiagaTheme.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: SiagaTheme.blue, width: 2),
    ),
  ),
  dataTableTheme: base.dataTableTheme.copyWith(
    headingTextStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: SiagaTheme.deepBlue,
    ),
    dividerThickness: 1,
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
