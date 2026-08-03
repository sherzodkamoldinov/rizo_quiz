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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: QuizRadii.brPill,
            border: Border.all(color: colors.line2),
          ),
          // Кнопки в узких Row (диалог выхода — две по половине ширины) не дают
          // длинной подписи влезть в одну строку. scaleDown ужимает шрифт только
          // когда места не хватает — там, где текст помещался, вид не меняется.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: QuizTypography.optionLabel.copyWith(color: colors.ink),
            ),
          ),
        ),
      ),
    );
  }
}
