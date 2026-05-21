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
    this.onAvatarTap,
    super.key,
  });

  final String greeting;
  final String name;
  final Widget? trailing;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final avatar = QuizAvatarCircle(initial: name.isEmpty ? '?' : name);
    return Row(
      children: [
        if (onAvatarTap != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAvatarTap,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  avatar,
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: _QuizAvatarConfigBadge(
                      bg: colors.ink,
                      ring: colors.bg,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          avatar,
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

/// Маленький бейдж с шестерёнкой — подсказка, что аватар тапабельный.
class _QuizAvatarConfigBadge extends StatelessWidget {
  const _QuizAvatarConfigBadge({required this.bg, required this.ring});

  final Color bg;
  final Color ring;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: ring, width: 2),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.settings_rounded,
        size: 10,
        color: Colors.white,
      ),
    );
  }
}
