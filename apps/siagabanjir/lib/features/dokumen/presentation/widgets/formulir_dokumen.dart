import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../data/layanan_berkas.dart';

class FormulirDokumen extends StatefulWidget {
  const FormulirDokumen({super.key, required this.berkas});
  final BerkasPilihan berkas;
  @override
  State<FormulirDokumen> createState() => _FormulirDokumenState();
}

class _FormulirDokumenState extends State<FormulirDokumen> {
  final _form = GlobalKey<FormState>();
  final _nama = TextEditingController();
  String _kategori = 'KTP';
  @override
  void dispose() {
    _nama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DialogSiaga(
    title: const Text('Simpan Dokumen'),
    content: Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${widget.berkas.nama} • ${widget.berkas.ukuran}'),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _kategori,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Kategori dokumen'),
            items: [
              'KTP',
              'KK',
              'Lainnya',
            ].map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
            onChanged: (k) => setState(() => _kategori = k!),
          ),
          if (_kategori == 'Lainnya') ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _nama,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: 'Nama dokumen',
                hintText: 'Pajak kendaraan',
                helperText: 'Spasi dihapus dari nama berkas.',
                helperMaxLines: 2,
              ),
              validator: (v) => LayananBerkas.namaDokumen(v ?? '').isEmpty
                  ? 'Isi nama dengan huruf atau angka.'
                  : null,
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Dokumen tersedia selama sesi demo. Ekspor ZIP untuk menyimpan salinan; belum diunggah ke server.',
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: () {
          if (!_form.currentState!.validate()) return;
          final nama = _kategori == 'Lainnya'
              ? LayananBerkas.namaDokumen(_nama.text)
              : _kategori;
          Navigator.pop(context, (
            kategori: _kategori,
            berkas: BerkasPilihan(
              '$nama.${widget.berkas.ekstensi}',
              widget.berkas.bytes,
            ),
          ));
        },
        child: const Text('Simpan Dokumen'),
      ),
    ],
  );
}
