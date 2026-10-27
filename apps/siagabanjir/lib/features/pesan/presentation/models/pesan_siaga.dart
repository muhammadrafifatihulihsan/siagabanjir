import 'package:flutter/material.dart';

// Kategori filter pesan sesuai acuan SVG messages_inbox.
enum KategoriPesan { all, emergency, weather }

// Model data representasi kartu pesan peringatan siaga.
class PesanSiaga {
  const PesanSiaga({
    required this.id,
    required this.category,
    required this.badgeLabel,
    required this.badgeBackground,
    required this.badgeTextColor,
    required this.timestamp,
    required this.agency,
    required this.title,
    required this.body,
    this.leftStripeColor,
    this.actions = const [],
    this.isNew = false,
  });

  final String id;
  final KategoriPesan category;
  final String badgeLabel;
  final Color badgeBackground;
  final Color badgeTextColor;
  final String timestamp;
  final String agency;
  final String title;
  final String body;
  final Color? leftStripeColor;
  final List<String> actions;
  final bool isNew;
}

// Data contoh dari acuan visual SVG messages_inbox.
const kSampleSiagaMessages = [
  PesanSiaga(
    id: 'msg-01',
    category: KategoriPesan.emergency,
    badgeLabel: 'Siaga 2 (Waspada)',
    badgeBackground: Color(0xFFFEF3C7),
    badgeTextColor: Color(0xFFD97706),
    leftStripeColor: Color(0xFFDC2626),
    timestamp: '08:30 WIB',
    agency: 'BPBD Provinsi Sumatera Barat',
    title: 'Waspada Luapan Sungai Lubuk Kilangan & Kuranji',
    body: 'Hujan hulu lebat. Warga bantaran sungai radius 100 m diimbau bersiap evakuasi.',
    actions: ['Bagikan'],
    isNew: true,
  ),
  PesanSiaga(
    id: 'msg-02',
    category: KategoriPesan.weather,
    badgeLabel: 'Potensi Banjir Kilat',
    badgeBackground: Color(0xFFD7EFFF),
    badgeTextColor: Color(0xFF0284C7),
    leftStripeColor: Color(0xFFD97706),
    timestamp: '07:00 WIB',
    agency: 'BMKG Stasiun Meteorologi Minangkabau',
    title: 'Peringatan Dini Cuaca Ekstrem Kota Padang',
    body: 'Potensi hujan lebat & angin kencang di Kuranji, Koto Tangah, Pauh.',
    isNew: true,
  ),
  PesanSiaga(
    id: 'msg-04',
    category: KategoriPesan.all,
    badgeLabel: 'Normal (Siaga 4)',
    badgeBackground: Color(0xFFF1F5F9),
    badgeTextColor: Color(0xFF475569),
    leftStripeColor: null,
    timestamp: 'Kemarin • 21:00 WIB',
    agency: 'Dinas SDA & Bina Marga Kota Padang',
    title: 'Normalisasi Pintu Air Sungai Batang Arau',
    body: 'Pintu air 3 dibuka, debit sungai terpantau mulai stabil.',
    isNew: false,
  ),
];
