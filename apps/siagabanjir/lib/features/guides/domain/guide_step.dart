// Model dan data acuan untuk tahapan panduan evakuasi darurat banjir.
class GuideStep {
  const GuideStep({
    required this.number,
    required this.title,
    required this.summary,
    required this.instructions,
  });

  final int number;
  final String title;
  final String summary;
  final List<String> instructions;
}

// 5 tahapan utama evakuasi mandiri sesuai desain referensi guides_detail.svg.
const kDefaultGuideSteps = <GuideStep>[
  GuideStep(
    number: 1,
    title: 'Pantau Ketinggian Air & Peringatan Dini',
    summary: 'Perhatikan sumber informasi resmi dan tanda bahaya lingkungan.',
    instructions: [
      'Pantau terus pembaruan informasi dari aplikasi SiagaBanjir, BPBD, atau BMKG.',
      'Perhatikan kenaikan debit air di saluran primer dan sungai terdekat.',
      'Segera bersiap ketika sirine peringatan dini atau kentongan warga berbunyi.',
    ],
  ),
  GuideStep(
    number: 2,
    title: 'Matikan Instalasi Listrik & Saluran Gas',
    summary: 'Cegah sengatan listrik dan risiko kebakaran sebelum air meninggi.',
    instructions: [
      'Segera turunkan saklar meteran utama (MCB) sebelum genangan masuk rumah.',
      'Cabut seluruh steker elektronik dan pindahkan peralatan ke area yang lebih tinggi.',
      'Lepaskan regulator tabung gas dan letakkan tabung pada posisi tegak dan aman.',
    ],
  ),
  GuideStep(
    number: 3,
    title: 'Amankan Dokumen Penting & Tas Siaga',
    summary: 'Lindungi identitas keluarga dan bawa perbekalan darurat.',
    instructions: [
      'Simpan dokumen penting (KK, KTP, ijazah, surat tanah) dalam kantong plastik kedap air.',
      'Ambil Tas Siaga Bencana yang telah disiapkan di dekat pintu keluar.',
      'Pastikan ponsel dan cadangan daya (powerbank) terisi penuh untuk komunikasi.',
    ],
  ),
  GuideStep(
    number: 4,
    title: 'Evakuasi Menuju Titik Kumpul / Jalur Aman',
    summary: 'Gunakan jalur evakuasi resmi dengan mengutamakan keselamatan.',
    instructions: [
      'Gunakan jalur evakuasi yang sudah ditentukan kelurahan, hindari jalan pintas tergenang.',
      'Bantu lansia, ibu hamil, anak-anak, dan penyandang disabilitas terlebih dahulu.',
      'Gunakan tongkat atau payung untuk meraba kedalaman permukaan jalan yang terendam.',
    ],
  ),
  GuideStep(
    number: 5,
    title: 'Lapor ke Posko & Ikuti Arahan Petugas',
    summary: 'Registrasi keluarga dan jangan kembali sebelum situasi aman.',
    instructions: [
      'Laporkan jumlah anggota keluarga ke meja registrasi posko penampungan resmi.',
      'Beritahukan kepada petugas SAR bila ada kerabat atau tetangga yang tertinggal.',
      'Jangan kembali ke rumah sebelum ada pengumuman resmi bahwa banjir telah surut.',
    ],
  ),
];

// Hal-hal yang harus dilakukan saat evakuasi banjir (Kartu Hijau / Lakukan).
const kGuideDoItems = <String>[
  'Utamakan keselamatan jiwa daripada harta benda',
  'Gunakan alas kaki tertutup dan pakaian praktis',
  'Bawa air minum bersih, obat, dan identitas',
  'Laporkan keberadaan keluarga ke posko terdekat',
];

// Hal-hal yang harus dihindari saat evakuasi banjir (Kartu Merah / Hindari).
const kGuideDontItems = <String>[
  'Menerobos arus banjir yang deras atau keruh',
  'Mendekati tiang listrik, gardu, atau kabel putus',
  'Membiarkan anak-anak bermain di air genangan',
  'Mengabaikan instruksi evakuasi petugas berwenang',
];
