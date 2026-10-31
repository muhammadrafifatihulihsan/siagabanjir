import 'package:flutter/material.dart';

import '../../domain/klaster_wilayah.dart';
import '../../domain/state_admin_siaga.dart';
import '../widgets/kartu_klaster_admin.dart';
import '../widgets/tata_letak_admin.dart';

class TabWilayahKlasterAi extends StatelessWidget {
  const TabWilayahKlasterAi({super.key, required this.state});
  final StateAdminSiaga state;

  @override
  Widget build(BuildContext context) {
    final daftar = List<KlasterWilayahAi>.from(state.klasterList)
      ..sort((a, b) => b.totalLaporan.compareTo(a.totalLaporan));
    return HalamanAdmin(
      children: [
        const JudulAdmin(
          'Klaster Wilayah',
          description: 'Wilayah diurutkan berdasarkan jumlah laporan.',
        ),
        if (daftar.isEmpty) const Text('Belum ada klaster wilayah.'),
        for (final k in daftar) KartuKlasterAdmin(klaster: k, state: state),
      ],
    );
  }
}
