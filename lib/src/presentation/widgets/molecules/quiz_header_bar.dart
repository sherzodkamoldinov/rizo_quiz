import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_avatar_circle.dart';

/// Верхний хедер главного экрана: приветствие + аватар слева, опциональный слот справа.
class QuizHeaderBar extends StatelessWidget {
  const QuizHeaderBar({
    required this.greeting,
    required this.name,
    this.trailing,
    super.key,
  });

  final String greeting;
  final String name;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Row(
      children: [
        QuizAvatarCircle(initial: name.isEmpty ? '?' : name),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                greeting,
                style: QuizTypography.bodySmall.copyWith(color: colors.mute),
              ),
              Text(
                name,
                style: QuizTypography.bodyMedium.copyWith(color: colors.ink),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
