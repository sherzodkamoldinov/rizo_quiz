import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';

/// Закруглённый прямоугольник-плейсхолдер для shimmer-скелетонов.
/// Сам по себе не анимируется — оборачивается родительским `QuizShimmer`.
class QuizSkeletonBox extends StatelessWidget {
  const QuizSkeletonBox({
    this.width = double.infinity,
    this.height = 16,
    this.radius = 8,
    super.key,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}
