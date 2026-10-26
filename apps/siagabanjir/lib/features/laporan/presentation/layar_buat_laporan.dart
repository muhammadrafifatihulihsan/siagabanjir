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
    this.scrollController,
    this.layananFoto,
    this.fotoDipulihkan,
    required this.onNotifications,
    required this.onHistory,
    required this.onProfile,
  });

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
                          'GPS belum tersedia',
                          'Alamat yang tampil adalah contoh. Lokasi perangkat belum dibaca.',
                        ),
                        onSubmit: () => _explain(
                          'Laporan belum dikirim',
                          'Pengiriman dan penyimpanan belum tersedia. Isian tetap ada selama halaman ini terbuka.',
                        ),
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
