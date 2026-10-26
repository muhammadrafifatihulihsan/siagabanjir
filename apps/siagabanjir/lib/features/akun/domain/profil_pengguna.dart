class KontakDarurat {
  const KontakDarurat({
    required this.name,
    required this.relation,
    required this.phone,
    required this.initials,
  });

  final String name;
  final String relation;
  final String phone;
  final String initials;
}

class ProfilPengguna {
  const ProfilPengguna({
    required this.name,
    required this.phone,
    required this.location,
    required this.initials,
    required this.nik,
    required this.email,
    required this.address,
    required this.evacuationPoint,
    required this.contacts,
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
  final String evacuationPoint;
  final List<KontakDarurat> contacts;
  final bool floodAlertEnabled;
  final String appVersion;

  ProfilPengguna copyWith({
    String? name,
    String? phone,
    String? location,
    String? initials,
    String? address,
    String? evacuationPoint,
    List<KontakDarurat>? contacts,
  }) => ProfilPengguna(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    location: location ?? this.location,
    initials: initials ?? this.initials,
    nik: nik,
    email: email,
    address: address ?? this.address,
    evacuationPoint: evacuationPoint ?? this.evacuationPoint,
    contacts: contacts ?? this.contacts,
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
    evacuationPoint: 'Masjid Raya Koto Tangah (300 m)',
    contacts: [
      KontakDarurat(
        name: 'Siti Rahma',
        relation: 'Istri',
        phone: '0813-8899-7711',
        initials: 'SR',
      ),
      KontakDarurat(
        name: 'Budi Santoso',
        relation: 'Orang Tua',
        phone: '0812-4455-6677',
        initials: 'BS',
      ),
    ],
  );
}
