import 'package:flutter/material.dart';

import '../atoms/quiz_cta_ghost.dart';
import '../atoms/quiz_cta_primary.dart';

/// Вертикальный стек из 3 CTA на экране результата.
class QuizResultsCtaStack extends StatelessWidget {
  const QuizResultsCtaStack({
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.onPrimary,
    required this.onSecondary,
    required this.onTertiary,
    super.key,
  });

  final String primaryLabel;
  final String secondaryLabel;
  final String tertiaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final VoidCallback onTertiary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuizCtaPrimary(label: primaryLabel, onTap: onPrimary),
        const SizedBox(height: 10),
        QuizCtaGhost(label: secondaryLabel, onTap: onSecondary),
        const SizedBox(height: 10),
        QuizCtaGhost(label: tertiaryLabel, onTap: onTertiary),
      ],
    );
  }
}
