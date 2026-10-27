import 'package:flutter/material.dart';

enum KategoriTasSiaga {
  documents('Dokumen Berharga', Icons.description_outlined, Color(0xFF2563EB)),
  medical(
    'Obat & P3K Keluarga',
    Icons.monitor_heart_outlined,
    Color(0xFFDC2626),
  ),
  logistics(
    'Logistik & Komunikasi',
    Icons.inventory_2_outlined,
    Color(0xFF2563EB),
  ),
  clothing(
    'Pakaian & Perlengkapan',
    Icons.checkroom_outlined,
    Color(0xFFD97706),
  );

  const KategoriTasSiaga(this.title, this.icon, this.iconColor);

  final String title;
  final IconData icon;
  final Color iconColor;
}

class BarangTasSiaga {
  const BarangTasSiaga({
    required this.id,
    required this.title,
    required this.category,
    required this.isChecked,
  });

  final String id;
  final String title;
  final KategoriTasSiaga category;
  final bool isChecked;

  BarangTasSiaga copyWith({bool? isChecked}) => BarangTasSiaga(
    id: id,
    title: title,
    category: category,
    isChecked: isChecked ?? this.isChecked,
  );
}

// 14 barang kesiapsiagaan default sesuai desain referensi emergency_bag_checklist.svg
const List<BarangTasSiaga> kDefaultEmergencyBagItems = [
  // 1. Dokumen Berharga (3/3)
  BarangTasSiaga(
    id: 'doc_1',
    title: 'Scan KK, KTP & Akta dalam plastik kedap air',
    category: KategoriTasSiaga.documents,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'doc_2',
    title: 'Ijazah & surat kepemilikan penting',
    category: KategoriTasSiaga.documents,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'doc_3',
    title: 'Uang tunai darurat pecahan kecil',
    category: KategoriTasSiaga.documents,
    isChecked: true,
  ),

  // 2. Obat & P3K Keluarga (3/3)
  BarangTasSiaga(
    id: 'med_1',
    title: 'Obat rutin lansia & anak (stok 7 hari)',
    category: KategoriTasSiaga.medical,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'med_2',
    title: 'Antiseptik, kasa steril & plester luka',
    category: KategoriTasSiaga.medical,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'med_3',
    title: 'Obat pereda demam, diare & minyak angin',
    category: KategoriTasSiaga.medical,
    isChecked: true,
  ),

  // 3. Logistik & Komunikasi (4/4)
  BarangTasSiaga(
    id: 'log_1',
    title: 'Air minum kemasan (3 botol 600 ml/orang)',
    category: KategoriTasSiaga.logistics,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'log_2',
    title: 'Makanan kering tahan lama (biskuit/kurma)',
    category: KategoriTasSiaga.logistics,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'log_3',
    title: 'Senter LED kedap air & peluit darurat',
    category: KategoriTasSiaga.logistics,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'log_4',
    title: 'Power bank kapasitas penuh & kabel cas',
    category: KategoriTasSiaga.logistics,
    isChecked: true,
  ),

  // 4. Pakaian & Perlengkapan (2/4 checked)
  BarangTasSiaga(
    id: 'clo_1',
    title: 'Pakaian ganti hangat & jas hujan',
    category: KategoriTasSiaga.clothing,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'clo_2',
    title: 'Sepatu boots atau alas kaki tertutup',
    category: KategoriTasSiaga.clothing,
    isChecked: true,
  ),
  BarangTasSiaga(
    id: 'clo_3',
    title: 'Kantong plastik besar pelindung tas',
    category: KategoriTasSiaga.clothing,
    isChecked: false,
  ),
  BarangTasSiaga(
    id: 'clo_4',
    title: 'Selimut termal darurat',
    category: KategoriTasSiaga.clothing,
    isChecked: false,
  ),
];
