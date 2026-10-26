import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/dialog_siaga.dart';
import '../domain/anggota_keluarga.dart';
import 'formulir_anggota.dart';

class LayarKeluarga extends StatefulWidget {
  const LayarKeluarga({super.key});
  @override
  State<LayarKeluarga> createState() => _LayarKeluargaState();
}

class _LayarKeluargaState extends State<LayarKeluarga> {
  final _anggota = <AnggotaKeluarga>[];
  Future<void> _edit([AnggotaKeluarga? anggota]) async {
    final hasil = await showDialog<AnggotaKeluarga>(
      context: context,
      builder: (_) => FormulirAnggota(anggota: anggota),
    );
    if (!mounted || hasil == null) return;
    setState(() {
      if (anggota == null) {
        _anggota.add(hasil);
      } else {
        _anggota[_anggota.indexOf(anggota)] = hasil;
      }
    });
  }

  Future<void> _hapus(AnggotaKeluarga anggota) async {
    final hapus = await showDialog<bool>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Hapus anggota?'),
        content: Text('Hapus ${anggota.nama} dari daftar sesi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (mounted && hapus == true) setState(() => _anggota.remove(anggota));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(title: const Text('Data Keluarga')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Anggota & Kebutuhan Keluarga',
          style: TextStyle(
            fontSize: SiagaTheme.judulHalaman,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Catatan lokal selama halaman ini terbuka. Gunakan data uji; informasi belum dikirim ke petugas.',
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: _edit,
          icon: const Icon(Icons.person_add_outlined),
          label: const Text('Tambah Anggota'),
        ),
        const SizedBox(height: 16),
        if (_anggota.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Belum ada anggota. Tambahkan keluarga dan kebutuhan yang perlu diperhatikan.',
              textAlign: TextAlign.center,
            ),
          ),
        for (final anggota in _anggota)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anggota.nama,
                    style: const TextStyle(
                      fontSize: SiagaTheme.judulBagian,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(anggota.hubungan),
                  if (anggota.kebutuhan.isNotEmpty) Text(anggota.kebutuhan),
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton.icon(
                        onPressed: () => _edit(anggota),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                      ),
                      TextButton.icon(
                        onPressed: () => _hapus(anggota),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Hapus'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
