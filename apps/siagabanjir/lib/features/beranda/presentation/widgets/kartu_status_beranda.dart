import 'package:flutter/material.dart';
import 'package:siagabanjir/shared/widgets/local_icon.dart';

import '../../../../shared/theme/siaga_theme.dart';
import '../../../pantau/data/pantau_repository.dart';

class KartuStatusBeranda extends StatefulWidget {
  const KartuStatusBeranda({super.key, required this.onMonitor, this.pantauRepository});

  final VoidCallback onMonitor;
  final PantauRepository? pantauRepository;

  @override
  State<KartuStatusBeranda> createState() => _KartuStatusBerandaState();
}

class _KartuStatusBerandaState extends State<KartuStatusBeranda> {
  String _namaLokasi = 'Sungai Batang Kuranji';
  String _statusLevel = 'Siaga 2';
  String _keteranganStatus = 'Potensi luapan air. Amankan barang berharga.';

  @override
  void initState() {
    super.initState();
    final repo = widget.pantauRepository ?? PantauRepository();
    repo.ambilRingkasanPantau().then((res) {
      if (mounted && res.items.isNotEmpty) {
        final pertama = res.items.first;
        setState(() {
          _namaLokasi = pertama.namaLokasi;
          if (pertama.tingkat == 'HIGH') {
            _statusLevel = 'Siaga 1';
            _keteranganStatus = 'Banjir meluap ke pemukiman. Segera evakuasi mandiri.';
          } else if (pertama.tingkat == 'MEDIUM') {
            _statusLevel = 'Siaga 2';
            _keteranganStatus = 'Potensi luapan air. Amankan barang berharga.';
          } else if (pertama.tingkat == 'LOW') {
            _statusLevel = 'Siaga 3';
            _keteranganStatus = 'Kondisi air meningkat. Tetap waspada perkiraan hujan.';
          } else {
            _statusLevel = 'Normal';
            _keteranganStatus = 'Tinggi muka air sungai dalam batas aman.';
          }
        });
      }
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFD5E4FF),
      border: Border.all(color: const Color(0xFFC3DAFF)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _label(
                _statusLevel,
                const Color(0xFFB45309),
                Colors.white,
                dot: true,
              ),
              _label(
                'Wilayah Anda',
                const Color(0xFF1E40AF),
                const Color(0xFFEFF6FF),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _namaLokasi,
          style: const TextStyle(
            fontSize: SiagaTheme.judulHalaman,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: SiagaTheme.deepBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _keteranganStatus,
          style: const TextStyle(
            fontSize: SiagaTheme.judulBagian,
            height: 1.3,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LocalIcon('water', size: 14),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Tinggi Air: 140 cm (+20)',
                    style: TextStyle(
                      fontSize: SiagaTheme.judulBagian,
                      fontWeight: FontWeight.w700,
                      color: SiagaTheme.deepBlue,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '10 mnt lalu',
              style: TextStyle(
                fontSize: SiagaTheme.keterangan,
                color: SiagaTheme.mutedOnTint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton(
              onPressed: widget.onMonitor,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1D4ED8),
                minimumSize: const Size(48, 48),
                side: const BorderSide(color: Color(0xFFBFDBFE)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Pantau Status',
                      style: TextStyle(
                        fontSize: SiagaTheme.judulBagian,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  LocalIcon('arrow', size: 14),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _label(
    String text,
    Color foreground,
    Color background, {
    bool dot = false,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: SiagaTheme.keterangan,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ),
      ],
    ),
  );
}
