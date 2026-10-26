import 'package:flutter/material.dart';

import '../../../shared/theme/siaga_theme.dart';
import '../../../shared/widgets/citizen_navigation.dart';
import '../domain/guide_step.dart';
import 'widgets/guides_audio_banner.dart';
import 'widgets/guides_detail_header.dart';
import 'widgets/guides_dos_and_donts_card.dart';
import 'widgets/guides_step_card.dart';

// Layar Panduan Detail / Panduan Selamat persis sesuai desain referensi guides_detail.svg.
class GuidesDetailScreen extends StatefulWidget {
  const GuidesDetailScreen({
    super.key,
    required this.onReport,
    required this.onHistory,
    required this.onProfile,
  });

  final VoidCallback onReport;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  @override
  State<GuidesDetailScreen> createState() => _GuidesDetailScreenState();
}

class _GuidesDetailScreenState extends State<GuidesDetailScreen> {
  final Set<int> _expandedSteps = {1, 2, 3, 4, 5};
  bool _isPlayingAudio = false;

  void _toggleStep(int stepNumber) {
    setState(() {
      if (_expandedSteps.contains(stepNumber)) {
        _expandedSteps.remove(stepNumber);
      } else {
        _expandedSteps.add(stepNumber);
      }
    });
  }

  void _toggleAudio() {
    setState(() {
      _isPlayingAudio = !_isPlayingAudio;
    });
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          _isPlayingAudio
              ? 'Memutar instruksi suara panduan...'
              : 'Panduan suara dihentikan.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
              GuidesDetailHeader(onBack: () => Navigator.pop(context)),
              Expanded(
                child: SingleChildScrollView(
                  key: const PageStorageKey('guides-detail-scroll'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GuidesAudioBanner(
                        isPlaying: _isPlayingAudio,
                        onTogglePlay: _toggleAudio,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Langkah Menghadapi Banjir',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: SiagaTheme.ink,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final step in kDefaultGuideSteps) ...[
                        GuidesStepCard(
                          step: step,
                          isExpanded: _expandedSteps.contains(step.number),
                          onToggle: () => _toggleStep(step.number),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 6),
                      const GuidesDosAndDontsCard(),
                    ],
                  ),
                ),
              ),
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
