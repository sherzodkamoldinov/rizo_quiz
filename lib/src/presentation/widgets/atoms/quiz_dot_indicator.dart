import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';

/// 8×8 точка-индикатор результата в списке разбора: ok/no.
class QuizDotIndicator extends StatelessWidget {
  const QuizDotIndicator({required this.isCorrect, this.size = 8, super.key});

  final bool isCorrect;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isCorrect ? colors.ok : colors.no,
        shape: BoxShape.circle,
      ),
    );
  }
}
