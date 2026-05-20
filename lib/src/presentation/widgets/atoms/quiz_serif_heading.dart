import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';

enum QuizHeadingVariant { h1, question, section, scoreBig }

/// Серифный заголовок. С опциональным italic-акцентом цвета `clay` в конце.
class QuizSerifHeading extends StatelessWidget {
  const QuizSerifHeading({
    required this.text,
    this.accent,
    this.variant = QuizHeadingVariant.h1,
    this.color,
    this.accentColor,
    this.textAlign,
    super.key,
  });

  final String text;

  /// Финальное слово/часть, отрисованное italic + clay цветом.
  final String? accent;
  final QuizHeadingVariant variant;
  final Color? color;
  final Color? accentColor;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final base = _styleFor(variant).copyWith(color: color ?? colors.ink);
    if (accent == null || accent!.isEmpty) {
      return Text(text, style: base, textAlign: textAlign);
    }
    return Text.rich(
      TextSpan(
        text: '$text ',
        style: base,
        children: [
          TextSpan(
            text: accent,
            style: base.copyWith(
              fontStyle: FontStyle.italic,
              color: accentColor ?? colors.clay,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }

  static TextStyle _styleFor(QuizHeadingVariant variant) {
    switch (variant) {
      case QuizHeadingVariant.h1:
        return QuizTypography.displayH1;
      case QuizHeadingVariant.question:
        return QuizTypography.questionText;
      case QuizHeadingVariant.section:
        return QuizTypography.sectionH2;
      case QuizHeadingVariant.scoreBig:
        return QuizTypography.scoreBig;
    }
  }
}
