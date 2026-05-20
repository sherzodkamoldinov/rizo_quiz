import 'package:flutter/material.dart';

import '../../../theme/quiz_radii.dart';
import '../atoms/quiz_skeleton_box.dart';
import '../effects/quiz_shimmer.dart';

/// Плейсхолдер 2-колоночной сетки категорий пока грузим из Supabase.
class QuizCategoriesGridSkeleton extends StatelessWidget {
  const QuizCategoriesGridSkeleton({this.itemCount = 6, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return QuizShimmer(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: QuizRadii.gridGap,
          crossAxisSpacing: QuizRadii.gridGap,
          childAspectRatio: 0.96,
        ),
        itemBuilder: (_, _) => const QuizSkeletonBox(height: 140, radius: 20),
      ),
    );
  }
}
