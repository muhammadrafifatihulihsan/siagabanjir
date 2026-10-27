import 'package:siagabanjir/shared/widgets/dialog_siaga.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../models/pesan_siaga.dart';

// Dialog penjelasan aksi untuk demonstrasi akademik tanpa klaim panggilan nyata.
Future<void> showMessageActionExplanation(
  BuildContext context,
  String action,
  PesanSiaga message,
) => showDialog<void>(
  context: context,
  builder: (context) => DialogSiaga(
    title: Text(action),
    content: Text(
      _explanationFor(action, message),
      style: const TextStyle(
        fontSize: SiagaTheme.isi,
        color: Color(0xFF334155),
        height: 1.4,
      ),
    ),
    actions: [
      if (action == 'Bagikan')
        FilledButton.icon(
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(
                text: '${message.title}\n\n${message.body}',
              ),
            );
            if (context.mounted) Navigator.pop(context);
          },
          icon: const Icon(Icons.copy_outlined),
          label: const Text('Salin Pesan'),
        ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Mengerti',
          style: TextStyle(fontWeight: FontWeight.w700, color: SiagaTheme.blue),
        ),
      ),
    ],
  ),
);

// Detail isi pesan saat kartu diketuk.
Future<void> showMessageDetail(BuildContext context, PesanSiaga message) =>
    showDialog<void>(
      context: context,
      builder: (context) => DialogSiaga(
        title: Wrap(
          spacing: 12,
          runSpacing: 8,
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
                  fontSize: SiagaTheme.keterangan,
                  fontWeight: FontWeight.w700,
                  color: message.badgeTextColor,
                ),
              ),
            ),
            Text(
              message.timestamp,
              style: const TextStyle(
                fontSize: SiagaTheme.keterangan,
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
                  fontSize: SiagaTheme.isi,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message.title,
                style: const TextStyle(
                  fontSize: SiagaTheme.judulBagian,
                  fontWeight: FontWeight.w700,
                  color: SiagaTheme.ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message.body,
                style: const TextStyle(
                  fontSize: SiagaTheme.isi,
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

String _explanationFor(String action, PesanSiaga message) {
  switch (action) {
    case 'Bagikan':
      return 'Bagikan informasi peringatan "${message.title}" kepada keluarga dan kerabat.';
    default:
      return 'Tindakan $action untuk pesan "${message.title}".';
  }
}
