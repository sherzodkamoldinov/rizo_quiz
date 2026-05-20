import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';

/// Универсальная пилюля-капсула с тонкой границей и опциональной иконкой.
/// Используется для пилюли счёта, +N, чипа времени и т.п.
class QuizPill extends StatelessWidget {
  const QuizPill({
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.cardWarm,
        borderRadius: QuizRadii.brPill,
        border: Border.all(color: borderColor ?? colors.line),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
