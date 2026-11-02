/// Katalog sentral seluruh endpoint API SiagaBanjir.
/// Mengumpulkan seluruh path URL endpoint agar terstruktur, mudah dirawat,
/// dan mencegah duplikasi string mentah di berbagai repositori.
abstract final class EndpointApi {
  // ==========================================
  // 1. Metadata & Publik
  // ==========================================
  /// Pemeriksaan kesehatan server dan database (`GET /health`).
  static const String health = '/health';

  /// Informasi metadata layanan (`GET /api/v1/meta`).
  static const String meta = '/api/v1/meta';

  /// Ringkasan pemantauan banjir publik (`GET /api/v1/public/monitor`).
  static const String monitorPublik = '/api/v1/public/monitor';

  /// Manifest konten edukasi publik (`GET /api/v1/public/content/manifest`).
  static const String contentManifest = '/api/v1/public/content/manifest';

  /// Bagian konten edukasi publik (`GET /api/v1/public/content/{revision}/{kind}`).
  static String contentSection(String revision, String kind) =>
      '/api/v1/public/content/$revision/$kind';

  // ==========================================
  // 2. Autentikasi
  // ==========================================
  /// Masuk akun warga/petugas admin (`POST /api/v1/auth/login`).
  static const String login = '/api/v1/auth/login';

  /// Pendaftaran akun warga baru (`POST /api/v1/auth/signup`).
  static const String signup = '/api/v1/auth/signup';

  /// Keluar dari sesi aktif (`POST /api/v1/auth/logout`).
  static const String logout = '/api/v1/auth/logout';

  /// Pemulihan kata sandi (`POST /api/v1/auth/reset-password`).
  static const String resetPassword = '/api/v1/auth/reset-password';

  /// Pencabutan token sesi offline (`POST /api/v1/auth/revoke`).
  static const String revoke = '/api/v1/auth/revoke';

  // ==========================================
  // 3. Akun Saya (Me) & Kotak Masuk
  // ==========================================
  /// Profil data diri akun sendiri (`GET, PATCH /api/v1/me`).
  static const String me = '/api/v1/me';

  /// Pembaruan email atau kata sandi (`POST /api/v1/me/credentials`).
  static const String meCredentials = '/api/v1/me/credentials';

  /// Pembuatan kode pemulihan baru (`POST /api/v1/me/recovery-code`).
  static const String meRecoveryCode = '/api/v1/me/recovery-code';

  /// Pemeriksaan kuota dan kelayakan lapor (`GET /api/v1/me/reporting-status`).
  static const String meReportingStatus = '/api/v1/me/reporting-status';

  /// Daftar pesan kotak masuk warga (`GET /api/v1/me/inbox`).
  static const String meInbox = '/api/v1/me/inbox';

  /// Menandai pesan telah dibaca (`PUT /api/v1/me/inbox/{messageId}/read`).
  static String meInboxRead(String messageId) =>
      '/api/v1/me/inbox/$messageId/read';

  // ==========================================
  // 4. Laporan Warga & Pengiriman
  // ==========================================
  /// Riwayat laporan yang dikirim sendiri (`GET /api/v1/me/reports`).
  static const String meReports = '/api/v1/me/reports';

  /// Rincian laporan milik sendiri (`GET /api/v1/me/reports/{reportId}`).
  static String meReportDetail(String reportId) =>
      '/api/v1/me/reports/$reportId';

  /// Mengunggah berkas foto bukti laporan (`PUT, GET /api/v1/me/uploads/{uploadId}`).
  static String meUpload(String uploadId) => '/api/v1/me/uploads/$uploadId';

  /// Mengirim laporan warga (`PUT, GET /api/v1/me/submissions/{submissionId}`).
  static String meSubmission(String submissionId) =>
      '/api/v1/me/submissions/$submissionId';

  /// Menutup maksud pengiriman laporan (`POST /api/v1/me/submissions/{submissionId}/close`).
  static String meSubmissionClose(String submissionId) =>
      '/api/v1/me/submissions/$submissionId/close';

