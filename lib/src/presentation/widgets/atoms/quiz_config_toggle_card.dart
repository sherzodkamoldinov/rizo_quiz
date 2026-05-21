import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';

/// Tappable карточка-переключатель в диалоге конфигурации квиза.
///
/// ON  — фон [QuizColors.clay], белая иконка [iconOn].
/// OFF — фон [QuizColors.bg2], приглушённая иконка [iconOff].
class QuizConfigToggleCard extends StatelessWidget {
  const QuizConfigToggleCard({
    required this.label,
    required this.iconOn,
    required this.iconOff,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData iconOn;
  final IconData iconOff;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final bg = enabled ? colors.clay : colors.bg2;
    final fg = enabled ? Colors.white : colors.mute;
    final labelColor = enabled ? Colors.white : colors.ink2;
    final border = enabled ? colors.clay2 : colors.line;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: QuizRadii.brLg,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: QuizRadii.brLg,
            border: Border.all(color: border, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(enabled ? iconOn : iconOff, color: fg, size: 28),
              const SizedBox(height: 10),
              Text(
                label,
                style: QuizTypography.bodyMedium.copyWith(color: labelColor),
              ),
              const SizedBox(height: 2),
              Text(
                enabled ? 'ON' : 'OFF',
                style: QuizTypography.bodySmall.copyWith(
                  color: enabled ? Colors.white.withValues(alpha: 0.8) : colors.mute,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
