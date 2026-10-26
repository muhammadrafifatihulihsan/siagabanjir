import 'package:flutter/material.dart';

import '../../../shared/widgets/lingkup_navigasi.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/langkah_panduan.dart';
import 'widgets/banner_audio_panduan.dart';
import 'widgets/header_detail_panduan.dart';
import 'widgets/kartu_anjuran_larangan.dart';
import 'widgets/kartu_langkah_panduan.dart';
import '../data/mesin_suara_perangkat.dart';
import '../domain/mesin_suara.dart';
import 'pengendali_suara.dart';

// Layar Panduan Detail / Panduan Selamat persis sesuai desain referensi guides_detail.svg.
class LayarDetailPanduan extends StatefulWidget {
  const LayarDetailPanduan({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
    this.mesinSuara,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;
  final MesinSuara? mesinSuara;

  @override
  State<LayarDetailPanduan> createState() => _LayarDetailPanduanState();
}

class _LayarDetailPanduanState extends State<LayarDetailPanduan> {
  final Set<int> _expandedSteps = {1, 2, 3, 4, 5};
  late final _suara = PengendaliSuara(
    widget.mesinSuara ?? MesinSuaraPerangkat(),
  );

  @override
  void dispose() {
    _suara.dispose();
    super.dispose();
  }

  void _toggleStep(int stepNumber) {
    setState(() {
      if (_expandedSteps.contains(stepNumber)) {
        _expandedSteps.remove(stepNumber);
      } else {
        _expandedSteps.add(stepNumber);
      }
    });
  }

  void _putarSemua() => _suara.putar(
    kDefaultGuideSteps
        .map(
          (step) =>
              'Langkah ${step.number}. ${step.title}. ${step.description}',
        )
        .join('\n'),
  );

  void _onNavigationSelect(CitizenDestination destination) {
    switch (destination) {
      case CitizenDestination.home:
        Navigator.pop(context);
      case CitizenDestination.report:
        widget.onReport();
      case CitizenDestination.history:
        widget.onHistory();
      case CitizenDestination.profile:
        widget.onProfile();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              HeaderDetailPanduan(onBack: () => Navigator.pop(context)),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('guides-detail-scroll'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BannerAudioPanduan(
                        pengendali: _suara,
                        onPutar: _putarSemua,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Langkah Menghadapi Banjir',
                        style: TextStyle(
                          fontSize: SiagaTheme.judulBagian,
                          fontWeight: FontWeight.w700,
                          color: SiagaTheme.ink,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final step in kDefaultGuideSteps) ...[
                        KartuLangkahPanduan(
                          step: step,
                          isExpanded: _expandedSteps.contains(step.number),
                          onToggle: () => _toggleStep(step.number),
                          onRead: () => _suara.putar(
                            '${step.title}. ${step.description}',
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 6),
                      const KartuAnjuranLarangan(),
                    ],
                  ),
                ),
              ),
              if (!LingkupNavigasi.aktif(context))
                CitizenNavigation(
                  selected: CitizenDestination.home,
                  onSelect: _onNavigationSelect,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
