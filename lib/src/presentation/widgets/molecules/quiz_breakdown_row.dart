import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_glyph_serif.dart';

/// Одна строка разбивки в bottom sheet: глиф + название + best очков.
class QuizBreakdownRow extends StatelessWidget {
  const QuizBreakdownRow({
    required this.glyph,
    required this.categoryName,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.attemptSecLabel,
    super.key,
  });

  final String glyph;
  final String categoryName;
  final int score;
  final int correctCount;
  final int totalQuestions;

  /// Готовая строка для подписи попыток, например "5/10 · 6.2 сек".
  final String attemptSecLabel;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 36, child: Center(child: QuizGlyphSerif(glyph, size: 28))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  categoryName,
                  style: QuizTypography.bodyMedium.copyWith(color: colors.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  attemptSecLabel,
                  style: QuizTypography.monoMeta.copyWith(color: colors.mute),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$score',
            style: QuizTypography.leaderScore.copyWith(color: colors.ink),
          ),
        ],
      ),
    );
  }
}
