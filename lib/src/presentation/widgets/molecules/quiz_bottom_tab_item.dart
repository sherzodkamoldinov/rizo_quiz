import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';

/// Один таб в нижнем баре. Растягивается на доступную ширину родителя.
/// Active = ink-фон + bg текст; неактивный = тонкая рамка + mute текст.
class QuizBottomTabItem extends StatelessWidget {
  const QuizBottomTabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final fg = isActive ? colors.bg : colors.ink;
    return Material(
      color: isActive ? colors.ink : Colors.transparent,
      borderRadius: QuizRadii.brPill,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: QuizRadii.brPill,
            border: isActive ? null : Border.all(color: colors.line2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 8),
              Text(label, style: QuizTypography.bodyMedium.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}
