/// Data model profil petugas administrator Pusdalops BPBD Kota Padang.
class ProfilAdmin {
  const ProfilAdmin({
    required this.nama,
    required this.nip,
    required this.jabatan,
    required this.instansi,
    required this.email,
    required this.teleponPosko,
  });

  final String nama;
  final String nip;
  final String jabatan;
  final String instansi;
  final String email;
  final String teleponPosko;

  ProfilAdmin copyWith({
    String? nama,
    String? nip,
    String? jabatan,
    String? instansi,
    String? email,
    String? teleponPosko,
  }) => ProfilAdmin(
    nama: nama ?? this.nama,
    nip: nip ?? this.nip,
    jabatan: jabatan ?? this.jabatan,
    instansi: instansi ?? this.instansi,
    email: email ?? this.email,
    teleponPosko: teleponPosko ?? this.teleponPosko,
  );
}

const kDefaultProfilAdmin = ProfilAdmin(
  nama: 'Muhammad Rafi Fatihul Ihsan',
  nip: '19980412 202203 1 002',
  jabatan: 'Koordinator Pusdalops-PB',
  instansi: 'Badan Penanggulangan Bencana Daerah (BPBD) Kota Padang',
  email: 'admin.bpbd@padang.go.id',
  teleponPosko: '(0751) 777112 / 0811-666-889',
);
