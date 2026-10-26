// Model dan data acuan untuk tahapan panduan evakuasi darurat banjir persis sesuai desain SVG.
class LangkahPanduan {
  const LangkahPanduan({
    required this.number,
    required this.title,
    required this.description,
  });

  final int number;
  final String title;
  final String description;
}

// 5 tahapan utama langkah menghadapi banjir persis sesuai desain referensi guides_detail.svg.
const kDefaultGuideSteps = <LangkahPanduan>[
  LangkahPanduan(
    number: 1,
    title: 'Matikan Listrik & Gas Rumah',
    description: 'Turunkan meteran saklar MCB utama dan cabut regulator tabung gas dari kompor untuk mencegah konsleting dan kebakaran.',
  ),
  LangkahPanduan(
    number: 2,
    title: 'Pindahkan Barang & Dokumen Berharga',
    description: 'Amankan barang elektronik dan berkas penting ke lantai atas atau tempat tinggi.',
  ),
  LangkahPanduan(
    number: 3,
    title: 'Ambil Tas Siaga Bencana',
    description: 'Bawa tas berisi obat P3K, makanan kering, air, senter, powerbank, pakaian, dan peluit.',
  ),
  LangkahPanduan(
    number: 4,
    title: 'Selamatkan Anggota Keluarga',
    description: 'Pastikan anak-anak, lansia, dan orang sakit dievakuasi lebih dulu ke tempat aman.',
  ),
  LangkahPanduan(
    number: 5,
    title: 'Evakuasi ke Titik Kumpul Aman',
    description: 'Ikuti jalur evakuasi resmi, hindari jembatan rapuh dan got untuk menuju posko.',
  ),
];

// Hal-hal yang wajib dilakukan saat evakuasi banjir (Kartu Hijau / Wajib) persis sesuai SVG.
const kGuideWajibItems = <String>[
  'Prioritaskan keselamatan jiwa.',
  'Pakai alas kaki tertutup.',
  'Pantau informasi dari BPBD.',
];

// Hal-hal yang dilarang saat evakuasi banjir (Kartu Merah / Dilarang) persis sesuai SVG.
const kGuideDilarangItems = <String>[
  'Menerobos arus deras di atas betis',
  'Mendekati tiang listrik dan kabel.',
];
