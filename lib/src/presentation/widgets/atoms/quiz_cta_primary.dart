import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';

/// Главная CTA-кнопка раунда (бирюзовый фон, radius 999, sans 500).
class QuizCtaPrimary extends StatelessWidget {
  const QuizCtaPrimary({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Material(
      color: colors.clay,
      borderRadius: QuizRadii.brPill,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: colors.clay2.withValues(alpha: 0.2),
        highlightColor: colors.clay2.withValues(alpha: 0.1),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            label,
            style: QuizTypography.optionLabel.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
