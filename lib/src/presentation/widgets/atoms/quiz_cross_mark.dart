import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';

/// Круг цвета `no` с белым крестиком — маркер неверного ответа.
class QuizCrossMark extends StatelessWidget {
  const QuizCrossMark({this.size = 24, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.no, shape: BoxShape.circle),
      child: Icon(Icons.close_rounded, color: Colors.white, size: size * 0.62),
    );
  }
}
