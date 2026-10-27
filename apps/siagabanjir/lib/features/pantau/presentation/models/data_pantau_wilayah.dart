import 'package:flutter/material.dart';

/// Status tingkat tinggi air sungai berdasarkan ambang batas peringatan dini.
enum StatusTinggiAir {
  normal(
    label: 'Normal',
    badgeBackground: Color(0xFFECFDF5),
    badgeForeground: Color(0xFF059669),
  ),
  siaga3(
    label: 'Siaga 3',
    badgeBackground: Color(0xFFFEF3C7),
    badgeForeground: Color(0xFFB45309),
  ),
  siaga2(
    label: 'Siaga 2',
    badgeBackground: Color(0xFFFEF3C7),
    badgeForeground: Color(0xFFB45309),
  ),
  bahaya(
    label: 'Bahaya',
    badgeBackground: Color(0xFFFEE2E2),
    badgeForeground: Color(0xFF991B1B),
  );

  const StatusTinggiAir({
    required this.label,
    required this.badgeBackground,
    required this.badgeForeground,
  });

  final String label;
  final Color badgeBackground;
  final Color badgeForeground;
}

/// Data pos pantau sungai individual.
class PosSungai {
  const PosSungai({
    required this.id,
    required this.name,
    required this.postLocation,
    required this.waterLevelCm,
    required this.status,
    this.customStatusLabel,
  });

  final String id;
  final String name;
  final String postLocation;
  final int waterLevelCm;
  final StatusTinggiAir status;
  final String? customStatusLabel;

  String get displayStatus => customStatusLabel ?? status.label;
}

/// Status operasional infrastruktur drainase / pompa dan pintu air.
class ItemInfrastruktur {
  const ItemInfrastruktur({
    required this.id,
    required this.title,
    required this.status,
    this.highlightColor = const Color(0xFF2563EB),
  });

  final String id;
  final String title;
  final String status;
  final Color highlightColor;
}

/// Data sungai utama yang disorot pada kartu atas.
class StatusSungaiSorotan {
  const StatusSungaiSorotan({
    required this.name,
    required this.waterLevelCm,
    required this.changeCm,
    required this.status,
    required this.spillLimitCm,
    required this.spillRemainingCm,
    this.statusLabel = 'Siaga 2',
  });

  final String name;
  final int waterLevelCm;
  final int changeCm;
  final StatusTinggiAir status;
  final int spillLimitCm;
  final int spillRemainingCm;
  final String statusLabel;

  String get formattedChange => '▲ +$changeCm cm';
}

/// Kumpulan data pemantauan wilayah publik default sesuai desain monitor_public.svg.
const kDefaultFeaturedRiver = StatusSungaiSorotan(
  name: 'Sungai Batang Kuranji',
  waterLevelCm: 140,
  changeCm: 20,
  status: StatusTinggiAir.siaga2,
  spillLimitCm: 150,
  spillRemainingCm: 10,
  statusLabel: 'Siaga 2',
);

const kDefaultRiverPosts = <PosSungai>[
  PosSungai(
    id: 'kuranji',
    name: 'Sungai Batang Kuranji',
    postLocation: 'Pos Kuranji • Sekitar Koto Tangah',
    waterLevelCm: 140,
    status: StatusTinggiAir.siaga2,
    customStatusLabel: 'Siaga 2',
  ),
  PosSungai(
    id: 'lubuk_kilangan',
    name: 'Sungai Lubuk Kilangan',
    postLocation: 'Pos Gadut • Tren naik lambat',
    waterLevelCm: 110,
    status: StatusTinggiAir.siaga3,
    customStatusLabel: 'Siaga 3',
  ),
  PosSungai(
    id: 'batang_arau',
    name: 'Sungai Batang Arau',
    postLocation: 'Pos Muaro • Aliran normal terkendali',
    waterLevelCm: 95,
    status: StatusTinggiAir.normal,
    customStatusLabel: 'Normal',
  ),
];

const kDefaultInfrastructureItems = <ItemInfrastruktur>[
  ItemInfrastruktur(
    id: 'pintu_3',
    title: 'Pintu Air Pintu 3',
    status: 'Buka 60%',
  ),
  ItemInfrastruktur(
    id: 'pompa_kuranji',
    title: 'Pompa Mobile Kuranji',
    status: '2 Unit Siap',
  ),
];
