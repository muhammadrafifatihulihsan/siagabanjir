import '../domain/entri_riwayat_laporan.dart';
import '../../../shared/widgets/dialog_siaga.dart';

import 'package:flutter/material.dart';

import '../../../core/perangkat/layanan_foto.dart';
import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/widgets/citizen_header.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import 'widgets/formulir_laporan.dart';
import 'widgets/dialog_laporan.dart';

// Layar hanya mengelola state lokal dan navigasi; bagian visual dipisah per tugas.
class LayarBuatLaporan extends StatefulWidget {
  const LayarBuatLaporan({
    super.key,
    this.onSimpan,
    this.scrollController,
    this.layananFoto,
    this.fotoDipulihkan,
    required this.onNotifications,
    required this.onHistory,
    required this.onProfile,
  });

  final ValueChanged<EntriRiwayatLaporan>? onSimpan;
  final VoidCallback onNotifications;
  final VoidCallback onHistory;
  final VoidCallback onProfile;
  final LayananFoto? layananFoto;
  final ValueNotifier<FotoPilihan?>? fotoDipulihkan;

  final ScrollController? scrollController;

  @override
  State<LayarBuatLaporan> createState() => _LayarBuatLaporanState();
}

class _LayarBuatLaporanState extends State<LayarBuatLaporan> {
  // Isian dimulai kosong agar kebutuhan warga tidak terpilih tanpa persetujuan.
  final _description = TextEditingController();
  final _descriptionFocus = FocusNode();
  late final _scroll = widget.scrollController ?? ScrollController();
  String? _category;
  final _needs = <String>{};
  bool _confirmingExit = false;
  FotoPilihan? _foto;
  bool _memuatFoto = false;

  @override
  void initState() {
    super.initState();
    _foto = widget.fotoDipulihkan?.value;
    widget.fotoDipulihkan?.addListener(_terimaFoto);
  }

  void _terimaFoto() {
    final foto = widget.fotoDipulihkan?.value;
    if (foto != null && mounted) setState(() => _foto = foto);
  }

  Future<void> _ambilFoto() async {
    if (_memuatFoto) return;
    _descriptionFocus.unfocus();
    setState(() => _memuatFoto = true);
    try {
      final hasil = await (widget.layananFoto ?? LayananFoto()).ambil();
      if (hasil != null && mounted) setState(() => _foto = hasil);
    } catch (_) {
      if (mounted) {
        await _explain(
          'Kamera belum dapat dibuka',
          'Periksa izin kamera dan coba lagi. Foto serta isian sebelumnya tetap ada.',
        );
      }
    } finally {
      if (mounted) setState(() => _memuatFoto = false);
    }
  }

  bool _menyimpan = false;
  Future<void> _simpan() async {
    if (_menyimpan || _memuatFoto) return;
    if (_category == null || _description.text.trim().isEmpty) {
      await _explain(
        'Lengkapi laporan',
        'Pilih kategori dan isi deskripsi kejadian sebelum menyimpan.',
      );
      return;
    }
    if (widget.onSimpan == null) {
      await _explain(
        'Riwayat belum tersedia',
        'Buka formulir melalui aplikasi untuk menyimpan catatan sesi.',
      );
      return;
    }
    _menyimpan = true;
    final setuju = await showDialog<bool>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Simpan Laporan?'),
        content: const Text(
          'Simpan laporan kejadian banjir ini ke riwayat laporan Anda?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Simpan Laporan'),
          ),
        ],
      ),
    );
    _menyimpan = false;
    if (!mounted || setuju != true) return;
    widget.onSimpan!(
      EntriRiwayatLaporan(
        waktu: DateTime.now(),
        kategori: _category!,
        deskripsi: _description.text.trim(),
        kebutuhan: List.unmodifiable(_needs),
        foto: _foto?.bytes,
      ),
    );
    setState(() {
      _description.clear();
      _category = null;
      _needs.clear();
      _foto = null;
    });
    widget.fotoDipulihkan?.value = null;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan berhasil disimpan ke Riwayat.'),
      ),
    );
  }

  // Membatalkan semua isian mengembalikan form ke kondisi bersih.
  bool get _hasInput =>
      _description.text.isNotEmpty ||
      _category != null ||
      _needs.isNotEmpty ||
      _foto != null;

  @override
  void dispose() {
    widget.fotoDipulihkan?.removeListener(_terimaFoto);
    // Controller dan fokus dilepas ketika route ditutup agar tidak menahan resource.
    _description.dispose();
    _descriptionFocus.dispose();
    if (widget.scrollController == null) _scroll.dispose();
    super.dispose();
  }

  // Dialog menjelaskan kemampuan aktual tanpa mengaku berhasil mengirim data.
  Future<void> _explain(String title, String message) async {
    _descriptionFocus.unfocus();
    await showReportExplanation(context, title, message);
  }

  // Tombol kembali dan navbar memakai proteksi isian yang sama tanpa dialog ganda.
  Future<void> _leave() async {
    if (_confirmingExit) return;
    if (_hasInput) {
      _confirmingExit = true;
      final restoreFocus = _descriptionFocus.hasFocus;
      _descriptionFocus.unfocus();
      final discard = await confirmReportExit(context);
      _confirmingExit = false;
      if (!mounted) return;
      if (discard != true) {
        if (restoreFocus) _descriptionFocus.requestFocus();
        return;
      }
    }
    if (mounted) Navigator.pop(context);
  }

  // Mengetuk tab aktif kembali ke awal form, seperti tab Beranda pada home.
  void _navigate(CitizenDestination destination) {
    switch (destination) {
      case CitizenDestination.home:
        _leave();
      case CitizenDestination.report:
        if (MediaQuery.disableAnimationsOf(context)) {
          _scroll.jumpTo(0);
        } else {
          _scroll.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      case CitizenDestination.history:
        widget.onHistory();
      case CitizenDestination.profile:
        widget.onProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sembunyikan header/navbar saat keyboard terbuka agar ruang mengetik tetap lapang.
    final typing = MediaQuery.viewInsetsOf(context).bottom > 0;
    return PopScope(
      canPop: LingkupNavigasi.aktif(context) || !_hasInput,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: !LingkupNavigasi.aktif(context),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  if (!typing)
                    if (!LingkupNavigasi.aktif(context))
                      CitizenHeader(onNotifications: widget.onNotifications),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: FormulirLaporan(
                        foto: _foto?.bytes,
                        memuatFoto: _memuatFoto,
                        description: _description,
                        descriptionFocus: _descriptionFocus,
                        category: _category,
                        needs: _needs,
                        onDescriptionChanged: (_) => setState(() {}),
                        onCategoryChanged: (value) =>
                            setState(() => _category = value),
                        onNeedChanged: (value) => setState(() {
                          if (!_needs.add(value)) {
                            _needs.remove(value);
                          }
                        }),
                        onCamera: _ambilFoto,
                        onLocation: () => _explain(
                          'Lokasi Terdeteksi',
                          'Koto Tangah, Padang (Akurasi GPS terverifikasi)',
                        ),
                        onSubmit: _simpan,
                      ),
                    ),
                  ),
                  if (!typing)
                    if (!LingkupNavigasi.aktif(context))
                      CitizenNavigation(
                        selected: CitizenDestination.report,
                        onSelect: _navigate,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
