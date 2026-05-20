import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_pill.dart';
import '../effects/pulse_animation.dart';

/// Таймер-пилюля справа в `QuizTopBar`. Цвет и пульс зависят от secondsLeft.
class QuizTimerPill extends StatelessWidget {
  const QuizTimerPill({required this.secondsLeft, super.key});

  final int secondsLeft;

  bool get _isDanger => secondsLeft <= 3;
  bool get _isWarn => secondsLeft > 3 && secondsLeft <= 6;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final (bg, border, fg) = _palette(colors);
    return PulseAnimation(
      enabled: _isDanger,
      child: QuizPill(
        backgroundColor: bg,
        borderColor: border,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text(
          '$secondsLeft с',
          style: QuizTypography.monoTimer.copyWith(color: fg),
        ),
      ),
    );
  }

  (Color, Color, Color) _palette(QuizColors c) {
    if (_isDanger) return (c.noSoft, c.noBorder, c.no);
    if (_isWarn) return (c.warn, c.warnBorder, c.warnText);
    return (c.cardWarm, c.line, c.ink);
  }
}
