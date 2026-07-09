import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_circle_icon_button.dart';

/// Верхний кластер действий: пилюля «Награды» (🏆) + опциональная кнопка X.
/// Один виджет для обоих табов (категории и лидерборд), чтобы не дублировать.
class QuizTopActions extends StatelessWidget {
  const QuizTopActions({
    required this.awardsLabel,
    required this.onAwards,
    this.onClose,
    super.key,
  });

  final String awardsLabel;
  final VoidCallback onAwards;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AwardsPill(label: awardsLabel, onTap: onAwards),
        if (onClose != null) ...[
          const SizedBox(width: 8),
          QuizCircleIconButton(icon: Icons.close_rounded, onTap: onClose!),
        ],
      ],
    );
  }
}

class _AwardsPill extends StatelessWidget {
  const _AwardsPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Material(
      color: colors.cardWarm,
      shape: RoundedRectangleBorder(
        borderRadius: QuizRadii.brPill,
        side: BorderSide(color: colors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events_rounded, size: 18, color: colors.clay),
              const SizedBox(width: 6),
              Text(
                label,
                style: QuizTypography.bodyMedium.copyWith(color: colors.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
