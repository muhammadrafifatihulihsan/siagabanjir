import 'package:flutter/material.dart';

enum EmergencyBagCategory {
  documents(
    'Dokumen Berharga',
    Icons.description_outlined,
    Color(0xFF2563EB),
  ),
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

  const EmergencyBagCategory(this.title, this.icon, this.iconColor);

  final String title;
  final IconData icon;
  final Color iconColor;
}

class EmergencyBagItem {
  const EmergencyBagItem({
    required this.id,
    required this.title,
    required this.category,
    required this.isChecked,
  });

  final String id;
  final String title;
  final EmergencyBagCategory category;
  final bool isChecked;

  EmergencyBagItem copyWith({bool? isChecked}) => EmergencyBagItem(
    id: id,
    title: title,
    category: category,
    isChecked: isChecked ?? this.isChecked,
  );
}

// 14 barang kesiapsiagaan default sesuai desain referensi emergency_bag_checklist.svg
const List<EmergencyBagItem> kDefaultEmergencyBagItems = [
  // 1. Dokumen Berharga (3/3)
  EmergencyBagItem(
    id: 'doc_1',
    title: 'Scan KK, KTP & Akta dalam plastik kedap air',
    category: EmergencyBagCategory.documents,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'doc_2',
    title: 'Ijazah & surat kepemilikan penting',
    category: EmergencyBagCategory.documents,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'doc_3',
    title: 'Uang tunai darurat pecahan kecil',
    category: EmergencyBagCategory.documents,
    isChecked: true,
  ),

  // 2. Obat & P3K Keluarga (3/3)
  EmergencyBagItem(
    id: 'med_1',
    title: 'Obat rutin lansia & anak (stok 7 hari)',
    category: EmergencyBagCategory.medical,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'med_2',
    title: 'Antiseptik, kasa steril & plester luka',
    category: EmergencyBagCategory.medical,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'med_3',
    title: 'Obat pereda demam, diare & minyak angin',
    category: EmergencyBagCategory.medical,
    isChecked: true,
  ),

  // 3. Logistik & Komunikasi (4/4)
  EmergencyBagItem(
    id: 'log_1',
    title: 'Air minum kemasan (3 botol 600 ml/orang)',
    category: EmergencyBagCategory.logistics,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'log_2',
    title: 'Makanan kering tahan lama (biskuit/kurma)',
    category: EmergencyBagCategory.logistics,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'log_3',
    title: 'Senter LED kedap air & peluit darurat',
    category: EmergencyBagCategory.logistics,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'log_4',
    title: 'Power bank kapasitas penuh & kabel cas',
    category: EmergencyBagCategory.logistics,
    isChecked: true,
  ),

  // 4. Pakaian & Perlengkapan (2/4 checked)
  EmergencyBagItem(
    id: 'clo_1',
    title: 'Pakaian ganti hangat & jas hujan',
    category: EmergencyBagCategory.clothing,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'clo_2',
    title: 'Sepatu boots atau alas kaki tertutup',
    category: EmergencyBagCategory.clothing,
    isChecked: true,
  ),
  EmergencyBagItem(
    id: 'clo_3',
    title: 'Kantong plastik besar pelindung tas',
    category: EmergencyBagCategory.clothing,
    isChecked: false,
  ),
  EmergencyBagItem(
    id: 'clo_4',
    title: 'Selimut termal darurat',
    category: EmergencyBagCategory.clothing,
    isChecked: false,
  ),
];
