// UI destinations for the home mockup, not API routes or business models.
enum HomeAction {
  notifications(
    'Notifikasi',
    'notifications',
    'Tiga pemberitahuan contoh untuk melihat tampilan beranda.',
  ),
  monitor(
    'Pantau Wilayah',
    'monitor',
    'Tempat melihat ringkasan kondisi wilayah dan pembaruan laporan publik.',
  ),
  contacts(
    'Kontak Darurat',
    'contacts',
    'Tempat menemukan kontak posko dan nomor penting. Mockup ini tidak melakukan panggilan.',
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
    'Tempat mengelola KK, KTP, dan berkas penting. Tidak ada dokumen pribadi pada mockup ini.',
  ),
  report(
    'Lapor Banjir Cepat',
    'camera',
    'Tempat memulai laporan banjir. Kamera, analisis, dan pengiriman belum diaktifkan.',
  ),
  history(
    'Riwayat Laporan',
    'history',
    'Tempat melihat laporan yang pernah dikirim. Belum ada laporan sungguhan pada mockup ini.',
  ),
  profile(
    'Profil',
    'profile',
    'Tempat mengelola akun dan profil. Mockup ini tidak menggunakan sesi akun.',
  ),
  family(
    'Data Keluarga',
    'documents',
    'Tempat melengkapi anggota dan kebutuhan keluarga.',
  ),
  all(
    'Akses Kesiapsiagaan',
    'home',
    'Pilih fitur untuk mencoba pintu masuk dari beranda.',
  );

  const HomeAction(this.title, this.icon, this.description);

  final String title;
  final String icon;
  final String description;
}
