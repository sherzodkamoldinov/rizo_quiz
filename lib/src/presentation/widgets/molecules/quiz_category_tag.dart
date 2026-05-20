import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';

/// Светло-бирюзовый чип над вопросом: «Наука · выбор ответа».
class QuizCategoryTag extends StatelessWidget {
  const QuizCategoryTag({required this.categoryName, required this.typeLabel, super.key});

  final String categoryName;
  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.claySoft,
        borderRadius: QuizRadii.brPill,
      ),
      child: Text(
        '$categoryName · $typeLabel'.toUpperCase(),
        style: QuizTypography.eyebrowSmall.copyWith(color: colors.clay2),
      ),
    );
  }
}
