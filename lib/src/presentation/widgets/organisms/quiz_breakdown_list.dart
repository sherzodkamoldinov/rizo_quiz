import 'package:flutter/material.dart';

import '../../../domain/entities/quiz_category_best.dart';
import '../../../localization/quiz_strings.dart';
import '../../../theme/quiz_colors.dart';
import '../molecules/quiz_breakdown_row.dart';

/// Список категорий с личными bests внутри bottom sheet.
class QuizBreakdownList extends StatelessWidget {
  const QuizBreakdownList({
    required this.bests,
    required this.totalQuestions,
    required this.strings,
    super.key,
  });

  final List<QuizCategoryBest> bests;
  final int totalQuestions;
  final QuizStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Column(
      children: [
        for (var i = 0; i < bests.length; i++) ...[
          QuizBreakdownRow(
            glyph: bests[i].categoryGlyph,
            categoryName: bests[i].categoryName,
            score: bests[i].score,
            correctCount: bests[i].correctCount,
            totalQuestions: totalQuestions,
            attemptSecLabel: _meta(bests[i]),
          ),
          if (i < bests.length - 1)
            Divider(height: 1, thickness: 1, color: colors.line),
        ],
      ],
    );
  }

  String _meta(QuizCategoryBest b) {
    final sec = b.avgSeconds.toStringAsFixed(1);
    final unit = strings.get('stat_sec_unit');
    return '${b.correctCount}/$totalQuestions · $sec $unit';
  }
}
