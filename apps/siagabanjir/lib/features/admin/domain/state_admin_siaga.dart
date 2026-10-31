import 'package:flutter/foundation.dart';

import '../../../features/kontak/presentation/models/entri_kontak.dart';
import '../../../features/pantau/presentation/models/data_pantau_wilayah.dart';
import '../../../features/pesan/presentation/models/pesan_siaga.dart';
import 'klaster_wilayah.dart';
import 'profil_admin.dart';

/// Pengelola state terpusat untuk Dashboard Admin Web dan sinkronisasi
/// data operasional SiagaBanjir Kota Padang.
class StateAdminSiaga extends ChangeNotifier {
  StateAdminSiaga() {
    _inisialisasiDataAwal();
  }

  static final StateAdminSiaga instance = StateAdminSiaga();

  // 1. Data Klaster Wilayah AI & Laporan Warga
  final List<KlasterWilayahAi> _klasterList = [];
  List<KlasterWilayahAi> get klasterList => List.unmodifiable(_klasterList);

  List<LaporanAdminItem> get semuaLaporan => _klasterList
      .expand((k) => k.laporan)
      .toList()
    ..sort((a, b) => b.waktu.compareTo(a.waktu));

  // 2. Data Pantau Sungai & Infrastruktur
  StatusSungaiSorotan _sungaiSorotan = kDefaultFeaturedRiver;
  StatusSungaiSorotan get sungaiSorotan => _sungaiSorotan;

  final List<PosSungai> _posSungai = List.from(kDefaultRiverPosts);
  List<PosSungai> get posSungai => List.unmodifiable(_posSungai);

  final List<ItemInfrastruktur> _infrastruktur = List.from(
    kDefaultInfrastructureItems,
  );
  List<ItemInfrastruktur> get infrastruktur => List.unmodifiable(_infrastruktur);

  // 3. Data Broadcast Peringatan Siaga
  List<PesanSiaga> _pesanSiaga = List.from(kSampleSiagaMessages);
  List<PesanSiaga> get pesanSiaga => List.unmodifiable(_pesanSiaga);

  // 4. Data Kontak Darurat Posko Publik
  List<EntriKontak> _kontakDarurat = List.from(kPublicContacts);
  List<EntriKontak> get kontakDarurat => List.unmodifiable(_kontakDarurat);

  // 5. Kebijakan Kuota & Sakelar Galeri
  bool _izinkanGaleri = true;
  bool get izinkanGaleri => _izinkanGaleri;

  int _kuotaMaksimal = 3;
  int get kuotaMaksimal => _kuotaMaksimal;

  int _kuotaRentangJam = 6;
  int get kuotaRentangJam => _kuotaRentangJam;

  // 6. Profil Petugas Admin
  ProfilAdmin _profilAdmin = kDefaultProfilAdmin;
  ProfilAdmin get profilAdmin => _profilAdmin;

