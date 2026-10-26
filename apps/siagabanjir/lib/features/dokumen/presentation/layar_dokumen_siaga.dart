import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import 'models/dokumen_keluarga.dart';
import 'widgets/tombol_aksi_dokumen.dart';
import 'widgets/header_dokumen.dart';
import 'widgets/banner_info_dokumen.dart';
import 'widgets/kartu_dokumen_siaga.dart';

// Layar Brankas Dokumen Siaga Keluarga sesuai desain spesifikasi documents_vault.svg.
// Memfasilitasi penyimpanan cadangan berkas kependudukan vital (KK, KTP, Akta Kelahiran)
// secara terenkripsi di perangkat untuk pengurusan administrasi kependudukan pasca-banjir.
class LayarDokumenSiaga extends StatefulWidget {
  const LayarDokumenSiaga({
    super.key,
    this.onHome,
    this.onReport,
    this.onHistory,
    this.onProfile,
    this.onSaveDocuments,
    this.onDownloadZip,
    this.onChangeDocument,
    this.initialDocuments = kDefaultFamilyDocuments,
  });

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

  void _handleChangeDocument(DokumenKeluarga doc) {
    if (widget.onChangeDocument != null) {
      widget.onChangeDocument!(doc);
    } else {
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: Text('Ganti ${doc.numberTitle}'),
          content: Text(
            'Pilih berkas pengganti untuk ${doc.fileName} dari penyimpanan perangkat '
            '(format PDF atau Gambar JPG/PNG maksimal 5 MB).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                _showFeedback('Pilih berkas baru untuk ${doc.numberTitle}.');
              },
              child: const Text('Pilih Berkas'),
            ),
          ],
        ),
      );
    }
  }

  void _handleSave() {
    _showFeedback('Dokumen siaga keluarga berhasil disimpan dan diperbarui.');
    widget.onSaveDocuments?.call();
  }

  void _handleDownloadZip() {
    _showFeedback(
      'Menyiapkan paket berkas dinas (ZIP) untuk pengurusan Disdukcapil...',
    );
    widget.onDownloadZip?.call();
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
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Simpan cadangan berkas kependudukan untuk pengurusan pasca-banjir.',
                        style: TextStyle(
                          fontSize: 13,
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

                      // Tombol aksi: simpan & unduh zip
                      TombolAksiDokumen(
                        onSave: _handleSave,
                        onDownloadZip: _handleDownloadZip,
                      ),
                    ],
                  ),
                ),
              ),
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
