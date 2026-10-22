import 'package:flutter/material.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon(this.name, {super.key, this.size = 22});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/icons/home/$name.png',
    width: size,
    height: size,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.high,
    excludeFromSemantics: true,
  );
}
