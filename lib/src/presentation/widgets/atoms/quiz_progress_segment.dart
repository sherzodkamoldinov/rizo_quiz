import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';

enum QuizSegmentState { empty, current, correct, wrong }

/// Один из 10 сегментов прогрессбара раунда — высота 3px, цвет по статусу.
class QuizProgressSegment extends StatelessWidget {
  const QuizProgressSegment({required this.state, super.key});

  final QuizSegmentState state;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final color = switch (state) {
      QuizSegmentState.empty => colors.line,
      QuizSegmentState.current => colors.ink,
      QuizSegmentState.correct => colors.ok,
      QuizSegmentState.wrong => colors.no,
    };
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}