  void _inisialisasiDataAwal() {
    _klasterList.addAll([
      KlasterWilayahAi(
        id: 'klaster-koto-tangah',
        namaWilayah: 'Koto Tangah (Bantaran Batang Kuranji)',
        kecamatan: 'Kec. Koto Tangah',
        radiusKeterangan:
            'Radius pengelompokan 1.200 m • Rentang waktu 4 jam terakhir',
        tingkatTinggiAir: StatusTinggiAir.siaga2,
        estimasiKedalaman: '50 - 80 cm',
        statusVerifikasi: StatusVerifikasiWilayah.menungguTinjauan,
        indikatorAi: [
          'Akses Jalan Terputus',
          'Genangan Rumah Warga',
          'Kebutuhan Evakuasi Lansia',
        ],
        kebutuhanDominan: ['Perahu Karet', 'Logistik Makanan', 'Evakuasi Lansia'],
        catatanTindakLanjut: [
          '08:45 WIB: Laporan masuk pertama diverifikasi AI sebagai banjir valid.',
        ],
        laporan: [
          LaporanAdminItem(
            id: 'LAP-KT-001',
            namaPelapor: 'Rahmat Hidayat (Warga RT 03)',
            waktu: DateTime.now().subtract(const Duration(minutes: 42)),
            namaWilayah: 'Kel. Lubuk Buaya, Koto Tangah',
            kategori: 'Banjir Pemukiman',
            deskripsi:
                'Air Batang Kuranji meluap ke perumahan, air sudah sepinggang orang dewasa di depan rumah.',
            kebutuhan: ['Perahu Karet', 'Evakuasi Lansia'],
            estimasiAiTinggi: '70 cm',
          ),
          LaporanAdminItem(
            id: 'LAP-KT-002',
            namaPelapor: 'Siti Rahma',
            waktu: DateTime.now().subtract(const Duration(minutes: 65)),
            namaWilayah: 'Kel. Pasie Nan Tigo, Koto Tangah',
            kategori: 'Jalan Terputus',
            deskripsi:
                'Jalan utama penghubung tergenang deras, kendaraan roda dua dan empat tidak bisa melintas.',
            kebutuhan: ['Truk Evakuasi'],
            estimasiAiTinggi: '60 cm',
          ),
          LaporanAdminItem(
            id: 'LAP-KT-003',
            namaPelapor: 'Budi Santoso',
            waktu: DateTime.now().subtract(const Duration(minutes: 98)),
            namaWilayah: 'Kel. Lubuk Buaya, Koto Tangah',
            kategori: 'Banjir Pemukiman',
            deskripsi:
                'Tanggul saluran primer rembes, air mulai masuk ke teras rumah warga.',
            kebutuhan: ['Karung Pasir', 'Logistik Makanan'],
            estimasiAiTinggi: '45 cm',
          ),
          LaporanAdminItem(
            id: 'LAP-KT-004',
            namaPelapor: 'Hendri (Warga RW 02)',
            waktu: DateTime.now().subtract(const Duration(minutes: 130)),
            namaWilayah: 'Kel. Batang Kabung, Koto Tangah',
            kategori: 'Banjir Pemukiman',
            deskripsi:
                'Ada 2 keluarga lansia terjebak di dalam rumah, butuh bantuan perahu evakuasi.',
            kebutuhan: ['Perahu Karet', 'Tenaga Medis'],
            estimasiAiTinggi: '80 cm',
          ),
          LaporanAdminItem(
            id: 'LAP-KT-005',
            namaPelapor: 'Aisyah Putri',
            waktu: DateTime.now().subtract(const Duration(minutes: 180)),
            namaWilayah: 'Kel. Lubuk Buaya, Koto Tangah',
            kategori: 'Banjir Rumah',
            deskripsi:
                'Listrik padam dan air terus naik. Mohon bantuan personil BPBD.',
            kebutuhan: ['Logistik Makanan', 'Penerangan'],
            estimasiAiTinggi: '50 cm',
          ),
        ],
      ),
      KlasterWilayahAi(
        id: 'klaster-kuranji',
        namaWilayah: 'Kuranji (Sungai Sapih & Kalumbuk)',
        kecamatan: 'Kec. Kuranji',
        radiusKeterangan:
            'Radius pengelompokan 950 m • Rentang waktu 2.5 jam terakhir',
        tingkatTinggiAir: StatusTinggiAir.siaga3,
        estimasiKedalaman: '30 - 50 cm',
        statusVerifikasi: StatusVerifikasiWilayah.terverifikasi,
        indikatorAi: ['Genangan Jalan', 'Saluran Drainase Penuh'],
        kebutuhanDominan: ['Pompa Alir', 'Pengalihan Lalu Lintas'],
        catatanTindakLanjut: [
          '07:30 WIB: Pos Pantau Kuranji mencatat kenaikan air +15 cm.',
          '08:15 WIB: Regu Pompa Mobile 2 dikerahkan ke lokasi.',
        ],
        laporan: [
          LaporanAdminItem(
            id: 'LAP-KJ-001',
            namaPelapor: 'Dedi Kurniawan',
            waktu: DateTime.now().subtract(const Duration(minutes: 55)),
            namaWilayah: 'Kel. Sungai Sapih, Kuranji',
            kategori: 'Jalan Tergenang',
            deskripsi:
                'Simpang By Pass Sungai Sapih air meluap semata kaki, lajur lambat macet total.',
            kebutuhan: ['Pengalihan Arus'],
            estimasiAiTinggi: '35 cm',
          ),
          LaporanAdminItem(
            id: 'LAP-KJ-002',
            namaPelapor: 'Mira Sartika',
            waktu: DateTime.now().subtract(const Duration(minutes: 110)),
            namaWilayah: 'Kel. Kalumbuk, Kuranji',
            kategori: 'Banjir Rumah',
            deskripsi:
                'Drainase tersumbat sampah ranting pohon, air meluber ke halaman.',
            kebutuhan: ['Pembersihan Saluran'],
            estimasiAiTinggi: '40 cm',
          ),
          LaporanAdminItem(
            id: 'LAP-KJ-003',
            namaPelapor: 'Yulianis',
            waktu: DateTime.now().subtract(const Duration(minutes: 145)),
            namaWilayah: 'Kel. Korong Gadang, Kuranji',
            kategori: 'Banjir Pemukiman',
            deskripsi: 'Debit selokan utama sangat deras, warga bersiap siaga.',
            kebutuhan: ['Karung Pasir'],
            estimasiAiTinggi: '30 cm',
          ),
          LaporanAdminItem(
            id: 'LAP-KJ-004',
            namaPelapor: 'Fajar Nugraha',
            waktu: DateTime.now().subtract(const Duration(minutes: 190)),
            namaWilayah: 'Kel. Sungai Sapih, Kuranji',
            kategori: 'Genangan Air',
            deskripsi: 'Air rembesan mendekati pintu rumah, butuh pemantauan.',
            kebutuhan: ['Pompa Air'],
            estimasiAiTinggi: '30 cm',
          ),
        ],
      ),
      KlasterWilayahAi(
        id: 'klaster-nanggalo',
        namaWilayah: 'Nanggalo (Siteba & Tabing Banda Gadang)',
        kecamatan: 'Kec. Nanggalo',
        radiusKeterangan:
            'Radius pengelompokan 800 m • Rentang waktu 1 jam terakhir',
        tingkatTinggiAir: StatusTinggiAir.normal,
        estimasiKedalaman: '15 - 25 cm',
        statusVerifikasi: StatusVerifikasiWilayah.menungguTinjauan,
        indikatorAi: ['Genangan Ringan'],
        kebutuhanDominan: ['Pemantauan Debit'],
        catatanTindakLanjut: const [],
        laporan: [
          LaporanAdminItem(
            id: 'LAP-NG-001',
            namaPelapor: 'Zulfikar',
            waktu: DateTime.now().subtract(const Duration(minutes: 25)),
            namaWilayah: 'Kel. Surau Gadang, Siteba',
            kategori: 'Genangan Jalan',
            deskripsi:
                'Genangan air setinggi 20 cm di jalan pasar Siteba pasca hujan lebat.',
            kebutuhan: ['Pengaturan Lalu Lintas'],
            estimasiAiTinggi: '20 cm',
          ),
          LaporanAdminItem(
            id: 'LAP-NG-002',
            namaPelapor: 'Nurul Huda',
            waktu: DateTime.now().subtract(const Duration(minutes: 50)),
            namaWilayah: 'Kel. Kurao Pagang, Nanggalo',
            kategori: 'Genangan Parit',
            deskripsi:
                'Parit jalan penuh namun belum meluap ke badan jalan raya.',
            kebutuhan: const [],
            estimasiAiTinggi: '15 cm',
          ),
        ],
      ),
    ]);
  }

