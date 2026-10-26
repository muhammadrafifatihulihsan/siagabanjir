import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/document_entry.dart';
import 'widgets/document_card.dart';
import 'widgets/documents_bottom_actions.dart';
import 'widgets/documents_header.dart';
import 'widgets/documents_security_banner.dart';
import 'widgets/documents_summary_card.dart';

// Layar Dokumen Siaga / Brankas Dokumen Keluarga persis sesuai desain referensi documents_vault.svg.
class DocumentsVaultScreen extends StatefulWidget {
  const DocumentsVaultScreen({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<DocumentsVaultScreen> createState() => _DocumentsVaultScreenState();
}

class _DocumentsVaultScreenState extends State<DocumentsVaultScreen> {
  late List<DocumentEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = List.of(kDefaultDocumentEntries);
  }

  void _onChangeFile(String id) {
    final entry = _entries.firstWhere((e) => e.id == id);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ganti ${entry.categoryTitle}'),
        content: Text(
          'Pilih dokumen pengganti untuk "${entry.fileName}".\n\nFormat didukung: PDF, JPG, PNG (Maks 10 MB per berkas).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Berkas ${entry.categoryTitle} berhasil diperbarui.'),
                    backgroundColor: SiagaTheme.blue,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SiagaTheme.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Pilih Berkas'),
          ),
        ],
      ),
    );
  }

  void _onSaveAndEncrypt() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Seluruh dokumen siaga telah diamankan & dienkripsi secara lokal.'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
  }

  void _onDownloadZip() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Mengunduh arsip berkas digital terenkripsi (ZIP)...'),
          backgroundColor: SiagaTheme.blue,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
  }

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

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8FAFC),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              DocumentsHeader(
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('documents-vault-scroll'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DocumentsSummaryCard(entries: _entries),
                      const SizedBox(height: 18),
                      for (final entry in _entries) ...[
                        DocumentCard(
                          entry: entry,
                          onChangeFile: _onChangeFile,
                        ),
                        const SizedBox(height: 16),
                      ],
                      const DocumentsSecurityBanner(),
                      const SizedBox(height: 20),
                      DocumentsBottomActions(
                        onSaveAndEncrypt: _onSaveAndEncrypt,
                        onDownloadZip: _onDownloadZip,
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
