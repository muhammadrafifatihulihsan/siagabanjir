import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import 'package:flutter/services.dart';

import '../../../shared/widgets/citizen_navigation.dart';
import 'models/entri_kontak.dart';
import 'widgets/kartu_kontak.dart';
import 'widgets/tab_filter_kontak.dart';
import 'widgets/header_kontak.dart';
import 'widgets/kartu_bantuan.dart';

// Layar Direktori Kontak Darurat sesuai SVG contacts_directory.
// Menampilkan kontak publik (FR-READY-003); data sintetis, nomor contoh tidak diklaim resmi.
class LayarDirektoriKontak extends StatefulWidget {
  const LayarDirektoriKontak({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<LayarDirektoriKontak> createState() => _LayarDirektoriKontakState();
}

class _LayarDirektoriKontakState extends State<LayarDirektoriKontak> {
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
              HeaderKontak(onBack: () => Navigator.pop(context)),
              // Catatan data sintetis — sesuai FRD AC-READY-003-02.
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF9C3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Text(
                    'Data contoh — nomor belum diverifikasi resmi. Salin nomor untuk menghubungi melalui dialer.',
                    style: TextStyle(
                      fontSize: SiagaTheme.keterangan,
                      color: Color(0xFF78350F),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              TabFilterKontak(
                selected: _selectedCategory,
                onSelect: (cat) => setState(() => _selectedCategory = cat),
                counts: _counts,
              ),
              Expanded(
                child: _filteredContacts.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada kontak pada kategori ini.',
                          style: TextStyle(
                            fontSize: SiagaTheme.isi,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        itemCount:
                            _filteredContacts.length +
                            (_selectedCategory == null ? 2 : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (_, index) {
                          if (_selectedCategory == null && index == 0) {
                            return const KartuBantuan();
                          }
                          if (_selectedCategory == null &&
                              index == _filteredContacts.length + 1) {
                            return const KartuBantuan(posko: true);
                          }
                          final contact =
                              _filteredContacts[index -
                                  (_selectedCategory == null ? 1 : 0)];
                          return KartuKontak(
                            contact: contact,
                            onCopy: () => _copyNumber(contact),
                          );
                        },
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
