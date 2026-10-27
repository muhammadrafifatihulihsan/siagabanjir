import 'package:siagabanjir/shared/theme/siaga_theme.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/widgets/citizen_navigation.dart';
import 'models/pesan_siaga.dart';
import 'widgets/kartu_pesan.dart';
import 'widgets/dialog_pesan.dart';
import 'widgets/tab_filter_pesan.dart';
import '../../../shared/widgets/header_halaman.dart';

// Layar Kotak Masuk Pesan Peringatan Siaga sesuai SVG messages_inbox.
class LayarKotakMasuk extends StatefulWidget {
  const LayarKotakMasuk({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<LayarKotakMasuk> createState() => _LayarKotakMasukState();
}

class _LayarKotakMasukState extends State<LayarKotakMasuk> {
  KategoriPesan _selectedCategory = KategoriPesan.all;

  // Filter daftar pesan berdasarkan kategori tab terpilih.
  List<PesanSiaga> get _filteredMessages {
    if (_selectedCategory == KategoriPesan.all) {
      return kSampleSiagaMessages;
    }
    return kSampleSiagaMessages
        .where((msg) => msg.category == _selectedCategory)
        .toList();
  }

  // Hitung pesan dengan status baru untuk indikator header.
  int get _unreadCount => kSampleSiagaMessages.where((msg) => msg.isNew).length;

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
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              HeaderHalaman(
                judul: 'Peringatan Siaga',
                onBack: () => Navigator.pop(context),
                keterangan: '$_unreadCount Baru',
              ),
              TabFilterPesan(
                selected: _selectedCategory,
                onSelect: (category) =>
                    setState(() => _selectedCategory = category),
                totalCount: kSampleSiagaMessages.length,
                emergencyCount: kSampleSiagaMessages
                    .where((m) => m.category == KategoriPesan.emergency)
                    .length,
                weatherCount: kSampleSiagaMessages
                    .where((m) => m.category == KategoriPesan.weather)
                    .length,
              ),
              Expanded(
                child: _filteredMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada pesan pada kategori ini.',
                          style: TextStyle(
                            fontSize: SiagaTheme.isi,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        itemCount: _filteredMessages.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final msg = _filteredMessages[index];
                          return KartuPesan(
                            message: msg,
                            onAction: (action) => showMessageActionExplanation(
                              context,
                              action,
                              msg,
                            ),
                            onTap: () => showMessageDetail(context, msg),
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
