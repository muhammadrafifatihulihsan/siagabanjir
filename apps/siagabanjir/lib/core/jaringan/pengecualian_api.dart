/// Pengecualian terstruktur yang dihasilkan dari kesalahan komunikasi API Backend.
class PengecualianApi implements Exception {
  const PengecualianApi({
    required this.pesan,
    this.kodeStatus,
    this.kodeError,
    this.rincian,
  });

  final String pesan;
  final int? kodeStatus;
  final String? kodeError;
  final dynamic rincian;

  @override
  String toString() {
    if (kodeStatus != null) {
      return 'PengecualianApi(status: $kodeStatus, pesan: $pesan)';
    }
    return 'PengecualianApi(pesan: $pesan)';
  }
}
