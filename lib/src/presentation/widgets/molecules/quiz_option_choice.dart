import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_check_mark.dart';
import '../atoms/quiz_cross_mark.dart';
import '../atoms/quiz_option_label.dart';

enum QuizOptionVisual { idle, correct, wrong, faded }

/// Один вариант ответа в multiple-choice. Слева — лейбл A/B/C/D, справа — маркер.
class QuizOptionChoice extends StatelessWidget {
  const QuizOptionChoice({
    required this.letter,
    required this.text,
    required this.visual,
    required this.onTap,
    super.key,
  });

  final String letter;
  final String text;
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
        borderRadius: QuizRadii.brMd,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: QuizRadii.brMd,
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                QuizOptionLabel(letter),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: QuizTypography.optionLabel.copyWith(color: colors.ink),
                  ),
                ),
                const SizedBox(width: 12),
                _trailing(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trailing() {
    switch (visual) {
      case QuizOptionVisual.correct:
        return const QuizCheckMark();
      case QuizOptionVisual.wrong:
        return const QuizCrossMark();
      case QuizOptionVisual.idle:
      case QuizOptionVisual.faded:
        return const SizedBox(width: 24, height: 24);
    }
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
