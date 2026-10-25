import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../domain/siaga_message.dart';

// Dialog penjelasan aksi untuk demonstrasi akademik tanpa klaim panggilan nyata.
Future<void> showMessageActionExplanation(
  BuildContext context,
  String action,
  SiagaMessage message,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Text(
      action,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: SiagaTheme.ink,
      ),
    ),
    content: Text(
      _explanationFor(action, message),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF334155),
        height: 1.4,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Mengerti',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: SiagaTheme.blue,
          ),
        ),
      ),
    ],
  ),
);

// Detail isi pesan saat kartu diketuk.
Future<void> showMessageDetail(
  BuildContext context,
  SiagaMessage message,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: message.badgeBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.badgeLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: message.badgeTextColor,
            ),
          ),
        ),
        const Spacer(),
        Text(
          message.timestamp,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: SiagaTheme.muted,
          ),
        ),
      ],
    ),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.agency,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D4ED8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: SiagaTheme.ink,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message.body,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF334155),
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Tutup',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: SiagaTheme.blue,
          ),
        ),
      ),
    ],
  ),
);

String _explanationFor(String action, SiagaMessage message) {
  switch (action) {
    case 'Rute Evakuasi':
      return 'Fitur rute evakuasi menuju titik aman (${message.agency}) disimulasikan untuk demo Kota Padang.';
    case 'Bagikan':
      return 'Teks peringatan "${message.title}" siap disalin atau dibagikan ke keluarga.';
    case 'Hubungi Posko':
      return 'Kontak posko kedaruratan (${message.agency}) disimulasikan untuk keperluan pengujian demo.';
    default:
      return 'Tindakan $action untuk pesan "${message.title}" sedang diproses.';
  }
}
