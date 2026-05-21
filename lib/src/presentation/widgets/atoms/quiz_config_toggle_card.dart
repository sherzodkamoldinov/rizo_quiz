import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';

/// Tappable карточка-переключатель — иконка центрирована, без подписей.
///
/// ON  — фон [QuizColors.clay], белая иконка [iconOn].
/// OFF — фон [QuizColors.bg2], приглушённая иконка [iconOff].
class QuizConfigToggleCard extends StatelessWidget {
  const QuizConfigToggleCard({
    required this.iconOn,
    required this.iconOff,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final IconData iconOn;
  final IconData iconOff;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final bg = enabled ? colors.clay : colors.bg2;
    final fg = enabled ? Colors.white : colors.mute;
    final border = enabled ? colors.clay2 : colors.line;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: QuizRadii.brLg,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 96,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: QuizRadii.brLg,
            border: Border.all(color: border, width: 1),
          ),
          alignment: Alignment.center,
          child: Icon(enabled ? iconOn : iconOff, color: fg, size: 36),
        ),
      ),
    );
  }
}
