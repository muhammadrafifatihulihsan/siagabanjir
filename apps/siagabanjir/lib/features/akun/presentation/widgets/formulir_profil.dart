import 'package:flutter/material.dart';

import '../../../../core/perangkat/layanan_foto.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/profil_pengguna.dart';

class FormulirProfil extends StatefulWidget {
  const FormulirProfil({
    super.key,
    required this.profil,
    this.foto,
    this.layananFoto,
  });
  final FotoPilihan? foto;
  final LayananFoto? layananFoto;
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
  late FotoPilihan? _foto = widget.foto;
  bool _sibuk = false;
  String? _error;

  Future<void> _pilihFoto(bool kamera) async {
    if (_sibuk) return;
    setState(() {
      _sibuk = true;
      _error = null;
    });
    try {
      final layanan = widget.layananFoto ?? LayananFoto();
      final hasil = await (kamera ? layanan.ambil() : layanan.galeri());
      if (mounted && hasil != null) setState(() => _foto = hasil);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Foto belum dapat dibuka. Periksa izin dan pilih foto maksimal 5 MB.',
        );
      }
    } finally {
      if (mounted) setState(() => _sibuk = false);
    }
  }

  @override
  void dispose() {
    for (final c in [_nama, _telepon, _alamat, _domisili]) {
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
    Navigator.pop(context, (
      foto: _foto,
      profil: widget.profil.copyWith(
        name: nama,
        phone: _telepon.text.trim(),
        address: _alamat.text.trim(),
        location: _domisili.text.trim(),
        initials: inisial,
      ),
    ));
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
            'Email dan NIK tidak dapat diubah melalui formulir ini.',
          ),
          const SizedBox(height: 20),
          if (_foto != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CircleAvatar(
                radius: 36,
                backgroundImage: MemoryImage(_foto!.bytes),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _sibuk ? null : () => _pilihFoto(true),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Kamera'),
              ),
              OutlinedButton.icon(
                onPressed: _sibuk ? null : () => _pilihFoto(false),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Galeri'),
              ),
            ],
          ),
          if (_sibuk) const LinearProgressIndicator(),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
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
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: _sibuk ? null : _simpan,
        child: const Text('Simpan Perubahan'),
      ),
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
