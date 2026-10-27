// UI destinations for the home mockup, not API routes or business models.
enum AksiBeranda {
  notifications(
    'Notifikasi',
    'notifications',
    'Pusat informasi dan pemberitahuan peringatan banjir terkini.',
  ),
  monitor(
    'Pantau Wilayah',
    'monitor',
    'Tempat melihat ringkasan kondisi wilayah dan pembaruan laporan publik.',
  ),
  contacts(
    'Kontak Darurat',
    'contacts',
    'Tempat menemukan kontak posko dan nomor penting darurat.',
  ),
  bag(
    'Tas Siaga',
    'bag',
    'Tempat menyiapkan checklist perlengkapan darurat keluarga.',
  ),
  guides(
    'Panduan Selamat',
    'guides',
    'Tempat membaca panduan kesiapsiagaan dan evakuasi.',
  ),
  documents(
    'Dokumen Siaga Keluarga',
    'documents',
    'Tempat mengelola KK, KTP, dan berkas penting keluarga.',
  ),
  report(
    'Lapor Banjir Cepat',
    'camera',
    'Laporkan kondisi genangan dan banjir di sekitar Anda secara cepat.',
  ),
  history(
    'Riwayat Laporan',
    'history',
    'Lihat daftar dan status riwayat laporan kejadian banjir yang Anda kirimkan.',
  ),
  profile(
    'Profil',
    'profile',
    'Kelola data pribadi, informasi domisili, dan preferensi akun SiagaBanjir.',
  ),
  family(
    'Data Keluarga',
    'documents',
    'Tempat melengkapi anggota dan kebutuhan keluarga.',
  ),
  all(
    'Akses Kesiapsiagaan',
    'home',
    'Pilih menu layanan siaga bencana banjir yang tersedia.',
  );

  const AksiBeranda(this.title, this.icon, this.description);

  final String title;
  final String icon;
  final String description;
}
