import 'dart:typed_data';

class EntriRiwayatLaporan {
  const EntriRiwayatLaporan({
    required this.waktu,
    required this.kategori,
    required this.deskripsi,
    required this.kebutuhan,
    this.foto,
  });
  final DateTime waktu;
  final String kategori;
  final String deskripsi;
  final List<String> kebutuhan;
  final Uint8List? foto;
  String get timestamp =>
      '${waktu.day}/${waktu.month}/${waktu.year} • ${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}';
}
