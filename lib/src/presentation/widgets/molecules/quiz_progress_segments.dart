import 'package:flutter/material.dart';

import '../atoms/quiz_progress_segment.dart';

/// Прогрессбар раунда из 10 сегментов с gap 4px.
class QuizProgressSegments extends StatelessWidget {
  const QuizProgressSegments({
    required this.total,
    required this.currentIndex,
    required this.results,
    super.key,
  });

  final int total;
  final int currentIndex;

  /// Длина = currentIndex, true = верный, false = неверный/таймаут.
  final List<bool> results;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final state = _stateFor(i);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
            child: QuizProgressSegment(state: state),
          ),
        );
      }),
    );
  }

  QuizSegmentState _stateFor(int i) {
    if (i < results.length) {
      return results[i] ? QuizSegmentState.correct : QuizSegmentState.wrong;
    }
    if (i == currentIndex) return QuizSegmentState.current;
    return QuizSegmentState.empty;
  }
}
