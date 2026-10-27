import 'package:flutter/material.dart';

import '../../../shared/widgets/dialog_siaga.dart';
import '../domain/anggota_keluarga.dart';

class FormulirAnggota extends StatefulWidget {
  const FormulirAnggota({super.key, this.anggota});
  final AnggotaKeluarga? anggota;
  @override
  State<FormulirAnggota> createState() => _FormulirAnggotaState();
}

class _FormulirAnggotaState extends State<FormulirAnggota> {
  final _form = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.anggota?.nama);
  late final _hubungan = TextEditingController(text: widget.anggota?.hubungan);
  late final _kebutuhan = TextEditingController(
    text: widget.anggota?.kebutuhan,
  );
  @override
  void dispose() {
    _nama.dispose();
    _hubungan.dispose();
    _kebutuhan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DialogSiaga(
    title: Text(
      widget.anggota == null
          ? 'Tambah Anggota Keluarga'
          : 'Edit Anggota Keluarga',
    ),
    content: Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nama,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Nama anggota'),
            validator: (s) =>
                s == null || s.trim().isEmpty ? 'Nama wajib diisi.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _hubungan,
            maxLength: 40,
            decoration: const InputDecoration(labelText: 'Hubungan keluarga'),
            validator: (s) =>
                s == null || s.trim().isEmpty ? 'Hubungan wajib diisi.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _kebutuhan,
            maxLength: 250,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Kebutuhan khusus (opsional)',
            ),
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
          if (_form.currentState!.validate()) {
            Navigator.pop(
              context,
              AnggotaKeluarga(
                nama: _nama.text.trim(),
                hubungan: _hubungan.text.trim(),
                kebutuhan: _kebutuhan.text.trim(),
              ),
            );
          }
        },
        child: const Text('Simpan Anggota'),
      ),
    ],
  );
}
