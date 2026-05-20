import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';

/// Квадратный 28×28 лейбл A/B/C/D слева от опции в multiple-choice.
class QuizOptionLabel extends StatelessWidget {
  const QuizOptionLabel(this.letter, {this.color, this.background, super.key});

  final String letter;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? colors.bg2,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        letter,
        style: QuizTypography.monoLabel.copyWith(
          color: color ?? colors.ink2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
