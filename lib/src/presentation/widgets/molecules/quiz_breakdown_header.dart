import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_avatar_circle.dart';
import '../atoms/quiz_eyebrow.dart';

/// Шапка bottom sheet: аватар + имя игрока + общий total под чертой.
class QuizBreakdownHeader extends StatelessWidget {
  const QuizBreakdownHeader({
    required this.name,
    required this.totalScore,
    required this.totalLabel,
    this.avatarUrl,
    super.key,
  });

  final String name;
  final int totalScore;
  final String totalLabel;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QuizAvatarCircle(initial: name, avatarUrl: avatarUrl, size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              QuizEyebrow(totalLabel),
              const SizedBox(height: 4),
              Text(
                name,
                style: QuizTypography.cardTitle.copyWith(color: colors.ink),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$totalScore',
          style: QuizTypography.sectionH2.copyWith(color: colors.clay),
        ),
      ],
    );
  }
}
