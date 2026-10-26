import 'package:flutter/material.dart';

// Menjelaskan layanan yang belum tersedia; isi dialog dapat digulir pada teks besar.
Future<void> showReportExplanation(
  BuildContext context,
  String title,
  String message,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    scrollable: true,
    title: Text(title),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Mengerti'),
      ),
    ],
  ),
);

// Aksi utama mempertahankan isian; keluar hanya terjadi setelah pilihan eksplisit.
Future<bool?> confirmReportExit(BuildContext context) => showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    scrollable: true,
    title: const Text('Keluar dari laporan?'),
    content: const Text(
      'Isian belum disimpan. Jika keluar, isian akan dihapus.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Keluar'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Lanjut mengisi'),
      ),
    ],
  ),
);
