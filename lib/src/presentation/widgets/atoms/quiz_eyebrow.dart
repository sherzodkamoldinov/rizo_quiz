import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';

/// Mono uppercase подпись («Eyebrow») — над крупными заголовками.
class QuizEyebrow extends StatelessWidget {
  const QuizEyebrow(this.text, {this.small = false, this.color, super.key});

  final String text;
  final bool small;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Text(
      text.toUpperCase(),
      style: (small ? QuizTypography.eyebrowSmall : QuizTypography.eyebrow).copyWith(
        color: color ?? colors.mute,
      ),
    );
  }
}
