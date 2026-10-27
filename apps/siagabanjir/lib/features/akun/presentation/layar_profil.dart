import 'package:flutter/material.dart';

import '../../../core/perangkat/layanan_foto.dart';
import '../../../shared/widgets/dialog_siaga.dart';
import 'widgets/formulir_profil.dart';
import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_header.dart';
import '../../beranda/presentation/aksi_beranda.dart';
import '../../beranda/presentation/widgets/navigasi_beranda.dart';
import '../domain/profil_pengguna.dart';
import 'widgets/bagian_pengaturan_akun.dart';
import 'widgets/tombol_keluar.dart';
import 'widgets/kartu_header_profil.dart';
import 'widgets/bagian_info_profil.dart';

class LayarProfil extends StatefulWidget {
  const LayarProfil({
    super.key,
    this.scrollController,
    required this.onOpen,
    required this.onHome,
    this.initialProfile = ProfilPengguna.defaultMock,
    this.layananFoto,
    this.onLogout,
  });

  final ValueChanged<AksiBeranda> onOpen;
  final VoidCallback onHome;
  final ProfilPengguna initialProfile;
  final LayananFoto? layananFoto;
  final VoidCallback? onLogout;

  final ScrollController? scrollController;

  @override
  State<LayarProfil> createState() => _LayarProfilState();
}

class _LayarProfilState extends State<LayarProfil> {
  late final _scroll = widget.scrollController ?? ScrollController();
  late bool _floodAlertEnabled;
  late ProfilPengguna _profil;
  FotoPilihan? _foto;

  Future<void> _editProfil() async {
    final hasil =
        await showDialog<({ProfilPengguna profil, FotoPilihan? foto})>(
          context: context,
          builder: (_) => FormulirProfil(
            profil: _profil,
            foto: _foto,
            layananFoto: widget.layananFoto,
          ),
        );
    if (hasil != null && mounted) {
      setState(() {
        _profil = hasil.profil;
        _foto = hasil.foto;
      });
      _showFeedback('Profil berhasil diperbarui.');
    }
  }

  @override
  void initState() {
    super.initState();
    _floodAlertEnabled = widget.initialProfile.floodAlertEnabled;
    _profil = widget.initialProfile;
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _scroll.dispose();
    super.dispose();
  }

  void _backToTop() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(0);
    } else {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
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

  void _confirmLogout() {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => DialogSiaga(
        title: const Text('Keluar dari Akun?'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun SiagaBanjir?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        (widget.onLogout ?? widget.onHome)();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              if (!LingkupNavigasi.aktif(context))
                CitizenHeader(
                  onNotifications: () =>
                      widget.onOpen(AksiBeranda.notifications),
                ),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('profile-scroll'),
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Profil Pengguna',
                        style: TextStyle(
                          fontSize: SiagaTheme.judulHalaman,
                          fontWeight: FontWeight.w800,
                          color: SiagaTheme.ink,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      KartuHeaderProfil(
                        profile: _profil,
                        onEdit: _editProfil,
                        foto: _foto?.bytes,
                      ),
                      const SizedBox(height: 20),
                      BagianInfoProfil(profile: _profil),
                      const SizedBox(height: 20),
                      BagianPengaturanAkun(
                        floodAlertEnabled: _floodAlertEnabled,
                        appVersion: widget.initialProfile.appVersion,
                        onToggleFloodAlert: (val) {
                          setState(() => _floodAlertEnabled = val);
                          _showFeedback(
                            val
                                ? 'Notifikasi peringatan banjir diaktifkan.'
                                : 'Notifikasi peringatan banjir dinonaktifkan.',
                          );
                        },
                        onSecurity: () => tampilkanInfoSiaga(
                          context,
                          'Keamanan & Kata Sandi',
                          'Fitur penggantian kata sandi dan pengaturan keamanan akun.',
                        ),
                        onHelpFaq: () => tampilkanInfoSiaga(
                          context,
                          'Pusat Bantuan & FAQ',
                          'Pusat bantuan SiagaBanjir. Pantau status debit air sungai, siapkan tas siaga bencana, dan ikuti panduan evakuasi darurat.',
                        ),
                        onPrivacy: () => tampilkanInfoSiaga(
                          context,
                          'Privasi Data',
                          'Data profil dan dokumen Anda dilindungi sesuai standar privasi dan keamanan SiagaBanjir.',
                        ),
                        onVersionTap: () => tampilkanInfoSiaga(
                          context,
                          'SiagaBanjir v1.0.0+1',
                          'Aplikasi Tanggap Darurat Banjir Warga.',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TombolKeluar(onLogout: _confirmLogout),
                    ],
                  ),
                ),
              ),
              if (!LingkupNavigasi.aktif(context))
                NavigasiBeranda(
                  currentAction: AksiBeranda.profile,
                  onOpen: (action) {
                    if (action == AksiBeranda.profile) {
                      _backToTop();
                    } else {
                      widget.onOpen(action);
                    }
                  },
                  onHome: widget.onHome,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
