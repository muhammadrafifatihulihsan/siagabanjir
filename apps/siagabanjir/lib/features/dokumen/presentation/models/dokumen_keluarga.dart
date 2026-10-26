import 'package:flutter/material.dart';

// Model data dokumen siaga keluarga sesuai spesifikasi desain documents_vault.svg.
class DokumenKeluarga {
  const DokumenKeluarga({
    required this.id,
    required this.numberTitle,
    required this.badge,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.status,
    required this.icon,
  });

  final String id;
  final String numberTitle;
  final String badge;
  final String fileName;
  final String fileType;
  final String fileSize;
  final String status;
  final IconData icon;

  String get subtitle => '$fileType • $fileSize • $status';

  DokumenKeluarga copyWith({
    String? fileName,
    String? fileType,
    String? fileSize,
    String? status,
  }) => DokumenKeluarga(
    id: id,
    numberTitle: numberTitle,
    badge: badge,
    fileName: fileName ?? this.fileName,
    fileType: fileType ?? this.fileType,
    fileSize: fileSize ?? this.fileSize,
    status: status ?? this.status,
    icon: icon,
  );
}

// 3 dokumen kependudukan vital default sesuai desain documents_vault.svg
const List<DokumenKeluarga> kDefaultFamilyDocuments = [
  DokumenKeluarga(
    id: 'doc_kk',
    numberTitle: '1. Kartu Keluarga (KK)',
    badge: 'Gambar / PDF',
    fileName: 'scan_kk_asli_keluarga.pdf',
    fileType: 'PDF',
    fileSize: '1.4 MB',
    status: 'Siap cetak dinas',
    icon: Icons.description_outlined,
  ),
  DokumenKeluarga(
    id: 'doc_ktp',
    numberTitle: '2. KTP Kepala Keluarga / Pasangan',
    badge: 'Gambar / PDF',
    fileName: 'ktp_rahmad_hidayat.jpg',
    fileType: 'Gambar JPG',
    fileSize: '840 KB',
    status: 'Siap cetak dinas',
    icon: Icons.badge_outlined,
  ),
  DokumenKeluarga(
    id: 'doc_akta',
    numberTitle: '3. Akta Kelahiran Anak / Berkas Vital',
    badge: 'Gambar / PDF',
    fileName: 'akta_kelahiran_anak.pdf',
    fileType: 'PDF',
    fileSize: '920 KB',
    status: 'Siap cetak dinas',
    icon: Icons.assignment_outlined,
  ),
];
