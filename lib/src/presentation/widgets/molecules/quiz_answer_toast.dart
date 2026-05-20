import 'package:flutter/material.dart';

import '../../../localization/quiz_strings.dart';
import 'quiz_feedback_toast.dart';

/// Выбирает текст и стиль тоста по состоянию ответа.
class QuizAnswerToast extends StatelessWidget {
  const QuizAnswerToast({
    required this.isTimeout,
    required this.scoreDelta,
    required this.correctCount,
    required this.strings,
    super.key,
  });

  final bool isTimeout;
  final int scoreDelta;
  final int correctCount;
  final QuizStrings strings;

  @override
  Widget build(BuildContext context) {
    final isCorrect = scoreDelta > 0;
    if (isCorrect) {
      final variants = [
        strings.get('toast_ok_1'),
        strings.get('toast_ok_2'),
        strings.get('toast_ok_3'),
        strings.get('toast_ok_4'),
      ];
      return QuizFeedbackToast(
        message: variants[correctCount % variants.length],
        isOk: true,
        scoreDelta: scoreDelta,
      );
    }
    return QuizFeedbackToast(
      message: isTimeout ? strings.get('toast_bad_timeout') : strings.get('toast_bad_wrong'),
      isOk: false,
    );
  }
}
