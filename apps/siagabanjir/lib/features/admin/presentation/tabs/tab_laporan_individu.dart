import 'package:flutter/material.dart';

import '../../../../shared/widgets/dialog_siaga.dart';
import '../../domain/klaster_wilayah.dart';
import '../../domain/state_admin_siaga.dart';
import '../widgets/preview_media_laporan.dart';
import '../widgets/tata_letak_admin.dart';

class TabLaporanIndividu extends StatefulWidget {
  const TabLaporanIndividu({super.key, required this.state});

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
                      fontSize: 14,
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
                          ? '${item.statusVerifikasi.label} (melalui klaster wilayah)'
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
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.deskripsi,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xFF334155),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (item.statusVerifikasi == StatusVerifikasiWilayah.menungguTinjauan)
            FilledButton(
              onPressed: () {
                widget.state.verifikasiLaporanIndividu(item.id);
                Navigator.pop(ctx);
              },
              child: const Text(
                'Verifikasi',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
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
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _konfirmasiHapusLaporan(LaporanAdminItem item) async {
    var alasan = '';
    final formKey = GlobalKey<FormState>();
    await showDialog<void>(
      context: context,
      builder: (ctx) => DialogSiaga(
        title: const Text('Hapus Laporan'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Hapus laporan ${item.id} oleh ${item.namaPelapor}?'),
              const SizedBox(height: 12),
              const Text(
                'Isi, foto, dan catatan laporan tidak dapat dibuka kembali. '
                'Laporan dikeluarkan dari wilayah tanpa mengembalikan kuota.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: (value) => alasan = value,
                maxLength: 500,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alasan penghapusan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Isi alasan penghapusan.'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              widget.state.hapusLaporanSpam(item.id, alasan.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Hapus Laporan'),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    var list = widget.state.semuaLaporan;

    if (_filterStatus == 'menunggu') {
      list = list
          .where(
            (l) =>
                l.statusVerifikasi == StatusVerifikasiWilayah.menungguTinjauan,
          )
          .toList();
    } else if (_filterStatus == 'diverifikasi') {
      list = list
          .where(
            (l) => l.statusVerifikasi == StatusVerifikasiWilayah.terverifikasi,
          )
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
                l.id.toLowerCase().contains(query) ||
                l.namaPelapor.toLowerCase().contains(query) ||
                l.namaWilayah.toLowerCase().contains(query) ||
                l.deskripsi.toLowerCase().contains(query),
          )
          .toList();
    }

    return HalamanAdmin(
      children: [
        const JudulAdmin('Laporan Warga'),
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Cari laporan',
            hintText: 'ID, pelapor, wilayah, atau deskripsi',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _filter('Semua', 'semua'),
            _filter('Menunggu', 'menunggu'),
            _filter('Ditinjau', 'diverifikasi'),
            _filter('Selesai', 'selesai'),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '${list.length} dari ${widget.state.semuaLaporan.length} laporan',
          style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                const Text('Tidak ada laporan yang sesuai.'),
                TextButton(
                  onPressed: () => setState(() {
                    _searchController.clear();
                    _filterStatus = 'semua';
                  }),
                  child: const Text('Hapus Pencarian dan Filter'),
                ),
              ],
            ),
          ),
        if (list.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowColor: const WidgetStatePropertyAll(
                    Color(0xFFE1EDFF),
                  ),
                  dataRowMinHeight: 88,
                  dataRowMaxHeight: double.infinity,
                  columnSpacing: 20,
                  horizontalMargin: 16,
                  columns: const [
                    DataColumn(label: Text('Laporan')),
                    DataColumn(label: Text('Pelapor dan lokasi')),
                    DataColumn(label: Text('Deskripsi')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: [
                    for (final item in list)
                      DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                PreviewMediaLaporan(
                                  item: item,
                                  size: 48,
                                  showZoomHint: false,
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 130,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.id,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.timestamp,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 180,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.namaPelapor,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.namaWilayah,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 240,
                              child: Text(
                                item.deskripsi,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 140,
                              child: Text(item.statusVerifikasi.label),
                            ),
                          ),
                          DataCell(
                            TextButton(
                              onPressed: () => _showDetailLaporan(item),
                              child: const Text('Lihat Detail'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _filter(String label, String value) => ChoiceChip(
    label: Text(label),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    selectedColor: const Color(0xFFEFF6FF),
    checkmarkColor: const Color(0xFF1D4ED8),
    selected: _filterStatus == value,
    onSelected: (_) => setState(() => _filterStatus = value),
  );
}
