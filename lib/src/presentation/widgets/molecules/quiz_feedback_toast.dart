import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_pill.dart';
import '../effects/rise_animation.dart';

/// Всплывающий тост после ответа: ok/bad + опциональная пилюля «+N».
class QuizFeedbackToast extends StatelessWidget {
  const QuizFeedbackToast({
    required this.message,
    required this.isOk,
    this.scoreDelta,
    super.key,
  });

  final String message;
  final bool isOk;
  final int? scoreDelta;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final bg = isOk ? colors.ok : colors.no;
    return RiseAnimation(
      child: Material(
        color: bg,
        borderRadius: QuizRadii.brLg,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: QuizTypography.optionLabel.copyWith(color: Colors.white),
                ),
              ),
              if (scoreDelta != null && scoreDelta! > 0) ...[
                const SizedBox(width: 12),
                QuizPill(
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  borderColor: Colors.white.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text(
                    '+$scoreDelta',
                    style: QuizTypography.monoLabel.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
