import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/kontak_darurat.dart';

class FormulirKontak extends StatefulWidget {
  const FormulirKontak({super.key, this.kontak});
  final KontakDarurat? kontak;
  @override
  State<FormulirKontak> createState() => _FormulirKontakState();
}

class _FormulirKontakState extends State<FormulirKontak> {
  final _form = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.kontak?.name);
  late final _hubungan = TextEditingController(text: widget.kontak?.relation);
  late final _nomor = TextEditingController(text: widget.kontak?.phone);

  @override
  void dispose() {
    _nama.dispose();
    _hubungan.dispose();
    _nomor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DialogSiaga(
    title: Text(
      widget.kontak == null ? 'Tambah Kontak Darurat' : 'Edit Kontak Darurat',
    ),
    content: Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Gunakan data contoh untuk pengujian. Kontak hanya disimpan selama sesi demo.',
          ),
          const SizedBox(height: 20),
          for (final field in [
            (_nama, 'Nama'),
            (_hubungan, 'Hubungan'),
            (_nomor, 'Nomor telepon'),
          ]) ...[
            TextFormField(
              controller: field.$1,
              maxLength: field.$1 == _nomor ? 24 : 80,
              decoration: InputDecoration(labelText: field.$2),
              keyboardType: field.$1 == _nomor
                  ? TextInputType.phone
                  : TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '${field.$2} wajib diisi.';
                }
                if (field.$1 == _nomor &&
                    !RegExp(r'^\+?(?:[ ()-]*[0-9]){8,15}[ ()-]*$')
                        .hasMatch(value.trim())) {
                  return 'Masukkan nomor telepon yang valid.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
          ],
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
          final nama = _nama.text.trim();
          Navigator.pop(
            context,
            KontakDarurat(
              name: nama,
              relation: _hubungan.text.trim(),
              phone: _nomor.text.trim(),
              initials: nama
                  .split(RegExp(r'\s+'))
                  .take(2)
                  .map((s) => s.characters.first)
                  .join()
                  .toUpperCase(),
            ),
          );
        },
        child: const Text('Simpan Kontak'),
      ),
    ],
  );
}
