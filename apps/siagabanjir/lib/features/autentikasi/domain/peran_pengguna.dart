/// Peran autentikasi pengguna pada aplikasi SiagaBanjir.
enum PeranPengguna {
  warga(
    'Warga Kota Padang',
    'Akses pelaporan banjir, pantau wilayah, dan dokumen siaga',
  ),
  admin(
    'Petugas / Admin BPBD',
    'Akses Dashboard Web verifikasi laporan dan komando siaga',
  );

  const PeranPengguna(this.label, this.deskripsi);
  final String label;
  final String deskripsi;
}
