import 'package:flutter/material.dart';

import '../features/akun/presentation/layar_profil.dart';
import '../features/kontak/presentation/layar_direktori_kontak.dart';
import '../features/dokumen/presentation/layar_dokumen_siaga.dart';
import '../features/tas_siaga/presentation/layar_tas_siaga.dart';
import '../features/panduan/presentation/layar_detail_panduan.dart';
import '../features/beranda/presentation/aksi_beranda.dart';
import '../features/beranda/presentation/panel_pratinjau_beranda.dart';
import '../features/beranda/presentation/layar_beranda.dart';
import '../features/pesan/presentation/layar_kotak_masuk.dart';
import '../features/pantau/presentation/layar_pantau_wilayah.dart';
import '../features/laporan/presentation/layar_buat_laporan.dart';
import '../features/laporan/presentation/layar_riwayat_laporan.dart';
import '../shared/theme/siaga_theme.dart';

class SiagaBanjirApp extends StatelessWidget {
  const SiagaBanjirApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SiagaBanjir',
    debugShowCheckedModeBanner: false,
    theme: SiagaTheme.light,
    home: Builder(
      builder: (context) =>
          LayarBeranda(onOpen: (action) => _openPreview(context, action)),
    ),
  );

  Future<void> _openPreview(BuildContext context, AksiBeranda action) async {
    if (action == AksiBeranda.report) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (routeContext) => LayarBuatLaporan(
            onNotifications: () =>
                _openPreview(routeContext, AksiBeranda.notifications),
            onHistory: () => _openPreview(routeContext, AksiBeranda.history),
            onProfile: () => _openPreview(routeContext, AksiBeranda.profile),
          ),
        ),
      );
      return;
    }
    if (action == AksiBeranda.bag) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (routeContext) => LayarTasSiaga(
            onReport: () => _openPreview(routeContext, AksiBeranda.report),
            onHistory: () => _openPreview(routeContext, AksiBeranda.history),
            onProfile: () => _openPreview(routeContext, AksiBeranda.profile),
          ),
        ),
      );
      return;
    }
    if (action == AksiBeranda.notifications) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (routeContext) => LayarKotakMasuk(
            onReport: () => _openPreview(routeContext, AksiBeranda.report),
            onHistory: () => _openPreview(routeContext, AksiBeranda.history),
            onProfile: () => _openPreview(routeContext, AksiBeranda.profile),
          ),
        ),
      );
      return;
    }
    if (action == AksiBeranda.guides) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (routeContext) => LayarDetailPanduan(
            onReport: () => _openPreview(routeContext, AksiBeranda.report),
            onHistory: () => _openPreview(routeContext, AksiBeranda.history),
            onProfile: () => _openPreview(routeContext, AksiBeranda.profile),
          ),
        ),
      );
      return;
    }
    if (action == AksiBeranda.contacts) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (routeContext) => LayarDirektoriKontak(
            onReport: () => _openPreview(routeContext, AksiBeranda.report),
            onHistory: () => _openPreview(routeContext, AksiBeranda.history),
            onProfile: () => _openPreview(routeContext, AksiBeranda.profile),
          ),
        ),
      );
      return;
    }
    if (action == AksiBeranda.documents) {
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (routeContext) => LayarDokumenSiaga(
            onHome: () => Navigator.pop(routeContext),
            onReport: () => _openPreview(routeContext, AksiBeranda.report),
            onHistory: () => _openPreview(routeContext, AksiBeranda.history),
            onProfile: () => _openPreview(routeContext, AksiBeranda.profile),
          ),
        ),
      );
      return;
    }
    final next = await showModalBottomSheet<AksiBeranda>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => PanelPratinjauBeranda(action: action),
    );
    if (!context.mounted) return;

    if (next == AksiBeranda.profile) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (ctx) => LayarProfil(
            onOpen: (act) => _openPreview(ctx, act),
            onHome: () => Navigator.of(ctx).pop(),
          ),
        ),
      );
    } else if (next == AksiBeranda.documents) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (routeContext) => LayarDokumenSiaga(
            onHome: () => Navigator.pop(routeContext),
            onReport: () => _openPreview(routeContext, AksiBeranda.report),
            onHistory: () => _openPreview(routeContext, AksiBeranda.history),
            onProfile: () => _openPreview(routeContext, AksiBeranda.profile),
          ),
        ),
      );
    } else if (next == AksiBeranda.monitor) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (routeContext) => LayarPantauWilayah(
            onHome: () => Navigator.pop(routeContext),
            onReport: () => _openPreview(routeContext, AksiBeranda.report),
            onHistory: () => _openPreview(routeContext, AksiBeranda.history),
            onProfile: () => _openPreview(routeContext, AksiBeranda.profile),
          ),
        ),
      );
    } else if (next == AksiBeranda.history) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (ctx) => LayarRiwayatLaporan(
            onNotifications: () => _openPreview(ctx, AksiBeranda.notifications),
            onReport: () => _openPreview(ctx, AksiBeranda.report),
            onProfile: () => _openPreview(ctx, AksiBeranda.profile),
          ),
        ),
      );
    } else if (next != null) {
      await _openPreview(context, next);
    }
  }
}
