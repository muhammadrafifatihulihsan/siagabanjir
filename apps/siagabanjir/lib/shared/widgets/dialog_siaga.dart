import 'package:flutter/material.dart';

import '../theme/siaga_theme.dart';

/// Dialog bersama tetap memakai fokus, tombol kembali dan semantics Material.
class DialogSiaga extends StatelessWidget {
  const DialogSiaga({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.scrollable = true,
    this.shape,
  });

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool scrollable;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    shape:
        shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: SiagaTheme.border),
        ),
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    title: title,
    titleTextStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: SiagaTheme.ink,
      height: 1.3,
    ),
    content: content,
    contentTextStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: SiagaTheme.mutedOnTint,
      height: 1.4,
    ),
    scrollable: scrollable,
    actions: actions,
    actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
    actionsOverflowButtonSpacing: 8,
  );
}

Future<void> tampilkanInfoSiaga(
  BuildContext context,
  String judul,
  String isi,
) => showDialog<void>(
  context: context,
  builder: (context) => DialogSiaga(
    title: Text(judul),
    content: Text(isi),
    actions: [
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Mengerti'),
      ),
    ],
  ),
);