  /// Catatan tindak lanjut laporan (`GET /api/v1/reports/{reportId}/notes`).
  static String reportNotes(String reportId) =>
      '/api/v1/reports/$reportId/notes';

  /// Mengulangi analisis laporan (`POST /api/v1/reports/{reportId}/analysis-retries`).
  static String reportAnalysisRetry(String reportId) =>
      '/api/v1/reports/$reportId/analysis-retries';

  // ==========================================
  // 5. Media & Pekerjaan Asinkron (Jobs)
  // ==========================================
  /// Mengunduh media privat yang diizinkan (`GET /api/v1/media/{mediaId}`).
  static String media(String mediaId) =>
      '/api/v1/media/${Uri.encodeComponent(mediaId)}';

  /// Memeriksa status pekerjaan asinkron AI/worker (`GET /api/v1/jobs/{jobId}`).
  static String job(String jobId) => '/api/v1/jobs/$jobId';

  // ==========================================
  // 6. Petugas Admin BPBD / Posko
  // ==========================================
  /// Membaca daftar laporan masuk untuk admin (`GET /api/v1/admin/reports`).
  static const String adminReports = '/api/v1/admin/reports';

  /// Membaca rincian laporan untuk admin (`GET /api/v1/admin/reports/{reportId}`).
  static String adminReportDetail(String reportId) =>
      '/api/v1/admin/reports/$reportId';

  /// Mengoreksi penilaian laporan (`PATCH /api/v1/admin/reports/{reportId}/assessment`).
  static String adminReportAssessment(String reportId) =>
      '/api/v1/admin/reports/$reportId/assessment';

  /// Mencatat tinjauan versi laporan warga (`PUT /api/v1/admin/reports/{reportId}/review`).
  static String adminReportReview(String reportId) =>
      '/api/v1/admin/reports/$reportId/review';

  /// Memindahkan laporan ke kelompok bencana (`POST /api/v1/admin/reports/{reportId}/moves`).
  static String adminReportMoves(String reportId) =>
      '/api/v1/admin/reports/$reportId/moves';

  /// Menambahkan catatan petugas pada laporan (`POST /api/v1/admin/reports/{reportId}/notes`).
  static String adminReportNotes(String reportId) =>
      '/api/v1/admin/reports/$reportId/notes';

  /// Menghapus laporan palsu/duplikat (`POST /api/v1/admin/reports/{reportId}/deletions`).
  static String adminReportDeletions(String reportId) =>
      '/api/v1/admin/reports/$reportId/deletions';

  /// Daftar kelompok bencana/klaster kejadian (`GET /api/v1/admin/groups`).
  static const String adminGroups = '/api/v1/admin/groups';

  /// Rincian kelompok bencana (`GET /api/v1/admin/groups/{groupId}`).
  static String adminGroupDetail(String groupId) =>
      '/api/v1/admin/groups/$groupId';

  /// Laporan dalam kelompok bencana (`GET /api/v1/admin/groups/{groupId}/reports`).
  static String adminGroupReports(String groupId) =>
      '/api/v1/admin/groups/$groupId/reports';

  /// Menandai kelompok bencana selesai (`POST /api/v1/admin/groups/{groupId}/complete`).
  static String adminGroupComplete(String groupId) =>
      '/api/v1/admin/groups/$groupId/complete';

  /// Menerbitkan siaran peringatan darurat baru (`POST /api/v1/admin/messages`).
  static const String adminMessages = '/api/v1/admin/messages';

  /// Pengaturan pelaporan admin (`GET, PATCH /api/v1/admin/reporting-settings`).
  static const String adminReportingSettings =
      '/api/v1/admin/reporting-settings';

  /// Membaca pemakaian kuota laporan akun (`GET /api/v1/admin/quotas`).
  static const String adminQuotas = '/api/v1/admin/quotas';

  /// Mereset pemakaian kuota laporan warga (`POST /api/v1/admin/quota-resets`).
  static const String adminQuotaResets = '/api/v1/admin/quota-resets';
}
