enum KategoriStatusLaporan { inProgress, verified, receded }

enum FilterRiwayatLaporan {
  all('Semua'),
  inProgress('Diproses'),
  completed('Selesai');

  const FilterRiwayatLaporan(this.label);
  final String label;
}

class EntriRiwayatLaporan {
  const EntriRiwayatLaporan({
    required this.id,
    required this.status,
    required this.statusLabel,
    required this.timestamp,
    required this.location,
    required this.waterLevel,
    required this.floodType,
    required this.imageAsset,
    required this.progressNote,
    required this.isActionDispatched,
  });

  final String id;
  final KategoriStatusLaporan status;
  final String statusLabel;
  final String timestamp;
  final String location;
  final String waterLevel;
  final String floodType;
  final String imageAsset;
  final String progressNote;
  final bool isActionDispatched;

  bool matchesFilter(FilterRiwayatLaporan filter) {
    switch (filter) {
      case FilterRiwayatLaporan.all:
        return true;
      case FilterRiwayatLaporan.inProgress:
        return status == KategoriStatusLaporan.inProgress;
      case FilterRiwayatLaporan.completed:
        return status == KategoriStatusLaporan.verified ||
            status == KategoriStatusLaporan.receded;
    }
  }
}

const List<EntriRiwayatLaporan> kSampleReportHistoryItems = [
  EntriRiwayatLaporan(
    id: 'rep-001',
    status: KategoriStatusLaporan.inProgress,
    statusLabel: 'Sedang Diproses',
    timestamp: 'Hari ini • 09:15 WIB',
    location: 'Jl. Dr. Moh. Hatta, Kel. Kuranji',
    waterLevel: 'Tinggi Air: ~65 cm',
    floodType: 'Luapan Sungai',
    imageAsset: 'assets/images/reports/report_1.jpeg',
    progressNote: 'Tim Reaksi Cepat BPBD Kuranji meluncur',
    isActionDispatched: true,
  ),
  EntriRiwayatLaporan(
    id: 'rep-002',
    status: KategoriStatusLaporan.verified,
    statusLabel: 'Terverifikasi BPBD',
    timestamp: 'Kemarin • 17:30 WIB',
    location: 'Sungai Batang Kuranji Km 4',
    waterLevel: 'Tinggi Air: 120 cm',
    floodType: 'Siaga 2',
    imageAsset: 'assets/images/reports/report_2.jpeg',
    progressNote: 'Evakuasi 15 warga selesai oleh Posko',
    isActionDispatched: false,
  ),
  EntriRiwayatLaporan(
    id: 'rep-003',
    status: KategoriStatusLaporan.receded,
    statusLabel: 'Air Telah Surut',
    timestamp: '14 Hari lalu • 14:10 WIB',
    location: 'Perumahan Koto Tangah Permai',
    waterLevel: 'Tinggi Air Awal: 40 cm',
    floodType: 'Genangan',
    imageAsset: 'assets/images/reports/report_1.jpeg',
    progressNote: 'Pompa air selesai dikerahkan & jalan kering',
    isActionDispatched: false,
  ),
];
