import '../../../core/jaringan/identitas_aksi.dart';
import '../../../core/perangkat/layanan_lokasi.dart';
import '../data/laporan_repository.dart';
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
    this.layananLokasi,
    this.fotoDipulihkan,
    this.laporanRepository,
    required this.onNotifications,
    required this.onHistory,
    required this.onProfile,
  });

  final ValueChanged<EntriRiwayatLaporan>? onSimpan;
  final VoidCallback onNotifications;
  final VoidCallback onHistory;
  final VoidCallback onProfile;
  final LayananFoto? layananFoto;
  final LayananLokasi? layananLokasi;
  final ValueNotifier<FotoPilihan?>? fotoDipulihkan;
  final LaporanRepository? laporanRepository;

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

  // Koordinat GPS nyata; kosong sampai perangkat memberi posisi valid.
  String _alamatLokasi = 'Menunggu lokasi GPS…';
  String _keteranganLokasi = 'Aktifkan GPS agar titik laporan terverifikasi';
  double? _latitude;
  double? _longitude;
  bool _memuatLokasi = false;

  @override
  void initState() {
    super.initState();
    _foto = widget.fotoDipulihkan?.value;
    widget.fotoDipulihkan?.addListener(_terimaFoto);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sinkronisasiGps();
    });
  }

  Future<void> _sinkronisasiGps() async {
    if (_memuatLokasi) return;
    setState(() {
      _memuatLokasi = true;
    });
    try {
      final posisi = await (widget.layananLokasi ?? const LayananLokasi())
          .ambilPosisi();
      if (!mounted) return;
      setState(() {
        _latitude = posisi.latitude;
        _longitude = posisi.longitude;
        _alamatLokasi = 'Titik GPS ${posisi.labelKoordinat}';
        _keteranganLokasi =
            'Akurasi ±${posisi.akurasiMeter.toStringAsFixed(0)} m · diperbarui otomatis';
      });
    } on LokasiTidakTersediaException catch (e) {
      if (!mounted) return;
      setState(() {
        _latitude = null;
        _longitude = null;
        _alamatLokasi = 'Lokasi belum tersedia';
        _keteranganLokasi = e.pesan;
      });
    } catch (_) {
      if (!mounted) return;
      const pesan =
          'Lokasi belum dapat dibaca. Periksa GPS dan izin lokasi lalu coba lagi.';
      setState(() {
        _latitude = null;
        _longitude = null;
        _alamatLokasi = 'Lokasi belum tersedia';
        _keteranganLokasi = pesan;
      });
    } finally {
      if (mounted) setState(() => _memuatLokasi = false);
    }
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
    if (_latitude == null || _longitude == null) {
      await _explain(
        'Lokasi belum terverifikasi',
        'Laporan memerlukan titik GPS nyata agar petugas dapat menemukan lokasi kejadian. '
            'Aktifkan GPS, izinkan akses lokasi, lalu tekan Perbarui Lokasi.',
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

    // Hubungkan pengiriman laporan ke backend jika tersedia
    final laporanRepo = widget.laporanRepository ?? LaporanRepository();
    final submissionId = identitasAksi();
    String? pesanGalat;
    try {
      final uploadIds = <String>[];
      // Hanya foto asli warga yang diunggah; tidak ada lagi bukti contoh
      // bawaan yang bisa membuat laporan tampak terverifikasi.
      final foto = _foto;
      if (foto != null) {
        final idUnggahan = await laporanRepo.unggahFotoBukti(
          uploadId: identitasAksi(),
          bytes: foto.bytes,
        );
        uploadIds.add(idUnggahan);
      }
      await laporanRepo.kirimLaporan(
        submissionId: submissionId,
        kategori: _category!,
        deskripsi: _description.text.trim(),
        kebutuhan: List.unmodifiable(_needs),
        uploadIds: uploadIds,
        latitude: _latitude!,
        longitude: _longitude!,
        alamat: _alamatLokasi,
      );
    } catch (e) {
      // Kegagalan server tidak lagi ditelan diam-diam; catatan tetap disimpan
      // lokal agar isian warga tidak hilang, disertai pemberitahuan jujur.
      pesanGalat = e.toString();
      debugPrint('Pengiriman laporan ke server: $e');
    }

    if (!mounted) return;

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
    final messenger = ScaffoldMessenger.of(context);
    if (pesanGalat != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Laporan tersimpan lokal, tetapi gagal dikirim ke server: $pesanGalat',
          ),
          backgroundColor: const Color(0xFFB91C1C),
          duration: const Duration(seconds: 6),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Laporan berhasil disimpan ke Riwayat.')),
      );
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
                        onLocation: _sinkronisasiGps,
                        lokasi: _alamatLokasi,
                        keteranganLokasi: _keteranganLokasi,
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
