import 'package:flutter/material.dart';

import '../../../domain/entities/quiz_question.dart';
import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../molecules/quiz_review_row.dart';

/// Список разбора вопросов на результате.
class QuizReviewList extends StatelessWidget {
  const QuizReviewList({
    required this.title,
    required this.questions,
    required this.results,
    super.key,
  });

  final String title;
  final List<QuizQuestion> questions;

  /// Длина = длине [questions]; true = верно, false = неверно/таймаут.
  final List<bool> results;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: QuizRadii.brLg,
        border: Border.all(color: colors.line),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: QuizTypography.eyebrowSmall.copyWith(color: colors.mute),
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < questions.length; i++)
            QuizReviewRow(
              index: i + 1,
              questionText: questions[i].text,
              isCorrect: i < results.length ? results[i] : false,
            ),
        ],
      ),
    );
  }
}
