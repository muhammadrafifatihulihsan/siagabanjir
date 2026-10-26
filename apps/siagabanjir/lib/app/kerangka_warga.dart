import 'package:flutter/material.dart';

import '../core/perangkat/layanan_foto.dart';
import '../shared/widgets/dialog_siaga.dart';

import '../features/akun/presentation/layar_profil.dart';
import '../features/autentikasi/presentation/layar_masuk.dart';
import '../features/beranda/presentation/aksi_beranda.dart';
import '../features/beranda/presentation/layar_beranda.dart';
import '../features/beranda/presentation/panel_akses_fitur.dart';
import '../features/laporan/presentation/layar_buat_laporan.dart';
import '../features/laporan/presentation/layar_riwayat_laporan.dart';
import '../shared/widgets/citizen_header.dart';
import '../shared/widgets/citizen_navigation.dart';
import '../shared/widgets/lingkup_navigasi.dart';
import 'halaman_fitur.dart';
import 'pengamat_halaman.dart';

/// Empat tab dibuat saat pertama dibuka, lalu mempertahankan state dan scroll.
class KerangkaWarga extends StatefulWidget {
  const KerangkaWarga({super.key});

  @override
  State<KerangkaWarga> createState() => _KerangkaWargaState();
}

class _KerangkaWargaState extends State<KerangkaWarga> {
  final _navigator = GlobalKey<NavigatorState>();
  final _pengamat = PengamatHalaman();
  final _tab = ValueNotifier(CitizenDestination.home);
  late final _perubahan = Listenable.merge([_tab, _pengamat.detailTerbuka]);
  late final _header = CitizenHeader(
    onNotifications: () => _buka(AksiBeranda.notifications),
  );
  final _scroll = List.generate(4, (_) => ScrollController());
  final _halaman = <CitizenDestination, Widget>{};
  bool _membukaDetail = false;
  final _fotoDipulihkan = ValueNotifier<FotoPilihan?>(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _pulihkanKamera());
  }

  Future<void> _pulihkanKamera() async {
    FotoPilihan? foto;
    try {
      foto = await LayananFoto().pulihkan();
    } catch (_) {
      return;
    }
    if (!mounted || foto == null) return;
    final gunakan = await showDialog<bool>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Foto kamera ditemukan kembali'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sesi kamera sebelumnya terhenti. Gunakan foto ini sebagai bukti laporan? Ini mengganti foto laporan saat ini, tanpa mengubah isian lainnya.',
            ),
            const SizedBox(height: 12),
            Image.memory(
              foto!.bytes,
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Text('Pratinjau foto tidak tersedia.'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abaikan'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Gunakan untuk Laporan'),
          ),
        ],
      ),
    );
    if (mounted && gunakan == true) {
      _fotoDipulihkan.value = foto;
      _pilih(CitizenDestination.report);
    }
  }

  Widget _halamanTab(CitizenDestination tab) => _halaman.putIfAbsent(tab, () {
    return switch (tab) {
      CitizenDestination.home => LayarBeranda(
        onOpen: _buka,
        scrollController: _scroll[0],
      ),
      CitizenDestination.report => LayarBuatLaporan(
        fotoDipulihkan: _fotoDipulihkan,
        scrollController: _scroll[1],
        onNotifications: () => _buka(AksiBeranda.notifications),
        onHistory: () => _pilih(CitizenDestination.history),
        onProfile: () => _pilih(CitizenDestination.profile),
      ),
      CitizenDestination.history => LayarRiwayatLaporan(
        scrollController: _scroll[2],
        onNotifications: () => _buka(AksiBeranda.notifications),
        onReport: () => _pilih(CitizenDestination.report),
        onProfile: () => _pilih(CitizenDestination.profile),
        onHome: () => _pilih(CitizenDestination.home),
      ),
      CitizenDestination.profile => LayarProfil(
        onLogout: _keluar,
        scrollController: _scroll[3],
        onOpen: _buka,
        onHome: () => _pilih(CitizenDestination.home),
      ),
    };
  });

  void _pilih(CitizenDestination tujuan) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    FocusManager.instance.primaryFocus?.unfocus();
    final detail = _navigator.currentState?.canPop() ?? false;
    _navigator.currentState?.popUntil((route) => route.isFirst);
    if (_tab.value == tujuan && !detail) {
      final controller = _scroll[tujuan.index];
      if (!controller.hasClients) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        controller.jumpTo(0);
      } else {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      }
    } else {
      _tab.value = tujuan;
    }
  }

  void _keluar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (ctx) => LayarMasuk(
          onLoginSuccess: (_) => Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const KerangkaWarga()),
            (_) => false,
          ),
        ),
      ),
      (_) => false,
    );
  }

  Future<void> _buka(AksiBeranda aksi) async {
    final tab = switch (aksi) {
      AksiBeranda.report => CitizenDestination.report,
      AksiBeranda.history => CitizenDestination.history,
      AksiBeranda.profile => CitizenDestination.profile,
      _ => null,
    };
    if (tab != null) {
      _pilih(tab);
      return;
    }
    if (aksi == AksiBeranda.all) {
      final tujuan = await showModalBottomSheet<AksiBeranda>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (_) => PanelAksesFitur(action: aksi),
      );
      if (mounted && tujuan != null) await _buka(tujuan);
      return;
    }
    if (_membukaDetail) return;
    _membukaDetail = true;
    await _navigator.currentState!.push<void>(
      MaterialPageRoute(
        settings: RouteSettings(name: aksi.name),
        builder: (_) => halamanFitur(aksi, _buka),
      ),
    );
    _membukaDetail = false;
  }

  @override
  void dispose() {
    _tab.dispose();
    _fotoDipulihkan.dispose();
    _pengamat.dispose();
    for (final controller in _scroll) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _perubahan,
    builder: (context, _) => PopScope(
      canPop:
          _tab.value == CitizenDestination.home &&
          !_pengamat.detailTerbuka.value,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _navigator.currentState!.maybePop()) return;
        if (mounted) _pilih(CitizenDestination.home);
      },
      child: Scaffold(
        bottomNavigationBar: MediaQuery.viewInsetsOf(context).bottom > 0
            ? null
            : SafeArea(
                top: false,
                child: Center(
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: CitizenNavigation(
                      selected: _tab.value,
                      onSelect: _pilih,
                    ),
                  ),
                ),
              ),
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _pengamat.detailTerbuka,
                    child: _header,
                    builder: (context, detail, header) =>
                        detail ||
                            MediaQuery.viewInsetsOf(this.context).bottom > 0
                        ? const SizedBox.shrink()
                        : header!,
                  ),
                  Expanded(
                    child: LingkupNavigasi(
                      child: Navigator(
                        key: _navigator,
                        observers: [_pengamat],
                        onGenerateRoute: (_) => MaterialPageRoute<void>(
                          settings: const RouteSettings(name: '/'),
                          builder: (_) => ValueListenableBuilder(
                            valueListenable: _tab,
                            builder: (_, active, _) {
                              _halamanTab(active);
                              return IndexedStack(
                                index: active.index,
                                children: [
                                  for (final item in CitizenDestination.values)
                                    TickerMode(
                                      enabled: active == item,
                                      child:
                                          _halaman[item] ??
                                          const SizedBox.shrink(),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
