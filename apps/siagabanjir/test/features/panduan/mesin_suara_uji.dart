import 'package:siagabanjir/features/panduan/domain/mesin_suara.dart';

class MesinSuaraUji implements MesinSuara {
  final dibaca = <String>[];
  int berhenti = 0;
  int dijeda = 0;
  bool gagal = false;
  void Function()? selesai;
  @override
  Future<InfoSuara> siapkan(
    void Function() selesai,
    void Function() error,
  ) async {
    if (gagal) throw StateError('Tidak ada suara');
    this.selesai = selesai;
    return const InfoSuara(perluJaringan: false);
  }

  @override
  Future<void> putar(String teks) async {
    dibaca.add(teks);
  }

  @override
  Future<void> jeda() async {
    dijeda++;
  }

  @override
  Future<void> hentikan() async {
    berhenti++;
  }
}
