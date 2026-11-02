/// Data profil warga yang ditampilkan pada layar Akun & Profil.
///
/// Seluruh nilai berasal dari `GET /api/v1/me`; tidak ada lagi nomor telepon,
/// NIK, atau domisili contoh yang dipaksakan saat backend belum mengisi data.
class ProfilPengguna {
  const ProfilPengguna({
    required this.name,
    required this.phone,
    required this.location,
    required this.initials,
    required this.email,
    required this.address,
    this.floodAlertEnabled = true,
    this.appVersion = 'v1.0.0+1',
  });

  final String name;
  final String phone;
  final String location;
  final String initials;
  final String email;
  final String address;
  final bool floodAlertEnabled;
  final String appVersion;

  ProfilPengguna copyWith({
    String? name,
    String? phone,
    String? location,
    String? initials,
    String? email,
    String? address,
    bool? floodAlertEnabled,
  }) => ProfilPengguna(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    location: location ?? this.location,
    initials: initials ?? this.initials,
    email: email ?? this.email,
    address: address ?? this.address,
    floodAlertEnabled: floodAlertEnabled ?? this.floodAlertEnabled,
    appVersion: appVersion,
  );

  /// Profil awal sebelum data backend termuat (tanpa data pribadi palsu).
  static const kosong = ProfilPengguna(
    name: 'Warga Siaga',
    phone: '',
    location: '',
    initials: 'WS',
    email: '',
    address: '',
  );

  /// Contoh tampilan untuk pratinjau desain; bukan data akun sungguhan.
  static const defaultMock = ProfilPengguna(
    name: 'Rahmat Hidayat',
    phone: '+62 812-3456-7890',
    location: 'Koto Tangah, Padang',
    initials: 'RH',
    email: 'rahmat.hidayat@email.com',
    address: 'Jl. Adinegoro No. 12, RT 02 / RW 04, Lubuk Buaya',
  );
}
