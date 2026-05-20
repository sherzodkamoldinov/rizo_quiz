import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_glyph_serif.dart';

/// Карточка одной категории на главном экране.
class QuizCategoryCard extends StatelessWidget {
  const QuizCategoryCard({
    required this.title,
    required this.subtitle,
    required this.glyph,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final String glyph;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Material(
      color: colors.cardWarm,
      borderRadius: QuizRadii.brLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          decoration: BoxDecoration(
            borderRadius: QuizRadii.brLg,
            border: Border.all(color: colors.line),
          ),
          constraints: const BoxConstraints(minHeight: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuizGlyphSerif(glyph),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: QuizTypography.cardTitle.copyWith(color: colors.ink),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: QuizTypography.cardSubtitle.copyWith(color: colors.mute),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
