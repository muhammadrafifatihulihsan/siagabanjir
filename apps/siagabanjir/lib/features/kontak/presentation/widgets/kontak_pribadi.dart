import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/kontak_darurat.dart';
import 'bagian_kontak_darurat.dart';
import 'formulir_kontak.dart';

class KontakPribadi extends StatelessWidget {
  const KontakPribadi({super.key, required this.kontak});
  final ValueNotifier<List<KontakDarurat>> kontak;

  Future<void> _edit(BuildContext context, [KontakDarurat? lama]) async {
    final hasil = await showDialog<KontakDarurat>(
      context: context,
      builder: (_) => FormulirKontak(kontak: lama),
    );
    if (!context.mounted || hasil == null) return;
    kontak.value = lama == null
        ? [...kontak.value, hasil]
        : kontak.value.map((c) => c == lama ? hasil : c).toList();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kontak disimpan untuk sesi ini.')),
    );
  }

  Future<void> _aksi(BuildContext context, KontakDarurat item) async {
    final aksi = await showDialog<String>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: Text(item.name),
        content: Text('${item.relation}\n${item.phone}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'hapus'),
            child: const Text('Hapus'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, 'edit'),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'salin'),
            child: const Text('Salin Nomor'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (aksi == 'edit') {
      await _edit(context, item);
    } else if (aksi == 'salin') {
      await Clipboard.setData(ClipboardData(text: item.phone));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Nomor kontak disalin.')));
      }
    } else if (aksi == 'hapus') {
      final hapus = await showDialog<bool>(
        context: context,
        builder: (ctx) => DialogSiaga(
          title: const Text('Hapus kontak?'),
          content: Text('${item.name} akan dihapus dari kontak pribadi Anda.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Hapus Kontak'),
            ),
          ],
        ),
      );
      if (context.mounted && hapus == true) {
        kontak.value = kontak.value.where((c) => c != item).toList();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: kontak,
    builder: (context, daftar, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BagianKontakDarurat(
          contacts: daftar,
          onAddContact: () => _edit(context),
          onCallContact: (c) => _aksi(context, c),
        ),
        if (daftar.isEmpty)
          const Text('Tambahkan keluarga atau orang yang dapat Anda hubungi.'),
        const SizedBox(height: 8),
        const Text('Kontak pribadi tersimpan selama sesi demo ini.'),
      ],
    ),
  );
}
