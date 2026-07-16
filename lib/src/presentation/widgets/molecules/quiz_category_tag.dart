import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';

/// Светло-бирюзовый чип над вопросом: «Наука · выбор ответа». Для сложных
/// вопросов рядом показываем янтарный бейдж [hardLabel] («СЛОЖНЫЙ»).
class QuizCategoryTag extends StatelessWidget {
  const QuizCategoryTag({
    required this.categoryName,
    required this.typeLabel,
    this.hardLabel,
    super.key,
  });

  final String categoryName;
  final String typeLabel;

  /// Локализованный текст бейджа сложности. `null` → бейдж скрыт (easy).
  final String? hardLabel;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.claySoft,
            borderRadius: QuizRadii.brPill,
          ),
          child: Text(
            '$categoryName · $typeLabel'.toUpperCase(),
            style: QuizTypography.eyebrowSmall.copyWith(color: colors.clay2),
          ),
        ),
        if (hardLabel != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.warn,
              borderRadius: QuizRadii.brPill,
              border: Border.all(color: colors.warnBorder),
            ),
            child: Text(
              hardLabel!.toUpperCase(),
              style: QuizTypography.eyebrowSmall.copyWith(color: colors.warnText),
            ),
          ),
      ],
    );
  }
}
