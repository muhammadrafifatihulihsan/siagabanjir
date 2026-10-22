import 'package:flutter/material.dart';

abstract final class SiagaTheme {
  static const background = Color(0xFFF8FAFC);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const mutedOnTint = Color(0xFF475569);
  static const blue = Color(0xFF2563EB);
  static const deepBlue = Color(0xFF1E3A8A);
  static const border = Color(0xFFE2E8F0);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: blue,
      primary: blue,
      surface: background,
    ),
    scaffoldBackgroundColor: background,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14, color: ink, height: 1.3),
      bodyLarge: TextStyle(fontSize: 16, color: ink, height: 1.3),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
  );
}
