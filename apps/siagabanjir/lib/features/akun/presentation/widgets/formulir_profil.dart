import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/profil_pengguna.dart';

class FormulirProfil extends StatefulWidget {
  const FormulirProfil({super.key, required this.profil});
  final ProfilPengguna profil;

  @override
  State<FormulirProfil> createState() => _FormulirProfilState();
}

class _FormulirProfilState extends State<FormulirProfil> {
  final _form = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.profil.name);
  late final _telepon = TextEditingController(text: widget.profil.phone);
  late final _alamat = TextEditingController(text: widget.profil.address);
  late final _domisili = TextEditingController(text: widget.profil.location);
  late final _evakuasi = TextEditingController(
    text: widget.profil.evacuationPoint,
  );

  @override
  void dispose() {
    for (final c in [_nama, _telepon, _alamat, _domisili, _evakuasi]) {
      c.dispose();
    }
    super.dispose();
  }

  void _simpan() {
    if (!_form.currentState!.validate()) return;
    final nama = _nama.text.trim();
    final inisial = nama
        .split(RegExp(r'\s+'))
        .take(2)
        .map((s) => s.characters.first)
        .join()
        .toUpperCase();
    Navigator.pop(
      context,
      widget.profil.copyWith(
        name: nama,
        phone: _telepon.text.trim(),
        address: _alamat.text.trim(),
        location: _domisili.text.trim(),
        evacuationPoint: _evakuasi.text.trim(),
        initials: inisial,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DialogSiaga(
    title: const Text('Edit Profil'),
    content: Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Perubahan disimpan selama sesi demo ini. Email dan NIK tidak diubah melalui formulir ini.',
          ),
          const SizedBox(height: 20),
          _isian(_nama, 'Nama lengkap', maxLength: 80),
          _isian(
            _telepon,
            'Nomor ponsel',
            keyboard: TextInputType.phone,
            telepon: true,
            maxLength: 24,
          ),
          _isian(_domisili, 'Domisili', maxLength: 100),
          _isian(_alamat, 'Alamat tempat tinggal', lines: 3, maxLength: 250),
          _isian(_evakuasi, 'Titik evakuasi', maxLength: 150),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(onPressed: _simpan, child: const Text('Simpan Perubahan')),
    ],
  );

  Widget _isian(
    TextEditingController c,
    String label, {
    int lines = 1,
    TextInputType? keyboard,
    bool telepon = false,
    required int maxLength,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: c,
      maxLines: lines,
      maxLength: maxLength,
      keyboardType: keyboard,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return '$label wajib diisi.';
        if (telepon &&
            !RegExp(r'^\+?(?:[ ()-]*[0-9]){8,15}[ ()-]*$')
                .hasMatch(value.trim())) {
          return 'Masukkan nomor ponsel yang valid.';
        }
        return null;
      },
    ),
  );
}
