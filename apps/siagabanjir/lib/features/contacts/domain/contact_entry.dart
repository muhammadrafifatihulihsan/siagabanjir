import 'package:flutter/material.dart';

// Kategori kontak umum sesuai FRD §FR-READY-003.
enum ContactCategory {
  emergency('Darurat'),
  health('Kesehatan'),
  infrastructure('Infrastruktur'),
  posko('Posko');

  const ContactCategory(this.label);
  final String label;
}

// Satu entri kontak direktori umum — data sintetis, nomor contoh tidak diklaim resmi.
class ContactEntry {
  const ContactEntry({
    required this.name,
    required this.agency,
    required this.phone,
    required this.category,
    this.description,
    this.accentColor,
  });

  final String name;
  final String agency;
  final String phone;
  final ContactCategory category;
  final String? description;
  final Color? accentColor;
}

// Data kontak publik sintetis — mockup; nomor belum diverifikasi resmi.
const List<ContactEntry> kPublicContacts = [
  // Darurat
  ContactEntry(
    name: 'BPBD Kota Padang',
    agency: 'Badan Penanggulangan Bencana Daerah',
    phone: '0751-7052699',
    category: ContactCategory.emergency,
    description: 'Posko utama koordinasi bencana kota',
    accentColor: Color(0xFFDC2626),
  ),
  ContactEntry(
    name: 'Basarnas Padang',
    agency: 'Badan Nasional Pencarian dan Pertolongan',
    phone: '115',
    category: ContactCategory.emergency,
    description: 'Pencarian dan pertolongan korban bencana',
    accentColor: Color(0xFFDC2626),
  ),
  ContactEntry(
    name: 'Damkar Kota Padang',
    agency: 'Dinas Pemadam Kebakaran',
    phone: '113',
    category: ContactCategory.emergency,
    description: 'Kebakaran dan penyelamatan',
    accentColor: Color(0xFFDC2626),
  ),
  ContactEntry(
    name: 'Polresta Padang',
    agency: 'Kepolisian Resor Kota',
    phone: '110',
    category: ContactCategory.emergency,
    description: 'Keamanan dan ketertiban',
    accentColor: Color(0xFFDC2626),
  ),
  // Kesehatan
  ContactEntry(
    name: 'RSUP M. Djamil Padang',
    agency: 'Rumah Sakit Umum Pusat',
    phone: '0751-32371',
    category: ContactCategory.health,
    description: 'Rujukan utama gawat darurat',
    accentColor: Color(0xFF059669),
  ),
  ContactEntry(
    name: 'PMI Kota Padang',
    agency: 'Palang Merah Indonesia',
    phone: '0751-33082',
    category: ContactCategory.health,
    description: 'Donor darah dan bantuan medis darurat',
    accentColor: Color(0xFF059669),
  ),
  ContactEntry(
    name: 'Ambulans Gawat Darurat',
    agency: 'Dinas Kesehatan Kota Padang',
    phone: '118',
    category: ContactCategory.health,
    description: 'Layanan ambulans darurat 24 jam',
    accentColor: Color(0xFF059669),
  ),
  // Infrastruktur
  ContactEntry(
    name: 'PLN UP3 Padang',
    agency: 'PT PLN (Persero)',
    phone: '123',
    category: ContactCategory.infrastructure,
    description: 'Gangguan dan pemadaman listrik',
    accentColor: Color(0xFF2563EB),
  ),
  ContactEntry(
    name: 'PDAM Kota Padang',
    agency: 'Perusahaan Daerah Air Minum',
    phone: '0751-28228',
    category: ContactCategory.infrastructure,
    description: 'Gangguan distribusi air bersih',
    accentColor: Color(0xFF2563EB),
  ),
  // Posko
  ContactEntry(
    name: 'Posko Bencana Kecamatan Kuranji',
    agency: 'Kecamatan Kuranji',
    phone: '0751-445566',
    category: ContactCategory.posko,
    description: 'Posko evakuasi wilayah Kuranji',
    accentColor: Color(0xFF7C3AED),
  ),
  ContactEntry(
    name: 'Posko Bencana Kecamatan Padang Timur',
    agency: 'Kecamatan Padang Timur',
    phone: '0751-556677',
    category: ContactCategory.posko,
    description: 'Posko evakuasi wilayah Padang Timur',
    accentColor: Color(0xFF7C3AED),
  ),
];