  // --- AKSI PENGELOLAAN KLASTER & LAPORAN ---

  void tambahLaporanWarga({
    required String kategori,
    required String deskripsi,
    required List<String> kebutuhan,
    Uint8List? foto,
  }) {
    final item = LaporanAdminItem(
      id: 'LAP-BARU-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      namaPelapor: 'Warga Kota Padang (Laporan Baru)',
      waktu: DateTime.now(),
      namaWilayah: 'Kel. Lubuk Buaya, Koto Tangah',
      kategori: kategori,
      deskripsi: deskripsi,
      kebutuhan: kebutuhan,
      foto: foto,
      estimasiAiTinggi: '50 cm',
    );

    // Otomatis kelompokkan ke klaster terdekat (Koto Tangah)
    final idx = _klasterList.indexWhere((k) => k.id == 'klaster-koto-tangah');
    if (idx != -1) {
      final klasterLama = _klasterList[idx];
      final laporanBaru = [item, ...klasterLama.laporan];
      _klasterList[idx] = klasterLama.copyWith(
        laporan: laporanBaru,
        statusVerifikasi: StatusVerifikasiWilayah.menungguTinjauan,
      );
    }
    notifyListeners();
  }

  void verifikasiKlaster(String idKlaster) {
    final idx = _klasterList.indexWhere((k) => k.id == idKlaster);
    if (idx == -1) return;
    final k = _klasterList[idx];
    final waktu =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB';
    final catatan = [
      ...k.catatanTindakLanjut,
      '$waktu: Klaster wilayah telah diverifikasi dan disetujui petugas BPBD.',
    ];
    final updatedLaporan = k.laporan
        .map(
          (l) => l.copyWith(
            statusVerifikasi: StatusVerifikasiWilayah.terverifikasi,
          ),
        )
        .toList();

    _klasterList[idx] = k.copyWith(
      statusVerifikasi: StatusVerifikasiWilayah.terverifikasi,
      catatanTindakLanjut: catatan,
      laporan: updatedLaporan,
    );
    notifyListeners();
  }

  void tambahCatatanTindakLanjutKlaster(String idKlaster, String catatanBaru) {
    final idx = _klasterList.indexWhere((k) => k.id == idKlaster);
    if (idx == -1 || catatanBaru.trim().isEmpty) return;
    final k = _klasterList[idx];
    final waktu =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB';
    final entriCatatan = '$waktu: $catatanBaru';
    final catatan = [...k.catatanTindakLanjut, entriCatatan];

    final updatedLaporan = k.laporan
        .map((l) => l.copyWith(catatanPetugas: [...l.catatanPetugas, catatanBaru]))
        .toList();

    _klasterList[idx] = k.copyWith(
      catatanTindakLanjut: catatan,
      laporan: updatedLaporan,
    );
    notifyListeners();
  }

