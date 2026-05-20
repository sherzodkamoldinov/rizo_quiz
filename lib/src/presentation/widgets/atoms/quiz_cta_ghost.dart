import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';

/// Призрачная (контурная) CTA. Используется для вторичных действий.
class QuizCtaGhost extends StatelessWidget {
  const QuizCtaGhost({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: QuizRadii.brPill,
      child: InkWell(
        onTap: onTap,
        borderRadius: QuizRadii.brPill,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: QuizRadii.brPill,
            border: Border.all(color: colors.line2),
          ),
          child: Text(
            label,
            style: QuizTypography.optionLabel.copyWith(color: colors.ink),
          ),
        ),
      ),
    );
  }
}
