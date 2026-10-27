class InfoSuara {
  const InfoSuara({this.perluJaringan});
  final bool? perluJaringan;
}

abstract interface class MesinSuara {
  Future<InfoSuara> siapkan(void Function() selesai, void Function() gagal);
  Future<void> putar(String teks);
  Future<void> jeda();
  Future<void> hentikan();
}
