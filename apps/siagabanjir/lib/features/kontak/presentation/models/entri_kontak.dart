import 'package:flutter/material.dart';

// Kategori kontak umum sesuai FRD §FR-READY-003.
enum KategoriKontak {
  emergency('Darurat'),
  health('Kesehatan'),
  infrastructure('Infrastruktur');

  const KategoriKontak(this.label);
  final String label;
}

// Satu entri kontak direktori umum — data sintetis, nomor contoh tidak diklaim resmi.
class EntriKontak {
  const EntriKontak({
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
  final KategoriKontak category;
  final String? description;
  final Color? accentColor;
}

// Data kontak publik sintetis — mockup; nomor belum diverifikasi resmi.
const List<EntriKontak> kPublicContacts = [
  // Darurat
  EntriKontak(
    name: 'BPBD Kota Padang',
    agency: 'Badan Penanggulangan Bencana Daerah',
    phone: '0751-7052699',
    category: KategoriKontak.emergency,
    description: 'Posko utama koordinasi bencana kota',
    accentColor: Color(0xFFDC2626),
  ),
  EntriKontak(
    name: 'Basarnas Padang',
    agency: 'Badan Nasional Pencarian dan Pertolongan',
    phone: '115',
    category: KategoriKontak.emergency,
    description: 'Pencarian dan pertolongan korban bencana',
    accentColor: Color(0xFFDC2626),
  ),
  EntriKontak(
    name: 'Damkar Kota Padang',
    agency: 'Dinas Pemadam Kebakaran',
    phone: '113',
    category: KategoriKontak.emergency,
    description: 'Kebakaran dan penyelamatan',
    accentColor: Color(0xFFDC2626),
  ),
  EntriKontak(
    name: 'Polresta Padang',
    agency: 'Kepolisian Resor Kota',
    phone: '110',
    category: KategoriKontak.emergency,
    description: 'Keamanan dan ketertiban',
    accentColor: Color(0xFFDC2626),
  ),
  // Kesehatan
  EntriKontak(
    name: 'RSUP M. Djamil Padang',
    agency: 'Rumah Sakit Umum Pusat',
    phone: '0751-32371',
    category: KategoriKontak.health,
    description: 'Rujukan utama gawat darurat',
    accentColor: Color(0xFF059669),
  ),
  EntriKontak(
    name: 'PMI Kota Padang',
    agency: 'Palang Merah Indonesia',
    phone: '0751-33082',
    category: KategoriKontak.health,
    description: 'Donor darah dan bantuan medis darurat',
    accentColor: Color(0xFF059669),
  ),
  EntriKontak(
    name: 'Ambulans Gawat Darurat',
    agency: 'Dinas Kesehatan Kota Padang',
    phone: '118',
    category: KategoriKontak.health,
    description: 'Layanan ambulans darurat 24 jam',
    accentColor: Color(0xFF059669),
  ),
  // Infrastruktur
  EntriKontak(
    name: 'PLN UP3 Padang',
    agency: 'PT PLN (Persero)',
    phone: '123',
    category: KategoriKontak.infrastructure,
    description: 'Gangguan dan pemadaman listrik',
    accentColor: Color(0xFF2563EB),
  ),
  EntriKontak(
    name: 'PDAM Kota Padang',
    agency: 'Perusahaan Daerah Air Minum',
    phone: '0751-28228',
    category: KategoriKontak.infrastructure,
    description: 'Gangguan distribusi air bersih',
    accentColor: Color(0xFF2563EB),
  ),
];