  void selesaikanKlaster(String idKlaster) {
    final idx = _klasterList.indexWhere((k) => k.id == idKlaster);
    if (idx == -1) return;
    final k = _klasterList[idx];
    final waktu =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB';
    final catatan = [
      ...k.catatanTindakLanjut,
      '$waktu: Kondisi banjir di wilayah ini dinyatakan selesai dan air telah surut.',
    ];
    final updatedLaporan = k.laporan
        .map(
          (l) => l.copyWith(statusVerifikasi: StatusVerifikasiWilayah.selesai),
        )
        .toList();

    _klasterList[idx] = k.copyWith(
      statusVerifikasi: StatusVerifikasiWilayah.selesai,
      tingkatTinggiAir: StatusTinggiAir.normal,
      catatanTindakLanjut: catatan,
      laporan: updatedLaporan,
    );
    notifyListeners();
  }

  void koreksiLaporanIndividu(
    String idLaporan,
    StatusVerifikasiWilayah statusBaru,
  ) {
    for (int i = 0; i < _klasterList.length; i++) {
      final k = _klasterList[i];
      final lapIdx = k.laporan.indexWhere((l) => l.id == idLaporan);
      if (lapIdx != -1) {
        final listLaporan = List<LaporanAdminItem>.from(k.laporan);
        listLaporan[lapIdx] = listLaporan[lapIdx].copyWith(
          statusVerifikasi: statusBaru,
        );
        _klasterList[i] = k.copyWith(laporan: listLaporan);
        notifyListeners();
        return;
      }
    }
  }

  void hapusLaporanSpam(String idLaporan, String alasan) {
    for (int i = 0; i < _klasterList.length; i++) {
      final k = _klasterList[i];
      final listLaporan = k.laporan.where((l) => l.id != idLaporan).toList();
      if (listLaporan.length != k.laporan.length) {
        _klasterList[i] = k.copyWith(laporan: listLaporan);
        notifyListeners();
        return;
      }
    }
  }

  // --- AKSI STATUS SUNGAI & SENSOR ---

  void updateSungaiSorotan({
    required int waterLevelCm,
    required StatusTinggiAir status,
    required String statusLabel,
  }) {
    final change = waterLevelCm - _sungaiSorotan.waterLevelCm;
    _sungaiSorotan = StatusSungaiSorotan(
      name: _sungaiSorotan.name,
      waterLevelCm: waterLevelCm,
      changeCm: change,
      status: status,
      spillLimitCm: 150,
      spillRemainingCm: (150 - waterLevelCm).clamp(0, 150),
      statusLabel: statusLabel,
    );
    notifyListeners();
  }

  void updateStatusInfrastruktur(String id, String statusBaru) {
    final idx = _infrastruktur.indexWhere((it) => it.id == id);
    if (idx != -1) {
      _infrastruktur[idx] = ItemInfrastruktur(
        id: id,
        title: _infrastruktur[idx].title,
        status: statusBaru,
      );
      notifyListeners();
    }
  }

  // --- AKSI BROADCAST SIARAN PERINGATAN ---

  void terbitkanPeringatanBaru(PesanSiaga pesan) {
    _pesanSiaga = [pesan, ..._pesanSiaga];
    notifyListeners();
  }

  void cabutPeringatan(String idPesan) {
    _pesanSiaga = _pesanSiaga.where((p) => p.id != idPesan).toList();
    notifyListeners();
  }

  // --- AKSI KONTAK DARURAT POSKO ---

  void tambahKontakPosko(EntriKontak kontak) {
    _kontakDarurat = [kontak, ..._kontakDarurat];
    notifyListeners();
  }

  void hapusKontakPosko(String name) {
    _kontakDarurat = _kontakDarurat.where((k) => k.name != name).toList();
    notifyListeners();
  }

  // --- AKSI KEBIJAKAN & KUOTA ---

  void setIzinkanGaleri(bool value) {
    _izinkanGaleri = value;
    notifyListeners();
  }

  void setKuotaPengaturan(int kuota, int jam) {
    _kuotaMaksimal = kuota;
    _kuotaRentangJam = jam;
    notifyListeners();
  }

  void resetSemuaKuota() {
    notifyListeners();
  }

  // --- AKSI PROFIL ADMIN ---

  void updateProfilAdmin(ProfilAdmin profilBaru) {
    _profilAdmin = profilBaru;
    notifyListeners();
  }
}
