import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import 'package:flutter/services.dart';

import '../../../shared/widgets/citizen_navigation.dart';
import 'models/entri_kontak.dart';
import 'widgets/kartu_kontak.dart';
import 'widgets/tab_filter_kontak.dart';
import '../../../shared/widgets/header_halaman.dart';
import '../domain/kontak_darurat.dart';
import 'widgets/kontak_pribadi.dart';

// Layar Direktori Kontak Darurat sesuai SVG contacts_directory.
// Menampilkan kontak publik (FR-READY-003); data sintetis, nomor contoh tidak diklaim resmi.
class LayarDirektoriKontak extends StatefulWidget {
  const LayarDirektoriKontak({
    super.key,
    this.kontakPribadi,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final ValueNotifier<List<KontakDarurat>>? kontakPribadi;
  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<LayarDirektoriKontak> createState() => _LayarDirektoriKontakState();
}

class _LayarDirektoriKontakState extends State<LayarDirektoriKontak> {
  late final _pribadi =
      widget.kontakPribadi ?? ValueNotifier<List<KontakDarurat>>([]);
  @override
  void dispose() {
    if (widget.kontakPribadi == null) _pribadi.dispose();
    super.dispose();
  }

  // null = Semua kategori.
  KategoriKontak? _selectedCategory;

  List<EntriKontak> get _filteredContacts {
    if (_selectedCategory == null) return kPublicContacts;
    return kPublicContacts
        .where((c) => c.category == _selectedCategory)
        .toList();
  }

  Map<KategoriKontak?, int> get _counts => {
    null: kPublicContacts.length,
    for (final cat in KategoriKontak.values)
      cat: kPublicContacts.where((c) => c.category == cat).length,
  };

  void _onNavigationSelect(CitizenDestination destination) {
    switch (destination) {
      case CitizenDestination.home:
        Navigator.pop(context);
      case CitizenDestination.report:
        widget.onReport();
      case CitizenDestination.history:
        widget.onHistory();
      case CitizenDestination.profile:
        widget.onProfile();
    }
  }

  // Salin nomor ke clipboard dan tampilkan snackbar konfirmasi.
  // Tidak membuka dialer; warga memilih sendiri cara menghubungi (FR-READY-003).
  Future<void> _copyNumber(EntriKontak contact) async {
    await Clipboard.setData(ClipboardData(text: contact.phone));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Nomor ${contact.phone} disalin.',
            style: const TextStyle(fontSize: SiagaTheme.isi),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
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
                judul: 'Kontak Darurat',
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    KontakPribadi(kontak: _pribadi),
                    const SizedBox(height: 24),
                    const Text(
                      'Kontak Umum',
                      style: TextStyle(
                        fontSize: SiagaTheme.judulBagian,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nomor di bawah adalah contoh dan belum diverifikasi. Tidak untuk panggilan darurat nyata.',
                    ),
                    const SizedBox(height: 12),
                    TabFilterKontak(
                      selected: _selectedCategory,
                      onSelect: (cat) =>
                          setState(() => _selectedCategory = cat),
                      counts: _counts,
                    ),
                    for (final contact in _filteredContacts) ...[
                      KartuKontak(
                        contact: contact,
                        onCopy: () => _copyNumber(contact),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (_filteredContacts.isEmpty)
                      const Text('Tidak ada kontak pada kategori ini.'),
                  ],
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
