import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../models/entri_kontak.dart';

/// Kartu direktori ringkas mengikuti SVG, dengan aksi salin sesuai perilaku.
class KartuKontak extends StatelessWidget {
  const KartuKontak({super.key, required this.contact, required this.onCopy});
  final EntriKontak contact;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: SiagaTheme.border),
    ),
    child: LayoutBuilder(
      builder: (context, batas) {
        final informasi = Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                switch (contact.category) {
                  KategoriKontak.emergency => Icons.shield_outlined,
                  KategoriKontak.health => Icons.health_and_safety_outlined,
                  KategoriKontak.infrastructure => Icons.water_drop_outlined,
                  KategoriKontak.posko => Icons.home_outlined,
                },
                color: SiagaTheme.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: SiagaTheme.isi,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.phone,
                    style: const TextStyle(
                      fontSize: SiagaTheme.keterangan,
                      color: SiagaTheme.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        final salin = Semantics(
          container: true,
          onTap: onCopy,
          label: 'Salin nomor ${contact.phone}',
          button: true,
          excludeSemantics: true,
          child: TextButton.icon(
            onPressed: onCopy,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF047857),
              backgroundColor: const Color(0xFFECFDF5),
              side: const BorderSide(color: Color(0xFFA7F3D0)),
            ),
            icon: const Icon(Icons.copy_outlined, size: 16),
            label: const Text('Salin'),
          ),
        );
        if (batas.maxWidth / MediaQuery.textScalerOf(context).scale(1) < 300) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              informasi,
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerRight, child: salin),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: informasi),
            const SizedBox(width: 8),
            salin,
          ],
        );
      },
    ),
  );
}
