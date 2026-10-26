import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/contact_entry.dart';
import 'widgets/contact_card.dart';
import 'widgets/contacts_filter_tabs.dart';
import 'widgets/contacts_header.dart';

// Layar Direktori Kontak Darurat sesuai SVG contacts_directory.
// Menampilkan kontak publik (FR-READY-003); data sintetis, nomor contoh tidak diklaim resmi.
class ContactsDirectoryScreen extends StatefulWidget {
  const ContactsDirectoryScreen({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<ContactsDirectoryScreen> createState() =>
      _ContactsDirectoryScreenState();
}

class _ContactsDirectoryScreenState extends State<ContactsDirectoryScreen> {
  // null = Semua kategori.
  ContactCategory? _selectedCategory;

  List<ContactEntry> get _filteredContacts {
    if (_selectedCategory == null) return kPublicContacts;
    return kPublicContacts
        .where((c) => c.category == _selectedCategory)
        .toList();
  }

  Map<ContactCategory?, int> get _counts => {
    null: kPublicContacts.length,
    for (final cat in ContactCategory.values)
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
  Future<void> _copyNumber(ContactEntry contact) async {
    await Clipboard.setData(ClipboardData(text: contact.phone));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Nomor ${contact.phone} disalin.',
            style: const TextStyle(fontSize: 14),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              ContactsHeader(onBack: () => Navigator.pop(context)),
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
                      fontSize: 12,
                      color: Color(0xFF78350F),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              ContactsFilterTabs(
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
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding:
                            const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        itemCount: _filteredContacts.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (_, index) {
                          final contact = _filteredContacts[index];
                          return ContactCard(
                            contact: contact,
                            onCopy: () => _copyNumber(contact),
                          );
                        },
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
