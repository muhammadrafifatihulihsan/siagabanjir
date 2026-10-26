import 'package:flutter/material.dart';

import '../../../../shared/theme/siaga_theme.dart';

// Tombol opsi masuk dengan akun Google beserta ikon 4 warna resmi Google.
class TombolMasukGoogle extends StatelessWidget {
  const TombolMasukGoogle({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Lanjut dengan Google',
    child: SizedBox(
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: SiagaTheme.ink,
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onPressed,
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoGoogle(size: 18),
              SizedBox(width: 12),
              Text(
                'Lanjut dengan Google',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Logo Google 4 warna digambar presisi menggunakan CustomPainter dari kurva SVG.
class LogoGoogle extends StatelessWidget {
  const LogoGoogle({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: const _PelukisLogoGoogle());
}

class _PelukisLogoGoogle extends CustomPainter {
  const _PelukisLogoGoogle();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 18.0;
    canvas.save();
    canvas.scale(scale, scale);
    // Translasi titik awal kurva dari SVG auth_login: origin (101.75, 601.0) menjadi (0, 0)
    canvas.translate(-101.75, -601.0);

    // 1. Bagian Biru Google (#4285F4)
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final bluePath = Path()
      ..moveTo(119.559, 610.202)
      ..cubicTo(119.559, 609.677, 119.514, 609.152, 119.416, 608.65)
      ..lineTo(110.75, 608.65)
      ..lineTo(110.75, 612.032)
      ..lineTo(115.7, 612.032)
      ..cubicTo(115.483, 613.172, 114.845, 614.132, 113.9, 614.777)
      ..lineTo(113.9, 617.065)
      ..lineTo(116.802, 617.065)
      ..cubicTo(118.497, 615.497, 119.559, 613.187, 119.559, 610.202)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // 2. Bagian Hijau Google (#34A853)
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;
    final greenPath = Path()
      ..moveTo(110.75, 619.0)
      ..cubicTo(113.18, 619.0, 115.213, 618.19, 116.698, 616.817)
      ..lineTo(113.795, 614.53)
      ..cubicTo(112.985, 615.07, 111.958, 615.4, 110.75, 615.4)
      ..cubicTo(108.403, 615.4, 106.415, 613.817, 105.702, 611.68)
      ..lineTo(102.688, 611.68)
      ..lineTo(102.688, 614.042)
      ..cubicTo(104.188, 617.02, 107.255, 619.0, 110.75, 619.0)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // 3. Bagian Kuning Google (#FBBC05)
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;
    final yellowPath = Path()
      ..moveTo(105.702, 611.68)
      ..cubicTo(105.515, 611.14, 105.418, 610.563, 105.418, 610.0)
      ..cubicTo(105.418, 609.438, 105.515, 608.86, 105.702, 608.32)
      ..lineTo(105.702, 605.958)
      ..lineTo(102.688, 605.958)
      ..cubicTo(102.087, 607.165, 101.75, 608.545, 101.75, 610.0)
      ..cubicTo(101.75, 611.455, 102.087, 612.835, 102.688, 614.043)
      ..lineTo(105.702, 611.68)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // 4. Bagian Merah Google (#EA4335)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;
    final redPath = Path()
      ..moveTo(110.75, 604.562)
      ..cubicTo(112.078, 604.562, 113.263, 605.02, 114.2, 605.913)
      ..lineTo(116.765, 603.348)
      ..cubicTo(115.213, 601.893, 113.18, 601.0, 110.75, 601.0)
      ..cubicTo(107.255, 601.0, 104.188, 602.98, 102.688, 605.957)
      ..lineTo(105.702, 608.32)
      ..cubicTo(106.415, 606.183, 108.403, 604.6, 110.75, 604.6)
      ..close();
    canvas.drawPath(redPath, redPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
