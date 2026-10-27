import '../features/kontak/domain/kontak_darurat.dart';

import 'package:flutter/material.dart';

import '../features/keluarga/presentation/layar_keluarga.dart';

import '../features/beranda/presentation/aksi_beranda.dart';
import '../features/dokumen/presentation/layar_dokumen_siaga.dart';
import '../features/kontak/presentation/layar_direktori_kontak.dart';
import '../features/panduan/presentation/layar_detail_panduan.dart';
import '../features/pantau/presentation/layar_pantau_wilayah.dart';
import '../features/pesan/presentation/layar_kotak_masuk.dart';
import '../features/tas_siaga/presentation/layar_tas_siaga.dart';

Widget halamanFitur(
  AksiBeranda aksi,
  ValueChanged<AksiBeranda> buka, {
  ValueNotifier<List<KontakDarurat>>? kontakPribadi,
  ValueNotifier<List<DokumenSesi>>? dokumen,
}) {
  void laporan() => buka(AksiBeranda.report);
  void riwayat() => buka(AksiBeranda.history);
  void profil() => buka(AksiBeranda.profile);
  return switch (aksi) {
    AksiBeranda.family => const LayarKeluarga(),
    AksiBeranda.documents => LayarDokumenSiaga(
      dokumen: dokumen,
      onReport: laporan,
      onHistory: riwayat,
      onProfile: profil,
    ),
    AksiBeranda.contacts => LayarDirektoriKontak(
      kontakPribadi: kontakPribadi,
      onReport: laporan,
      onHistory: riwayat,
      onProfile: profil,
    ),
    AksiBeranda.guides => LayarDetailPanduan(
      onReport: laporan,
      onHistory: riwayat,
      onProfile: profil,
    ),
    AksiBeranda.monitor => LayarPantauWilayah(
      onReport: laporan,
      onHistory: riwayat,
      onProfile: profil,
    ),
    AksiBeranda.notifications => LayarKotakMasuk(
      onReport: laporan,
      onHistory: riwayat,
      onProfile: profil,
    ),
    AksiBeranda.bag => LayarTasSiaga(
      onReport: laporan,
      onHistory: riwayat,
      onProfile: profil,
    ),
    _ => throw ArgumentError.value(aksi, 'aksi', 'Bukan halaman detail'),
  };
}
