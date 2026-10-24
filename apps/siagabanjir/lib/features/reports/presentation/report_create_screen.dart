import 'package:flutter/material.dart';

import '../../../shared/widgets/citizen_header.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import 'widgets/report_form.dart';
import 'widgets/report_dialogs.dart';

// Layar hanya mengelola state lokal dan navigasi; bagian visual dipisah per tugas.
class ReportCreateScreen extends StatefulWidget {
  const ReportCreateScreen({
    super.key,
    required this.onNotifications,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onNotifications;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<ReportCreateScreen> createState() => _ReportCreateScreenState();
}

class _ReportCreateScreenState extends State<ReportCreateScreen> {
  // Isian dimulai kosong agar kebutuhan warga tidak terpilih tanpa persetujuan.
  final _description = TextEditingController();
  final _descriptionFocus = FocusNode();
  final _scroll = ScrollController();
  String? _category;
  final _needs = <String>{};
  bool _confirmingExit = false;

  // Membatalkan semua isian mengembalikan form ke kondisi bersih.
  bool get _hasInput =>
      _description.text.isNotEmpty || _category != null || _needs.isNotEmpty;

  @override
  void dispose() {
    // Controller dan fokus dilepas ketika route ditutup agar tidak menahan resource.
    _description.dispose();
    _descriptionFocus.dispose();
    _scroll.dispose();
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
      canPop: !_hasInput,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  if (!typing)
                    CitizenHeader(onNotifications: widget.onNotifications),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: ReportForm(
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
                        onCamera: () => _explain(
                          'Kamera belum tersedia',
                          'Kamera dan lampiran foto belum dihubungkan pada pratinjau ini.',
                        ),
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
