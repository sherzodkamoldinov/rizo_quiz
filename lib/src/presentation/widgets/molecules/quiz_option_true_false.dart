import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import 'quiz_option_choice.dart';

/// Большая кнопка True/False — серифный символ + текст по дизайну.
class QuizOptionTrueFalse extends StatelessWidget {
  const QuizOptionTrueFalse({
    required this.label,
    required this.isTrueVariant,
    required this.visual,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isTrueVariant;
  final QuizOptionVisual visual;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final (bg, border) = _palette(colors);
    final opacity = visual == QuizOptionVisual.faded ? 0.45 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Material(
        color: bg,
        borderRadius: QuizRadii.brLg,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: QuizRadii.brLg,
              border: Border.all(color: border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isTrueVariant ? '✓' : '✕',
                  style: TextStyle(
                    fontFamily: QuizTypography.serif,
                    package: 'rizo_quiz',
                    fontSize: 44,
                    fontWeight: FontWeight.w400,
                    color: colors.clay,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: QuizTypography.optionLabel.copyWith(color: colors.ink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color) _palette(QuizColors c) {
    switch (visual) {
      case QuizOptionVisual.correct:
        return (c.okSoft, c.okBorder);
      case QuizOptionVisual.wrong:
        return (c.noSoft, c.noBorder);
      case QuizOptionVisual.idle:
      case QuizOptionVisual.faded:
        return (c.card, c.line);
    }
  }
}
