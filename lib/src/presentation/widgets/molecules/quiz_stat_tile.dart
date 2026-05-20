import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';

/// Карточка статистики на экране результата: лейбл сверху, значение снизу.
class QuizStatTile extends StatelessWidget {
  const QuizStatTile({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: colors.cardWarm,
        borderRadius: QuizRadii.brLg,
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: QuizTypography.eyebrowSmall.copyWith(color: colors.mute),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: QuizTypography.sectionH2.copyWith(color: colors.ink),
          ),
        ],
      ),
    );
  }
}
