import 'package:flutter/material.dart';

import '../../domain/klaster_wilayah.dart';
import '../../domain/state_admin_siaga.dart';
import 'modal_bukti_wilayah.dart';

/// Ringkasan wilayah: bukti dan status mendahului tindakan peninjauan.
class KartuKlasterAdmin extends StatelessWidget {
  const KartuKlasterAdmin({
    super.key,
    required this.klaster,
    required this.state,
  });
  final KlasterWilayahAi klaster;
  final StateAdminSiaga state;

  @override
  Widget build(BuildContext context) {
    final k = klaster;
    final status = k.statusVerifikasi;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              k.namaWilayah,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  k.kecamatan,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                  ),
                ),
                Text(
                  '${k.totalLaporan} laporan',
                  style: const TextStyle(fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: status.badgeBackground,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: status == StatusVerifikasiWilayah.selesai
                          ? const Color(0xFF047857)
                          : status.badgeForeground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Estimasi kedalaman: ${k.estimasiKedalaman}',
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 4),
            Text(
              'Kebutuhan: ${k.kebutuhanDominan.isEmpty ? "Tidak ada" : k.kebutuhanDominan.join(", ")}',
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () =>
                    ModalBuktiWilayah.show(context, klaster: k, state: state),
                child: const Text('Lihat Bukti'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
