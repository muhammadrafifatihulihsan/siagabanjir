import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import '../../core/jaringan/endpoint_api.dart';
import '../../core/jaringan/klien_api.dart';

/// Media selalu diambil dengan sesi aktif; URL tidak berisi token akses.
class MediaPrivat extends StatefulWidget {
  const MediaPrivat({super.key, required this.id, required this.jenis});
  final String id, jenis;
  @override
  State<MediaPrivat> createState() => _MediaPrivatState();
}

class _MediaPrivatState extends State<MediaPrivat> {
  Uint8List? bytes;
  bool sibuk = false;
  String? error;

  Future<void> buka() async {
    if (sibuk) return;
    setState(() {
      sibuk = true;
      error = null;
    });
    try {
      final data = await KlienApi().unduh(
        EndpointApi.media(widget.id),
      );
      if (!mounted) return;
      if (widget.jenis.startsWith('image/')) {
        setState(() => bytes = data);
      } else {
        final pdf = widget.jenis == 'application/pdf';
        await FileSaver.instance.saveAs(
          name: 'siaga_${widget.id}',
          bytes: data,
          fileExtension: pdf ? 'pdf' : 'mp4',
          mimeType: pdf ? MimeType.pdf : MimeType.mp4Video,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => error =
              'Berkas belum dapat dibuka. Periksa koneksi dan akses Anda.',
        );
      }
    } finally {
      if (mounted) setState(() => sibuk = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      OutlinedButton.icon(
        onPressed: sibuk ? null : buka,
        icon: const Icon(Icons.attach_file),
        label: Text(sibuk ? 'Memuat berkas…' : 'Buka bukti (${widget.jenis})'),
      ),
      if (error != null) Text(error!),
      if (bytes != null)
        Semantics(
          label: 'Bukti yang diunggah',
          child: Image.memory(
            bytes!,
            height: 260,
            fit: BoxFit.contain,
            errorBuilder: (_, error, stack) =>
                const Text('Gambar tidak dapat ditampilkan.'),
          ),
        ),
    ],
  );
}
