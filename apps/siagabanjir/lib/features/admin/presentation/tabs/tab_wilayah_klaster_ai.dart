import 'package:flutter/material.dart';

import '../../domain/klaster_wilayah.dart';
import '../../domain/state_admin_siaga.dart';
import '../widgets/modal_bukti_wilayah.dart';

class TabWilayahKlasterAi extends StatelessWidget {
  const TabWilayahKlasterAi({
    super.key,
    required this.state,
  });

  final StateAdminSiaga state;

  @override
  Widget build(BuildContext context) {
    // Urutkan klaster berdasarkan jumlah laporan terbanyak
    final daftarKlaster = List<KlasterWilayahAi>.from(state.klasterList)
      ..sort((a, b) => b.totalLaporan.compareTo(a.totalLaporan));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Judul & Edukasi Aturan Wilayah AI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Wilayah dengan Laporan Terbanyak (Klaster AI)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'AI otomatis mengelompokkan laporan warga dalam radius 1.500 m / 6 jam agar admin dapat meninjau bukti sekaligus.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${daftarKlaster.length} Klaster Wilayah Aktif',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Banner Penjelasan Prinsip AI Clustering
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.rule_rounded,
                    color: Color(0xFFB45309),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aturan Agregasi 1 Wilayah (Standar FRD-DEC-020 & DEC-023)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Dua laporan warga dikelompokkan ke dalam satu wilayah yang sama jika jarak geografis antar tetangga ≤ 1.500 meter dan selisih waktu ≤ 6 jam, dengan batas bentang maksimal keseluruhan klaster ≤ 3.000 meter / 12 jam. AI memverifikasi validitas foto genangan banjir sehingga admin dapat langsung mengambil tindakan kolektif.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // List Klaster Wilayah Terurut Laporan Terbanyak
          ...daftarKlaster.asMap().entries.map((entry) {
            final urutan = entry.key + 1;
            final klaster = entry.value;
            return _buildKlasterDetailCard(context, klaster, urutan);
          }),
        ],
      ),
    );
  }

  Widget _buildKlasterDetailCard(
    BuildContext context,
    KlasterWilayahAi k,
    int ranking,
  ) {
    final level = k.tingkatTinggiAir;
    final verifikasi = k.statusVerifikasi;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card Klaster
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nomor Peringkat Laporan Terbanyak
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: ranking == 1
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '#$ranking',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              k.namaWilayah,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: level.badgeBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              level.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: level.badgeForeground,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: verifikasi.badgeBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              verifikasi.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: verifikasi.badgeForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${k.kecamatan} • ${k.radiusKeterangan}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Ringkasan Indikator AI & Kebutuhan Kolektif
                      Row(
                        children: [
                          _buildMiniBadge(
                            icon: Icons.water_outlined,
                            label: 'Estimasi Kedalaman: ${k.estimasiKedalaman}',
                            bg: const Color(0xFFF1F5F9),
                            text: const Color(0xFF334155),
                          ),
                          const SizedBox(width: 8),
                          _buildMiniBadge(
                            icon: Icons.checklist_rtl_rounded,
                            label: 'Kebutuhan: ${k.kebutuhanDominan.join(", ")}',
                            bg: const Color(0xFFEFF6FF),
                            text: const Color(0xFF1D4ED8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Baris Footer Aksi Cepat Klaster
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.collections_outlined,
                      size: 16,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Terkumpul ${k.totalLaporan} Bukti Foto & Laporan Warga',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Tombol Verifikasi Cepat
                    if (k.statusVerifikasi != StatusVerifikasiWilayah.terverifikasi)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                        ),
                        onPressed: () => state.verifikasiKlaster(k.id),
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                        label: const Text(
                          'Verifikasi Sekaligus',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    const SizedBox(width: 8),
                    // Tombol Buka Seluruh Bukti
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () =>
                          ModalBuktiWilayah.show(context, klaster: k, state: state),
                      icon: const Icon(Icons.folder_open_rounded, size: 16),
                      label: const Text(
                        'Buka Kumpulan Bukti Wilayah',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge({
    required IconData icon,
    required String label,
    required Color bg,
    required Color text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
