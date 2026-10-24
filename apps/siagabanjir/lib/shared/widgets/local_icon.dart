import 'package:flutter/material.dart';

class LocalIcon extends StatelessWidget {
  const LocalIcon(this.name, {super.key, this.size = 22, this.color});

  final String name;
  final double size;
  // Tint opsional menyamakan status aktif/nonaktif ikon pada navbar bersama.
  final Color? color;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/icons/home/$name.png',
    width: size,
    height: size,
    color: color,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.high,
    excludeFromSemantics: true,
  );
}
