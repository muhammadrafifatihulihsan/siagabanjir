import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/klaster_wilayah.dart';

/// Widget thumbnail dan dialog preview media foto laporan warga.
class PreviewMediaLaporan extends StatelessWidget {
  const PreviewMediaLaporan({
    super.key,
    required this.item,
    this.width = 72,
    this.height = 72,
    this.size,
    this.showZoomOverlay = true,
    this.showZoomHint,
  });

  final LaporanAdminItem item;
  final double width;
  final double height;
  final double? size;
  final bool showZoomOverlay;
  final bool? showZoomHint;

  static void bukaDialogFoto(BuildContext context, LaporanAdminItem item) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.image_outlined,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Pratinjau Foto Bukti Warga',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${item.id} • ${item.namaPelapor}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display Gambar Besar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.foto != null
                    ? Image.memory(
                        item.foto!,
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/reports/sample_banjir.jpg',
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _buildFotografiMock(height: 240, isFull: true, item: item),
                      ),
              ),
              const SizedBox(height: 16),

              // Panel Metadata Foto & Analisis AI
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildMetaRow('Lokasi Pengambilan', item.namaWilayah),
                    const SizedBox(height: 8),
                    _buildMetaRow('Waktu Deteksi', item.timestamp),
                    const SizedBox(height: 8),
                    _buildMetaRow('Estimasi Tinggi Air AI', item.estimasiAiTinggi),
                    const SizedBox(height: 8),
                    _buildMetaRow(
                      'Kategori & Kebutuhan',
                      '${item.kategori} • ${item.kebutuhan.isEmpty ? "Tidak ada" : item.kebutuhan.join(", ")}',
                    ),
                    const Divider(height: 18, color: Color(0xFFE2E8F0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 140,
                          child: Text(
                            'Catatan Pelapor',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.deskripsi,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F172A),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMetaRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildFotografiMock({
    required double height,
    required bool isFull,
    required LaporanAdminItem item,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF38BDF8)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Pola Gelombang Permukaan Air
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: CustomPaint(
                painter: _PolaAirPainter(),
              ),
            ),
          ),
          // Watermark Informasi
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.water_rounded,
                  color: Colors.white,
                  size: isFull ? 44 : 26,
                ),
                if (isFull) ...[
                  const SizedBox(height: 8),
                  Text(
                    'FOTO LAPORAN GENANGAN: ${item.estimasiAiTinggi.toUpperCase()}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.namaWilayah,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Badge AI Terverifikasi
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFFFDE047), size: 10),
                  SizedBox(width: 4),
                  Text(
                    'BUKTI AI',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effWidth = size ?? width;
    final effHeight = size ?? height;
    final effZoom = showZoomHint ?? showZoomOverlay;

    return Tooltip(
      message: 'Klik untuk perbesar preview foto bukti',
      child: InkWell(
        onTap: () => bukaDialogFoto(context, item),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: effWidth,
          height: effHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: item.foto != null
                      ? Image.memory(
                          item.foto!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/reports/sample_banjir.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildFotografiMock(
                            height: effHeight,
                            isFull: false,
                            item: item,
                          ),
                        ),
                ),
              ),
              if (effZoom)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.zoom_in_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolaAirPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double y = 10; y < size.height; y += 20) {
      path.moveTo(0, y);
      for (double x = 0; x < size.width; x += 40) {
        path.quadraticBezierTo(x + 10, y - 6, x + 20, y);
        path.quadraticBezierTo(x + 30, y + 6, x + 40, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
