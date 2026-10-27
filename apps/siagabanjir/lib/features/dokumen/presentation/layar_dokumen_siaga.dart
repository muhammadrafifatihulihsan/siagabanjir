import 'package:flutter/material.dart';

import '../../../core/perangkat/layanan_foto.dart';
import '../../../shared/widgets/dialog_siaga.dart';
import '../../../shared/widgets/lingkup_navigasi.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../data/layanan_berkas.dart';
import '../../../shared/widgets/header_halaman.dart';
import 'widgets/formulir_dokumen.dart';

typedef DokumenSesi = ({String kategori, BerkasPilihan berkas});

class LayarDokumenSiaga extends StatefulWidget {
  const LayarDokumenSiaga({
    super.key,
    this.onHome,
    this.onReport,
    this.onHistory,
    this.onProfile,
    this.layananBerkas,
    this.layananFoto,
    this.dokumen,
  });
  final VoidCallback? onHome, onReport, onHistory, onProfile;
  final LayananBerkas? layananBerkas;
  final LayananFoto? layananFoto;
  final ValueNotifier<List<DokumenSesi>>? dokumen;
  @override
  State<LayarDokumenSiaga> createState() => _LayarDokumenSiagaState();
}

class _LayarDokumenSiagaState extends State<LayarDokumenSiaga> {
  late final _dokumen = widget.dokumen ?? ValueNotifier<List<DokumenSesi>>([]);
  late final _layanan = widget.layananBerkas ?? LayananBerkas();
  bool _sibuk = false;
  bool _mengisiFormulir = false;
  @override
  void dispose() {
    if (widget.dokumen == null) _dokumen.dispose();
    super.dispose();
  }

  void _showFeedback(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> _tambah() async {
    if (_sibuk) return;
    final sumber = await showDialog<String>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Tambah Dokumen'),
        content: const Text(
          'Pilih PDF/gambar atau foto dokumen dengan kamera. Maksimal 5 MB. Scan menghasilkan foto, tanpa ekstraksi teks otomatis.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(ctx, 'kamera'),
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Scan dengan Kamera'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, 'berkas'),
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Pilih PDF / Gambar'),
          ),
        ],
      ),
    );
    if (sumber == null || !mounted) return;
    setState(() => _sibuk = true);
    try {
      BerkasPilihan? berkas;
      if (sumber == 'kamera') {
        final foto = await (widget.layananFoto ?? LayananFoto()).ambil();
        if (foto != null) berkas = BerkasPilihan(foto.nama, foto.bytes);
      } else {
        berkas = await _layanan.pilih();
      }
      if (!mounted || berkas == null) return;
      LayananBerkas.validasi(berkas);
      setState(() => _mengisiFormulir = true);
      final hasil = await showDialog<DokumenSesi>(
        context: context,
        builder: (_) => FormulirDokumen(berkas: berkas!),
      );
      if (!mounted || hasil == null) return;
      _dokumen.value = [..._dokumen.value, hasil];
      _showFeedback(
        '${hasil.berkas.nama} berhasil ditambahkan untuk sesi ini.',
      );
    } catch (_) {
      if (mounted) {
        await tampilkanInfoSiaga(
          context,
          'Dokumen belum dapat ditambahkan',
          'Pilih PDF, JPG, atau PNG yang valid maksimal 5 MB. Untuk kamera, periksa izin perangkat lalu coba lagi.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _sibuk = false;
          _mengisiFormulir = false;
        });
      }
    }
  }

  Future<void> _hapus(int index) async {
    final item = _dokumen.value[index];
    final hapus = await showDialog<bool>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Hapus dokumen?'),
        content: Text(
          '${item.berkas.nama} akan dihapus dari sesi ini. Berkas asli tetap ada.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (mounted && hapus == true) {
      _dokumen.value = [..._dokumen.value]..removeAt(index);
    }
  }

  Future<void> _handleDownloadZip() async {
    if (_sibuk) return;
    if (_dokumen.value.isEmpty) {
      _showFeedback('Tambahkan dokumen terlebih dahulu.');
      return;
    }
    final lanjut = await showDialog<bool>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Ekspor salinan dokumen?'),
        content: Text(
          'ZIP berisi ${_dokumen.value.length} berkas yang Anda pilih. Salinan ZIP tidak terenkripsi; pilih lokasi penyimpanan yang Anda percaya.',
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
      final berhasil = await _layanan.ekspor({
        for (var i = 0; i < _dokumen.value.length; i++)
          '${i + 1}': _dokumen.value[i].berkas,
      });
      if (mounted && berhasil) {
        _showFeedback('Ekspor ZIP diteruskan ke penyimpanan perangkat.');
      }
    } catch (_) {
      if (mounted) {
        await tampilkanInfoSiaga(
          context,
          'Ekspor belum berhasil',
          'Coba lagi dan pilih lokasi penyimpanan yang tersedia. Berkas tetap ada selama sesi ini.',
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
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              HeaderHalaman(
                judul: 'Dokumen Siaga',
                onBack: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    widget.onHome?.call();
                  }
                },
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _dokumen,
                  builder: (context, daftar, _) => ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      const Text(
                        'Simpan salinan digital KTP, KK, dan dokumen penting keluarga agar aman dan mudah diakses saat darurat.',
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _sibuk ? null : _tambah,
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Dokumen'),
                      ),
                      const SizedBox(height: 16),
                      if (_sibuk && !_mengisiFormulir)
                        const LinearProgressIndicator(
                          semanticsLabel: 'Memproses dokumen',
                        ),
                      if (daftar.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Text(
                            'Belum ada dokumen. Tambahkan berkas pertama Anda.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      for (var i = 0; i < daftar.length; i++)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.description_outlined,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        daftar[i].berkas.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${daftar[i].kategori} • ${daftar[i].berkas.ukuran}',
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Hapus ${daftar[i].berkas.nama}',
                                  onPressed: _sibuk ? null : () => _hapus(i),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (daftar.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _sibuk ? null : _handleDownloadZip,
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('Ekspor ZIP'),
                        ),
                      ],
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
