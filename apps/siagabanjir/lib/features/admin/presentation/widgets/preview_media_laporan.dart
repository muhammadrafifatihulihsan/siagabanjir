import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/klaster_wilayah.dart';

/// Foto bukti menggunakan contain saat dibuka agar seluruh gambar terlihat.
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

  static Widget _gambar(LaporanAdminItem item, BoxFit fit) {
    Widget gagal(BuildContext context, Object error, StackTrace? stack) =>
        const Center(
          child: Icon(
            Icons.broken_image_outlined,
            semanticLabel: 'Foto tidak dapat dimuat',
            color: Color(0xFF475569),
          ),
        );
    return item.foto != null
        ? Image.memory(item.foto!, fit: fit, errorBuilder: gagal)
        : Image.asset(
            'assets/images/reports/sample_banjir.jpg',
            fit: fit,
            errorBuilder: gagal,
          );
  }

  static void bukaDialogFoto(BuildContext context, LaporanAdminItem item) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Foto Bukti'),
        content: SizedBox(
          width: 640,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(ctx).height * .4,
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: _gambar(item, BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${item.id} | ${item.namaPelapor}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(item.namaWilayah),
              Text(item.timestamp),
              const SizedBox(height: 12),
              Text(item.deskripsi),
              const SizedBox(height: 8),
              Text('Estimasi AI: ${item.estimasiAiTinggi}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Buka foto laporan ${item.id}',
    child: Tooltip(
      message: 'Perbesar foto',
      child: InkWell(
        onTap: () => bukaDialogFoto(context, item),
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: size ?? width,
          height: size ?? height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _gambar(item, BoxFit.cover),
                if (showZoomHint ?? showZoomOverlay)
                  const Positioned(
                    right: 4,
                    bottom: 4,
                    child: ColoredBox(
                      color: Color(0xCC0F172A),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
