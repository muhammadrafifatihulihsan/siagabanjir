import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/klaster_wilayah.dart';
import '../../domain/state_admin_siaga.dart';
import 'preview_media_laporan.dart';

class ModalBuktiWilayah extends StatefulWidget {
  const ModalBuktiWilayah({
    super.key,
    required this.klaster,
    required this.state,
  });
  final KlasterWilayahAi klaster;
  final StateAdminSiaga state;

  static Future<void> show(
    BuildContext context, {
    required KlasterWilayahAi klaster,
    required StateAdminSiaga state,
  }) => showDialog<void>(
    context: context,
    builder: (_) => ModalBuktiWilayah(klaster: klaster, state: state),
  );

  @override
  State<ModalBuktiWilayah> createState() => _ModalBuktiWilayahState();
}

class _ModalBuktiWilayahState extends State<ModalBuktiWilayah> {
  final _catatanController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  void _kirimCatatan() {
    final text = _catatanController.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Isi catatan tindak lanjut.');
      return;
    }
    widget.state.tambahCatatanTindakLanjutKlaster(widget.klaster.id, text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final k = widget.klaster;
    return DialogSiaga(
      title: Text(k.namaWilayah),
      content: SizedBox(
        width: 720,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${k.kecamatan} | ${k.totalLaporan} laporan'),
            const SizedBox(height: 8),
            Text(
              k.statusVerifikasi.label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text('Estimasi kedalaman: ${k.estimasiKedalaman}'),
            const SizedBox(height: 4),
            Text('Kebutuhan: ${k.kebutuhanDominan.join(", ")}'),
            const SizedBox(height: 24),
            const Text(
              'Bukti Laporan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final item in k.laporan)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PreviewMediaLaporan(item: item, size: 72),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.namaPelapor,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.timestamp,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              Text(
                                item.namaWilayah,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item.deskripsi),
                    const SizedBox(height: 4),
                    Text(
                      'Estimasi AI: ${item.estimasiAiTinggi}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                      ),
                    ),
                    if (item.kebutuhan.isNotEmpty)
                      Text('Kebutuhan: ${item.kebutuhan.join(", ")}'),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                  ],
                ),
              ),
            if (k.catatanTindakLanjut.isNotEmpty) ...[
              const Text(
                'Catatan Tindak Lanjut',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final c in k.catatanTindakLanjut)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(c),
                ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _catatanController,
              maxLines: 3,
              maxLength: 1000,
              decoration: InputDecoration(
                labelText: 'Catatan tindak lanjut',
                hintText: 'Tuliskan tindakan yang sudah dilakukan.',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: _kirimCatatan,
                child: const Text('Simpan Catatan'),
              ),
            ),
            if (k.statusVerifikasi ==
                StatusVerifikasiWilayah.menungguTinjauan) ...[
              const SizedBox(height: 16),
              Text(
                'Verifikasi berlaku untuk seluruh ${k.totalLaporan} laporan dalam wilayah ini.',
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
        if (k.statusVerifikasi == StatusVerifikasiWilayah.terverifikasi)
          OutlinedButton(
            onPressed: () {
              widget.state.selesaikanKlaster(k.id);
              Navigator.pop(context);
            },
            child: const Text('Tandai Selesai'),
          ),
        if (k.statusVerifikasi == StatusVerifikasiWilayah.menungguTinjauan)
          FilledButton(
            onPressed: () {
              widget.state.verifikasiKlaster(k.id);
              Navigator.pop(context);
            },
            child: const Text('Verifikasi Wilayah'),
          ),
      ],
    );
  }
}
