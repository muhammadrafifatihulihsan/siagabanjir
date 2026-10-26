import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/perangkat/layanan_foto.dart';
import '../../../shared/widgets/dialog_siaga.dart';
import 'widgets/formulir_profil.dart';
import 'widgets/formulir_kontak.dart';
import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_header.dart';
import '../../beranda/presentation/aksi_beranda.dart';
import '../../beranda/presentation/widgets/navigasi_beranda.dart';
import '../domain/profil_pengguna.dart';
import 'widgets/bagian_pengaturan_akun.dart';
import 'widgets/bagian_kontak_darurat.dart';
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
  bool _memuatFoto = false;

  Future<void> _editProfil() async {
    final hasil = await showDialog<ProfilPengguna>(
      context: context,
      builder: (_) => FormulirProfil(profil: _profil),
    );
    if (hasil != null && mounted) {
      setState(() => _profil = hasil);
      _showFeedback('Profil diperbarui untuk sesi demo ini.');
    }
  }

  Future<void> _ambilFoto() async {
    if (_memuatFoto) return;
    setState(() => _memuatFoto = true);
    try {
      final foto = await (widget.layananFoto ?? LayananFoto()).ambil();
      if (mounted && foto != null) setState(() => _foto = foto);
    } catch (_) {
      if (mounted) {
        await tampilkanInfoSiaga(
          context,
          'Kamera belum dapat dibuka',
          'Periksa izin kamera dan coba lagi. Foto sebelumnya tetap dipertahankan.',
        );
      }
    } finally {
      if (mounted) setState(() => _memuatFoto = false);
    }
  }

  Future<void> _tambahKontak() async {
    final hasil = await showDialog<KontakDarurat>(
      context: context,
      builder: (_) => const FormulirKontak(),
    );
    if (hasil != null && mounted) {
      setState(
        () =>
            _profil = _profil.copyWith(contacts: [..._profil.contacts, hasil]),
      );
    }
  }

  Future<void> _aksiKontak(KontakDarurat kontak) async {
    final aksi = await showDialog<String>(
      context: context,
      builder: (context) => DialogSiaga(
        title: Text(kontak.name),
        content: Text('${kontak.relation}\n${kontak.phone}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'hapus'),
            child: const Text('Hapus'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'edit'),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'salin'),
            child: const Text('Salin Nomor'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (aksi == 'salin') {
      await Clipboard.setData(ClipboardData(text: kontak.phone));
      if (mounted) _showFeedback('Nomor kontak disalin.');
    } else if (aksi == 'hapus') {
      setState(
        () => _profil = _profil.copyWith(
          contacts: _profil.contacts.where((c) => c != kontak).toList(),
        ),
      );
    } else if (aksi == 'edit') {
      final hasil = await showDialog<KontakDarurat>(
        context: context,
        builder: (_) => FormulirKontak(kontak: kontak),
      );
      if (hasil != null && mounted) {
        setState(
          () => _profil = _profil.copyWith(
            contacts: _profil.contacts
                .map((c) => c == kontak ? hasil : c)
                .toList(),
          ),
        );
      }
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
          'Perubahan profil, foto, dan isian laporan pada sesi demo ini akan dihapus. Anda dapat memulai sesi demo baru setelah masuk.',
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
                        onChangeAvatar: _ambilFoto,
                        foto: _foto?.bytes,
                        memuatFoto: _memuatFoto,
                      ),
                      const SizedBox(height: 20),
                      BagianInfoProfil(profile: _profil),
                      const SizedBox(height: 20),
                      BagianKontakDarurat(
                        contacts: _profil.contacts,
                        onAddContact: _tambahKontak,
                        onCallContact: _aksiKontak,
                      ),
                      const SizedBox(height: 20),
                      BagianPengaturanAkun(
                        floodAlertEnabled: _floodAlertEnabled,
                        appVersion: widget.initialProfile.appVersion,
                        onToggleFloodAlert: (val) {
                          setState(() => _floodAlertEnabled = val);
                          _showFeedback(
                            val
                                ? 'Preferensi peringatan diaktifkan untuk sesi demo.'
                                : 'Preferensi peringatan dinonaktifkan untuk sesi demo.',
                          );
                        },
                        onSecurity: () => tampilkanInfoSiaga(
                          context,
                          'Keamanan & Kata Sandi',
                          'Sesi ini memakai akun contoh. Penggantian sandi membutuhkan layanan akun yang belum terhubung; jangan masukkan sandi asli.',
                        ),
                        onHelpFaq: () => tampilkanInfoSiaga(
                          context,
                          'Pusat Bantuan & FAQ',
                          'Gunakan Pantau untuk melihat contoh status wilayah, Tas Siaga untuk checklist, dan Panduan Selamat untuk membaca atau mendengarkan petunjuk. Laporan belum dikirim ke petugas.',
                        ),
                        onPrivacy: () => tampilkanInfoSiaga(
                          context,
                          'Privasi Data',
                          'Edit profil dan foto berada dalam sesi demo ini. Foto kamera dapat berada di cache perangkat. Tidak ada unggahan ke server. Gunakan data uji, bukan dokumen pribadi.',
                        ),
                        onVersionTap: () => showAboutDialog(
                          context: context,
                          applicationName: 'SiagaBanjir',
                          applicationVersion: '1.0.0+1',
                          children: [
                            const Text(
                              'Pratinjau warga untuk pengujian lokal.',
                            ),
                          ],
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
