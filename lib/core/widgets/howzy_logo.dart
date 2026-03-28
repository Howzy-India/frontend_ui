import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Standalone HowzyLogo widget (not a `part` — can be imported anywhere)
class HowzyLogoWidget extends StatelessWidget {
  const HowzyLogoWidget({super.key, this.dark = false, this.large = false});
  final bool dark;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final iconSize = large ? 44.0 : 28.0;
    final fontSize = large ? 26.0 : 18.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: CustomPaint(painter: _HowzyMarkPainter(dark: dark)),
        ),
        const SizedBox(width: 7),
        Text(
          'howzy',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: dark ? Colors.white : const Color(0xFF0F172A),
            height: 1,
          ),
        ),
        Text(
          '.in',
          style: TextStyle(
            fontSize: fontSize * 0.55,
            fontWeight: FontWeight.w700,
            color: AppColors.indigo600,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _HowzyMarkPainter extends CustomPainter {
  const _HowzyMarkPainter({this.dark = false});
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;

    final path = Path()
      ..moveTo(20 * s, 70 * s)
      ..lineTo(20 * s, 40 * s)
      ..lineTo(50 * s, 15 * s)
      ..lineTo(80 * s, 40 * s)
      ..lineTo(80 * s, 90 * s);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14 * s
        ..strokeCap = StrokeCap.butt
        ..strokeJoin = StrokeJoin.miter
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC084FC), Color(0xFF4F46E5)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final windowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = dark ? Colors.white : const Color(0xFF0F172A);

    for (final (double x, double y) in [
      (42.0, 52.0), (52.0, 52.0),
      (42.0, 62.0), (52.0, 62.0),
    ]) {
      canvas.drawRect(Rect.fromLTWH(x * s, y * s, 6 * s, 6 * s), windowPaint);
    }
  }

  @override
  bool shouldRepaint(_HowzyMarkPainter old) => old.dark != dark;
}
