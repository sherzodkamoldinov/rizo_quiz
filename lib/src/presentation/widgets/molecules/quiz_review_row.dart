import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_dot_indicator.dart';

/// Строка списка разбора на результате: «01 · вопрос ... · ●».
class QuizReviewRow extends StatelessWidget {
  const QuizReviewRow({
    required this.index,
    required this.questionText,
    required this.isCorrect,
    super.key,
  });

  final int index;
  final String questionText;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              index.toString().padLeft(2, '0'),
              style: QuizTypography.monoMeta.copyWith(color: colors.mute),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              questionText,
              style: QuizTypography.bodySmall.copyWith(color: colors.ink),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          QuizDotIndicator(isCorrect: isCorrect),
        ],
      ),
    );
  }
}
