import '../data/layanan_berkas.dart';

import 'package:siagabanjir/shared/widgets/dialog_siaga.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import 'models/dokumen_keluarga.dart';
import 'widgets/tombol_aksi_dokumen.dart';
import 'widgets/header_dokumen.dart';
import 'widgets/banner_info_dokumen.dart';
import 'widgets/kartu_dokumen_siaga.dart';

// Layar Brankas Dokumen Siaga Keluarga sesuai desain spesifikasi documents_vault.svg.
// Pemilihan dan ekspor berkas lokal; brankas terenkripsi belum terintegrasi.
class LayarDokumenSiaga extends StatefulWidget {
  const LayarDokumenSiaga({
    super.key,
    this.onHome,
    this.layananBerkas,
    this.onReport,
    this.onHistory,
    this.onProfile,
    this.onSaveDocuments,
    this.onDownloadZip,
    this.onChangeDocument,
    this.initialDocuments = kDefaultFamilyDocuments,
  });

  final LayananBerkas? layananBerkas;
  final VoidCallback? onHome;
  final VoidCallback? onReport;
  final VoidCallback? onHistory;
  final VoidCallback? onProfile;
  final VoidCallback? onSaveDocuments;
  final VoidCallback? onDownloadZip;
  final ValueChanged<DokumenKeluarga>? onChangeDocument;
  final List<DokumenKeluarga> initialDocuments;

  @override
  State<LayarDokumenSiaga> createState() => _LayarDokumenSiagaState();
}

class _LayarDokumenSiagaState extends State<LayarDokumenSiaga> {
  final _scroll = ScrollController();
  final _berkas = <String, BerkasPilihan>{};
  bool _sibuk = false;
  late final _layanan = widget.layananBerkas ?? LayananBerkas();
  late List<DokumenKeluarga> _documents;

  @override
  void initState() {
    super.initState();
    _documents = List.of(widget.initialDocuments);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleChangeDocument(DokumenKeluarga doc) async {
    if (_sibuk) return;
    if (widget.onChangeDocument != null) {
      widget.onChangeDocument!(doc);
      return;
    }
    final pilih = await showDialog<bool>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: Text('Ganti ${doc.numberTitle}'),
        content: const Text(
          'Pilih PDF atau gambar JPG/PNG maksimal 5 MB. Gunakan berkas uji. Berkas berada dalam memori halaman ini sampai Anda mengekspor ZIP; belum ada brankas terenkripsi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Pilih Berkas'),
          ),
        ],
      ),
    );
    if (pilih != true || !mounted) return;
    setState(() => _sibuk = true);
    try {
      final hasil = await _layanan.pilih();
      if (hasil == null || !mounted) return;
      setState(() {
        _berkas[doc.id] = hasil;
        _documents = _documents
            .map(
              (item) => item.id == doc.id
                  ? item.copyWith(
                      fileName: hasil.nama,
                      fileSize: hasil.ukuran,
                      fileType: hasil.ekstensi.toUpperCase(),
                      status: 'Dipilih • belum diekspor',
                    )
                  : item,
            )
            .toList();
      });
    } catch (_) {
      if (mounted) {
        await tampilkanInfoSiaga(
          context,
          'Berkas belum dapat dipilih',
          'Gunakan PDF, JPG atau PNG yang valid, maksimal 5 MB. Berkas sebelumnya tetap ada.',
        );
      }
    } finally {
      if (mounted) setState(() => _sibuk = false);
    }
  }

  void _handleSave() {
    if (widget.onSaveDocuments != null) {
      widget.onSaveDocuments!();
      return;
    }
    if (_berkas.isEmpty) {
      _showFeedback('Pilih berkas melalui tombol Ganti terlebih dahulu.');
      return;
    }
    setState(
      () => _documents = _documents
          .map(
            (doc) => _berkas.containsKey(doc.id)
                ? doc.copyWith(status: 'Siap diekspor • sesi ini')
                : doc,
          )
          .toList(),
    );
    _showFeedback(
      'Pilihan dikonfirmasi untuk sesi ini. Ekspor ZIP untuk menyimpan salinan.',
    );
  }

  Future<void> _handleDownloadZip() async {
    if (_sibuk) return;
    if (widget.onDownloadZip != null) {
      widget.onDownloadZip!();
      return;
    }
    if (_berkas.isEmpty) {
      _showFeedback('Pilih berkas melalui tombol Ganti terlebih dahulu.');
      return;
    }
    final lanjut = await showDialog<bool>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Ekspor salinan dokumen?'),
        content: Text(
          'ZIP berisi ${_berkas.length} berkas yang Anda pilih. Berkas contoh tidak disertakan. Salinan ZIP tidak terenkripsi; pilih lokasi penyimpanan yang Anda percaya.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ekspor ZIP'),
          ),
        ],
      ),
    );
    if (lanjut != true || !mounted) return;
    setState(() => _sibuk = true);
    try {
      final berhasil = await _layanan.ekspor(Map.of(_berkas));
      if (mounted && berhasil) {
        _showFeedback('Ekspor ZIP diteruskan ke penyimpanan perangkat.');
      }
    } catch (_) {
      if (mounted) {
        await tampilkanInfoSiaga(
          context,
          'Ekspor belum berhasil',
          'Coba lagi dan pilih lokasi penyimpanan yang tersedia. Berkas tetap ada selama halaman ini terbuka.',
        );
      }
    } finally {
      if (mounted) setState(() => _sibuk = false);
    }
  }

  void _onNavigationSelect(CitizenDestination destination) {
    switch (destination) {
      case CitizenDestination.home:
        if (widget.onHome != null) {
          widget.onHome!();
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      case CitizenDestination.report:
        widget.onReport?.call();
      case CitizenDestination.history:
        widget.onHistory?.call();
      case CitizenDestination.profile:
        widget.onProfile?.call();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: SiagaTheme.background,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              HeaderDokumen(
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else if (widget.onHome != null) {
                    widget.onHome!();
                  }
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('documents-vault-scroll'),
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Judul utama halaman dan deskripsi tujuan
                      const Text(
                        'Dokumen Siaga Keluarga',
                        style: TextStyle(
                          fontSize: SiagaTheme.judulHalaman,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Simpan cadangan berkas kependudukan untuk pengurusan pasca-banjir.',
                        style: TextStyle(
                          fontSize: SiagaTheme.isi,
                          fontWeight: FontWeight.w400,
                          color: SiagaTheme.muted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Kartu daftar dokumen sipil
                      KartuDokumenSiaga(
                        documents: _documents,
                        onChangeDocument: _handleChangeDocument,
                      ),
                      const SizedBox(height: 16),

                      // Banner perlindungan data sipil
                      const BannerInfoDokumen(),
                      const SizedBox(height: 20),

                      if (_sibuk)
                        const LinearProgressIndicator(
                          semanticsLabel: 'Memproses berkas',
                        ),
                      // Tombol aksi: simpan & unduh zip
                      TombolAksiDokumen(
                        onSave: _handleSave,
                        onDownloadZip: _handleDownloadZip,
                      ),
                    ],
                  ),
                ),
              ),
              if (!LingkupNavigasi.aktif(context))
                CitizenNavigation(
                  selected: CitizenDestination.home,
                  onSelect: _onNavigationSelect,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
