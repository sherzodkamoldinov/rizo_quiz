import 'package:flutter/material.dart';

import '../../../domain/entities/quiz_category.dart';
import '../../../theme/quiz_radii.dart';
import '../molecules/quiz_category_card.dart';

/// 2-колоночная сетка карточек категорий.
class QuizCategoriesGrid extends StatelessWidget {
  const QuizCategoriesGrid({
    required this.categories,
    required this.onTap,
    super.key,
  });

  final List<QuizCategory> categories;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: QuizRadii.gridGap,
        crossAxisSpacing: QuizRadii.gridGap,
        childAspectRatio: 0.96,
      ),
      itemBuilder: (_, i) {
        final c = categories[i];
        return QuizCategoryCard(
          title: c.name,
          subtitle: c.subtitle,
          glyph: c.glyph,
          onTap: () => onTap(c.id),
        );
      },
    );
  }
}
