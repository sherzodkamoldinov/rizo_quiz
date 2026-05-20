import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';

/// Декоративный фон страниц квиза.
///
/// Два слоя как в `design_handoff_rizo_quiz/mobile-styles.css`:
/// 1. Три radial-gradient «пятна» (clay + navy).
/// 2. Тонкая SVG-сетка: концентрические круги, ромб, точки, волна.
///
/// Растягивается до размеров родителя, не реагирует на тапы.
class QuizBackdropDecor extends StatelessWidget {
  const QuizBackdropDecor({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _BackdropPainter(colors),
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter(this.colors);

  final QuizColors colors;

  // SVG-холст из дизайна — 402×874.
  static const double _svgW = 402;
  static const double _svgH = 874;

  // Общая прозрачность ::after-слоя (см. CSS `.m-app::after`).
  static const double _layerOpacity = 0.55;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final dx = w / _svgW;
    final dy = h / _svgH;
    final rect = Rect.fromLTWH(0, 0, w, h);

    _paintRadialBlobs(canvas, rect);
    _paintCircles(canvas, w, h);
    _paintDiamond(canvas, dx, dy);
    _paintDots(canvas, dx, dy);
    _paintWave(canvas, dx, dy);
  }

  void _paintRadialBlobs(Canvas canvas, Rect rect) {
    // Top-right clay 22%
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(1.1, -1.0),
          radius: 0.7,
          colors: [
            colors.clay.withValues(alpha: 0.22),
            colors.clay.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );

    // Bottom-left navy 10%
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-1.2, 1.1),
          radius: 0.65,
          colors: [
            colors.ink.withValues(alpha: 0.10),
            colors.ink.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );

    // Mid-right clay 10%
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.9, 0.4),
          radius: 0.45,
          colors: [
            colors.clay.withValues(alpha: 0.10),
            colors.clay.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );
  }

  void _paintCircles(Canvas canvas, double w, double h) {
    final center = Offset(w * 340 / _svgW, h * 120 / _svgH);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = colors.ink.withValues(alpha: 0.06 * _layerOpacity);
    for (final r in <double>[90, 130, 170]) {
      canvas.drawCircle(center, r * w / _svgW, paint);
    }
  }

  void _paintDiamond(Canvas canvas, double dx, double dy) {
    final path = Path()
      ..moveTo(50 * dx, 720 * dy)
      ..lineTo(90 * dx, 680 * dy)
      ..lineTo(130 * dx, 720 * dy)
      ..lineTo(90 * dx, 760 * dy)
      ..close();
    canvas.drawPath(
      path,
      Paint()..color = colors.clay.withValues(alpha: 0.07 * _layerOpacity),
    );
  }

  void _paintDots(Canvas canvas, double dx, double dy) {
    final paint = Paint()..color = colors.ink.withValues(alpha: 0.04 * _layerOpacity);
    for (final col in <double>[40, 70, 100]) {
      for (final row in <double>[420, 450]) {
        canvas.drawCircle(Offset(col * dx, row * dy), 6 * dx, paint);
      }
    }
  }

  void _paintWave(Canvas canvas, double dx, double dy) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = colors.clay.withValues(alpha: 0.12 * _layerOpacity);
    // Q 100,540 220,580 → T 460,580 (reflected control = 340,620)
    final path = Path()
      ..moveTo(-20 * dx, 580 * dy)
      ..quadraticBezierTo(100 * dx, 540 * dy, 220 * dx, 580 * dy)
      ..quadraticBezierTo(340 * dx, 620 * dy, 460 * dx, 580 * dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter old) => old.colors != colors;
}
