import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';

/// Круглая 40×40 кнопка с иконкой — back, close и т.п.
class QuizCircleIconButton extends StatelessWidget {
  const QuizCircleIconButton({
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.background,
    this.foreground,
    super.key,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Material(
      color: background ?? colors.cardWarm,
      shape: CircleBorder(side: BorderSide(color: colors.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: foreground ?? colors.ink, size: size * 0.45),
        ),
      ),
    );
  }
}
