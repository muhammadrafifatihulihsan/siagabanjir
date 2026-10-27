class ProfilPengguna {
  const ProfilPengguna({
    required this.name,
    required this.phone,
    required this.location,
    required this.initials,
    required this.nik,
    required this.email,
    required this.address,
    this.floodAlertEnabled = true,
    this.appVersion = 'v1.0.0+1 (Demo)',
  });

  final String name;
  final String phone;
  final String location;
  final String initials;
  final String nik;
  final String email;
  final String address;
  final bool floodAlertEnabled;
  final String appVersion;

  ProfilPengguna copyWith({
    String? name,
    String? phone,
    String? location,
    String? initials,
    String? address,
  }) => ProfilPengguna(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    location: location ?? this.location,
    initials: initials ?? this.initials,
    nik: nik,
    email: email,
    address: address ?? this.address,
    floodAlertEnabled: floodAlertEnabled,
    appVersion: appVersion,
  );

  static const defaultMock = ProfilPengguna(
    name: 'Rahmat Hidayat',
    phone: '+62 812-3456-7890',
    location: 'Koto Tangah, Padang',
    initials: 'RH',
    nik: '137107*********01',
    email: 'rahmat.hidayat@email.com',
    address: 'Jl. Adinegoro No. 12, RT 02 / RW 04, Lubuk Buaya',
  );
}
