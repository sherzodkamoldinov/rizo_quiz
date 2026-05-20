import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';

/// Круглый аватар с одной заглавной буквой по центру.
class QuizAvatarCircle extends StatelessWidget {
  const QuizAvatarCircle({
    required this.initial,
    this.size = 36,
    this.background,
    this.foreground,
    super.key,
  });

  final String initial;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? colors.clay,
        shape: BoxShape.circle,
      ),
      child: Text(
        initial.isEmpty ? '?' : initial.substring(0, 1).toUpperCase(),
        style: TextStyle(
          fontFamily: QuizTypography.sans,
          package: 'rizo_quiz',
          fontSize: size * 0.42,
          fontWeight: FontWeight.w600,
          color: foreground ?? Colors.white,
          height: 1,
        ),
      ),
    );
  }
}
