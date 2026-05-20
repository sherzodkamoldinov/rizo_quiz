import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';

/// Большая серифная глифа категории (★/◎/▲ и т.п.).
class QuizGlyphSerif extends StatelessWidget {
  const QuizGlyphSerif(this.glyph, {this.size = 38, this.color, super.key});

  final String glyph;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Text(
      glyph,
      style: QuizTypography.categoryGlyph.copyWith(
        fontSize: size,
        color: color ?? colors.clay,
      ),
    );
  }
}
