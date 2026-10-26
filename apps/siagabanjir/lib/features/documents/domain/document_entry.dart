// Model dan data acuan untuk Dokumen Siaga / Brankas Dokumen Keluarga sesuai desain referensi documents_vault.svg.

enum DocumentFormat {
  pdf('PDF'),
  jpg('JPG'),
  png('PNG');

  const DocumentFormat(this.label);
  final String label;
}

enum DocumentStatus {
  saved('Tersimpan'),
  verified('Terverifikasi'),
  pending('Menunggu');

  const DocumentStatus(this.label);
  final String label;
}

class DocumentEntry {
  const DocumentEntry({
    required this.id,
    required this.categoryNumber,
    required this.categoryTitle,
    required this.fileName,
    required this.format,
    required this.fileSize,
    required this.status,
    required this.updateStatus,
    this.isVital = false,
  });

  final String id;
  final int categoryNumber;
  final String categoryTitle;
  final String fileName;
  final DocumentFormat format;
  final String fileSize;
  final DocumentStatus status;
  final String updateStatus;
  final bool isVital;

  DocumentEntry copyWith({
    String? id,
    int? categoryNumber,
    String? categoryTitle,
    String? fileName,
    DocumentFormat? format,
    String? fileSize,
    DocumentStatus? status,
    String? updateStatus,
    bool? isVital,
  }) => DocumentEntry(
    id: id ?? this.id,
    categoryNumber: categoryNumber ?? this.categoryNumber,
    categoryTitle: categoryTitle ?? this.categoryTitle,
    fileName: fileName ?? this.fileName,
    format: format ?? this.format,
    fileSize: fileSize ?? this.fileSize,
    status: status ?? this.status,
    updateStatus: updateStatus ?? this.updateStatus,
    isVital: isVital ?? this.isVital,
  );
}

// 3 dokumen siaga utama keluarga default persis sesuai desain referensi documents_vault.svg
const List<DocumentEntry> kDefaultDocumentEntries = [
  DocumentEntry(
    id: 'doc_kk',
    categoryNumber: 1,
    categoryTitle: 'Kartu Keluarga (KK)',
    fileName: 'Scan-KK-asli-Keluarga.pdf',
    format: DocumentFormat.pdf,
    fileSize: '1.4 MB',
    status: DocumentStatus.saved,
    updateStatus: 'Diperbarui',
    isVital: false,
  ),
  DocumentEntry(
    id: 'doc_ktp',
    categoryNumber: 2,
    categoryTitle: 'KTP Elektronik Kepala Keluarga',
    fileName: 'KTP-Anggota-1.pdf',
    format: DocumentFormat.pdf,
    fileSize: '850 KB',
    status: DocumentStatus.saved,
    updateStatus: 'Diperiksa',
    isVital: true,
  ),
  DocumentEntry(
    id: 'doc_akta',
    categoryNumber: 3,
    categoryTitle: 'Akta Kelahiran Anak',
    fileName: 'Akta-Kelahiran-Anak.pdf',
    format: DocumentFormat.pdf,
    fileSize: '2.1 MB',
    status: DocumentStatus.saved,
    updateStatus: 'Diperbarui',
    isVital: false,
  ),
];

// Panduan keamanan dokumen evakuasi darurat persis sesuai desain referensi documents_vault.svg
const List<String> kDocumentSecurityGuidelines = [
  'Simpan berkas dalam kantong plastik kedap air (ziplock) sebelum dievakuasi.',
  'Fotokopi & legalisir dokumen penting disimpan terpisah di tempat aman.',
  'Gunakan enkripsi digital agar data tidak mudah disalahgunakan pihak lain.',
  'Bawa dokumen fisik asli hanya saat instruksi evakuasi resmi dikeluarkan.',
  'Pastikan baterai ponsel terisi untuk akses dokumen digital saat darurat.',
  'Simpan kontak darurat posko.',
];
