import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_circle_icon_button.dart';
import 'quiz_timer_pill.dart';

/// Верхняя панель экрана вопроса: back-кнопка | счётчик вопросов | таймер.
class QuizTopBar extends StatelessWidget {
  const QuizTopBar({
    required this.label,
    required this.secondsLeft,
    required this.onBack,
    super.key,
  });

  final String label;
  final int secondsLeft;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Row(
      children: [
        QuizCircleIconButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        Expanded(
          child: Center(
            child: Text(
              label,
              style: QuizTypography.monoLabel.copyWith(color: colors.ink2),
            ),
          ),
        ),
        QuizTimerPill(secondsLeft: secondsLeft),
      ],
    );
  }
}
