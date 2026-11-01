import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../features/pantau/presentation/models/data_pantau_wilayah.dart';

/// Status verifikasi operasional untuk klaster wilayah oleh admin Pusdalops.
enum StatusVerifikasiWilayah {
  menungguTinjauan(
    label: 'Menunggu Tinjauan',
    badgeBackground: Color(0xFFFEF3C7),
    badgeForeground: Color(0xFFB45309),
  ),
  terverifikasi(
    label: 'Ditinjau & Diproses',
    badgeBackground: Color(0xFFEFF6FF),
    badgeForeground: Color(0xFF1D4ED8),
  ),
  selesai(
    label: 'Selesai / Surut',
    badgeBackground: Color(0xFFECFDF5),
    badgeForeground: Color(0xFF059669),
  );

  const StatusVerifikasiWilayah({
    required this.label,
    required this.badgeBackground,
    required this.badgeForeground,
  });

  final String label;
  final Color badgeBackground;
  final Color badgeForeground;
}

/// Model representasi satu laporan individual di dashboard admin.
class LaporanAdminItem {
  const LaporanAdminItem({
    required this.id,
    required this.namaPelapor,
    required this.waktu,
    required this.namaWilayah,
    required this.kategori,
    required this.deskripsi,
    required this.kebutuhan,
    this.idKlaster = '',
    this.foto,
    this.statusVerifikasi = StatusVerifikasiWilayah.menungguTinjauan,
    this.diverifikasiOtomatisWilayah = false,
    this.catatanPetugas = const [],
    this.estimasiAiTinggi = '40 - 60 cm',
  });

  final String id;
  final String namaPelapor;
  final DateTime waktu;
  final String namaWilayah;
  final String kategori;
  final String deskripsi;
  final List<String> kebutuhan;
  final String idKlaster;
  final Uint8List? foto;
  final StatusVerifikasiWilayah statusVerifikasi;
  final bool diverifikasiOtomatisWilayah;
  final List<String> catatanPetugas;
  final String estimasiAiTinggi;

  String get timestamp =>
      '${waktu.day.toString().padLeft(2, '0')}/${waktu.month.toString().padLeft(2, '0')}/${waktu.year} • ${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')} WIB';

  LaporanAdminItem copyWith({
    StatusVerifikasiWilayah? statusVerifikasi,
    bool? diverifikasiOtomatisWilayah,
    List<String>? catatanPetugas,
  }) => LaporanAdminItem(
    id: id,
    namaPelapor: namaPelapor,
    waktu: waktu,
    namaWilayah: namaWilayah,
    kategori: kategori,
    deskripsi: deskripsi,
    kebutuhan: kebutuhan,
    idKlaster: idKlaster,
    foto: foto,
    statusVerifikasi: statusVerifikasi ?? this.statusVerifikasi,
    diverifikasiOtomatisWilayah:
        diverifikasiOtomatisWilayah ?? this.diverifikasiOtomatisWilayah,
    catatanPetugas: catatanPetugas ?? this.catatanPetugas,
    estimasiAiTinggi: estimasiAiTinggi,
  );
}

/// Model representasi kelompok/klaster wilayah laporan hasil agregasi AI
/// berdasarkan aturan batas bentang geografis dan rentang waktu.
class KlasterWilayahAi {
  const KlasterWilayahAi({
    required this.id,
    required this.namaWilayah,
    required this.kecamatan,
    required this.radiusKeterangan,
    required this.tingkatTinggiAir,
    required this.estimasiKedalaman,
    required this.statusVerifikasi,
    required this.indikatorAi,
    required this.kebutuhanDominan,
    required this.laporan,
    this.catatanTindakLanjut = const [],
  });

  final String id;
  final String namaWilayah;
  final String kecamatan;
  final String radiusKeterangan;
  final StatusTinggiAir tingkatTinggiAir;
  final String estimasiKedalaman;
  final StatusVerifikasiWilayah statusVerifikasi;
  final List<String> indikatorAi;
  final List<String> kebutuhanDominan;
  final List<LaporanAdminItem> laporan;
  final List<String> catatanTindakLanjut;

  int get totalLaporan => laporan.length;

  KlasterWilayahAi copyWith({
    StatusVerifikasiWilayah? statusVerifikasi,
    List<String>? catatanTindakLanjut,
    List<LaporanAdminItem>? laporan,
    StatusTinggiAir? tingkatTinggiAir,
  }) => KlasterWilayahAi(
    id: id,
    namaWilayah: namaWilayah,
    kecamatan: kecamatan,
    radiusKeterangan: radiusKeterangan,
    tingkatTinggiAir: tingkatTinggiAir ?? this.tingkatTinggiAir,
    estimasiKedalaman: estimasiKedalaman,
    statusVerifikasi: statusVerifikasi ?? this.statusVerifikasi,
    indikatorAi: indikatorAi,
    kebutuhanDominan: kebutuhanDominan,
    laporan: laporan ?? this.laporan,
    catatanTindakLanjut: catatanTindakLanjut ?? this.catatanTindakLanjut,
  );
}
