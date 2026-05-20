import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';

/// Большая navy-карточка очков на экране результата.
class QuizScoreCard extends StatelessWidget {
  const QuizScoreCard({required this.label, required this.score, super.key});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: BoxDecoration(
        color: colors.ink,
        borderRadius: QuizRadii.brXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: QuizTypography.eyebrow.copyWith(
              color: colors.mute2,
              letterSpacing: 1.98,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: QuizTypography.scoreBig.copyWith(color: colors.clay),
          ),
        ],
      ),
    );
  }
}
