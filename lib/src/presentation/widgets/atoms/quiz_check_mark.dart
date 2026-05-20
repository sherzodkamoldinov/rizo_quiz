import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';

/// Круг цвета `ok` с белой галочкой по центру — маркер правильного ответа.
class QuizCheckMark extends StatelessWidget {
  const QuizCheckMark({this.size = 24, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.ok, shape: BoxShape.circle),
      child: Icon(Icons.check_rounded, color: Colors.white, size: size * 0.62),
    );
  }
}
