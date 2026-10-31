import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/klaster_wilayah.dart';
import '../../domain/state_admin_siaga.dart';
import '../widgets/preview_media_laporan.dart';

class TabLaporanIndividu extends StatefulWidget {
  const TabLaporanIndividu({
    super.key,
    required this.state,
  });

  final StateAdminSiaga state;

  @override
  State<TabLaporanIndividu> createState() => _TabLaporanIndividuState();
}

class _TabLaporanIndividuState extends State<TabLaporanIndividu> {
  String _filterStatus = 'semua';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDetailLaporan(LaporanAdminItem item) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.assignment_ind_outlined,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    item.namaPelapor,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview Media Interaktif Foto Bukti
              Center(
                child: PreviewMediaLaporan(
                  item: item,
                  size: 200,
                  showZoomHint: true,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRowInfo('Waktu Masuk', item.timestamp),
                    const SizedBox(height: 6),
                    _buildRowInfo('Wilayah', item.namaWilayah),
                    const SizedBox(height: 6),
                    _buildRowInfo('Kategori', item.kategori),
                    const SizedBox(height: 6),
                    _buildRowInfo('AI Kedalaman', item.estimasiAiTinggi),
                    const SizedBox(height: 6),
                    _buildRowInfo(
                      'Status Verifikasi',
                      item.diverifikasiOtomatisWilayah
                          ? 'Terverifikasi (Otomatis Klaster Wilayah)'
                          : item.statusVerifikasi.label,
                    ),
                    const SizedBox(height: 6),
                    _buildRowInfo(
                      'Kebutuhan Darurat',
                      item.kebutuhan.isEmpty
                          ? 'Tidak ada'
                          : item.kebutuhan.join(', '),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Deskripsi Laporan:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.deskripsi,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Color(0xFF334155),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (item.statusVerifikasi != StatusVerifikasiWilayah.terverifikasi)
            OutlinedButton(
              onPressed: () {
                widget.state.verifikasiLaporanIndividu(item.id);
                Navigator.pop(ctx);
              },
              child: const Text(
                'Verifikasi',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
              ),
            ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _konfirmasiHapusLaporan(item);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
              side: const BorderSide(color: Color(0xFFFECACA)),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _konfirmasiHapusLaporan(LaporanAdminItem item) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text(
          'Hapus Laporan',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus laporan ${item.id} oleh ${item.namaPelapor}?',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Alasan penghapusan (misal: foto tidak valid)...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () {
              final alasan = controller.text.trim();
              if (alasan.isEmpty) return;
              widget.state.hapusLaporanSpam(item.id, alasan);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan berhasil dihapus.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    var list = widget.state.semuaLaporan;

    if (_filterStatus == 'menunggu') {
      list = list
          .where((l) => l.statusVerifikasi == StatusVerifikasiWilayah.menungguTinjauan)
          .toList();
    } else if (_filterStatus == 'diverifikasi') {
      list = list
          .where((l) => l.statusVerifikasi == StatusVerifikasiWilayah.terverifikasi)
          .toList();
    } else if (_filterStatus == 'selesai') {
      list = list
          .where((l) => l.statusVerifikasi == StatusVerifikasiWilayah.selesai)
          .toList();
    }

    if (query.isNotEmpty) {
      list = list
          .where(
            (l) =>
                l.namaPelapor.toLowerCase().contains(query) ||
                l.namaWilayah.toLowerCase().contains(query) ||
                l.deskripsi.toLowerCase().contains(query),
          )
          .toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Judul
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Laporan Warga',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Akses data laporan warga untuk verifikasi, tinjauan foto bukti AI, dan penanganan spesifik.',
                    style: TextStyle(
                      fontFamily: 'Inter',
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
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${list.length} dari ${widget.state.semuaLaporan.length} Laporan',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Baris Filter & Search
          Row(
            children: [
              // Search Input
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Cari nama warga, kelurahan, atau isi laporan...',
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Filter Buttons
              _buildFilterPill('Semua', 'semua'),
              const SizedBox(width: 6),
              _buildFilterPill('Menunggu', 'menunggu'),
              const SizedBox(width: 6),
              _buildFilterPill('Ditinjau', 'diverifikasi'),
              const SizedBox(width: 6),
              _buildFilterPill('Selesai', 'selesai'),
            ],
          ),
          const SizedBox(height: 20),

          // Tabel Laporan
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: list.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Tidak ada laporan warga pada filter ini.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // Header Tabel
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 110,
                              child: Text(
                                'ID & WAKTU',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Text(
                                'MEDIA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'PELAPOR & LOKASI',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'DESKRIPSI & KEBUTUHAN',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              child: Text(
                                'STATUS',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                'AKSI',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Baris Data
                      ...list.map((item) => _buildRowItem(item)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String label, String value) {
    final isSelected = _filterStatus == value;
    return InkWell(
      onTap: () => setState(() => _filterStatus = value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem(LaporanAdminItem item) {
    final status = item.statusVerifikasi;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ID & Waktu
          SizedBox(
            width: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.id,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.timestamp.split('•').first.trim(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          // Preview Media Thumbnail
          SizedBox(
            width: 60,
            child: Align(
              alignment: Alignment.centerLeft,
              child: PreviewMediaLaporan(
                item: item,
                size: 44,
                showZoomHint: false,
              ),
            ),
          ),
          // Pelapor & Lokasi
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaPelapor,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.namaWilayah,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          // Deskripsi & Kebutuhan
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Color(0xFF334155),
                  ),
                ),
                if (item.kebutuhan.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Butuh: ${item.kebutuhan.join(", ")}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Status
          SizedBox(
            width: 140,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status.badgeBackground,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status.label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: status.badgeForeground,
                      ),
                    ),
                  ),
                  if (item.diverifikasiOtomatisWilayah) ...[
                    const SizedBox(height: 3),
                    const Text(
                      'Auto Wilayah',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Aksi
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Detail & Foto',
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF2563EB)),
                  onPressed: () => _showDetailLaporan(item),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: 'Hapus',
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFDC2626)),
                  onPressed: () => _konfirmasiHapusLaporan(item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
