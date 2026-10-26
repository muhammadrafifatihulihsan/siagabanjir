import 'package:flutter/material.dart';

abstract final class SiagaTheme {
  static const background = Color(0xFFF8FAFC);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const mutedOnTint = Color(0xFF475569);
  static const blue = Color(0xFF2563EB);
  static const deepBlue = Color(0xFF1E3A8A);
  static const border = Color(0xFFE2E8F0);
  // Warna permukaan bersama menjaga pilihan form dan navbar tetap selaras home.
  static const selectionBackground = Color(0xFFEFF6FF);
  static const navigationBackground = Color(0xFFE1EDFF);
  static const double judulHalaman = 22;
  static const double judulBagian = 16;
  static const double isi = 14;
  static const double keterangan = 12;

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
      bodyMedium: TextStyle(fontSize: 14, color: ink, height: 1.4),
      bodyLarge: TextStyle(fontSize: 16, color: ink, height: 1.3),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: deepBlue,
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        color: Colors.white,
        fontSize: 14,
        height: 1.4,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: background,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(16),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
  );
}
