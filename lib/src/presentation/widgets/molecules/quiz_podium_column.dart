import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_avatar_circle.dart';
import '../atoms/quiz_pill.dart';

/// Одна из трёх колонок подиума: rank 1 (центр), 2 (лево), 3 (право).
class QuizPodiumColumn extends StatelessWidget {
  const QuizPodiumColumn({
    required this.rank,
    required this.name,
    required this.score,
    this.isCurrentUser = false,
    this.youBadgeText,
    this.onTap,
    super.key,
  });

  final int rank;
  final String name;
  final int score;
  final bool isCurrentUser;
  final String? youBadgeText;
  final VoidCallback? onTap;

  double get _barHeight => switch (rank) { 1 => 120, 2 => 90, _ => 70 };

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final (barBg, barBorder, contentColor) = _palette(colors);
    final isFirst = rank == 1;

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuizAvatarCircle(
          initial: name,
          size: 56,
          background: isFirst ? colors.clay : colors.bg2,
          foreground: isFirst ? Colors.white : colors.ink,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: QuizTypography.bodyMedium.copyWith(color: colors.ink),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (isCurrentUser && youBadgeText != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.clay,
              borderRadius: QuizRadii.brPill,
            ),
            child: Text(
              youBadgeText!,
              style: QuizTypography.eyebrowSmall.copyWith(color: Colors.white),
            ),
          ),
        ],
        const SizedBox(height: 6),
        QuizPill(
          backgroundColor: colors.card,
          borderColor: colors.line,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            '$score',
            style: QuizTypography.monoMeta.copyWith(color: colors.ink),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: _barHeight,
          decoration: BoxDecoration(
            color: barBg,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            border: Border(
              top: BorderSide(color: barBorder),
              left: BorderSide(color: barBorder),
              right: BorderSide(color: barBorder),
            ),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 8),
          child: isFirst
              ? const Text(
                  '★',
                  style: TextStyle(
                    fontFamily: QuizTypography.serif,
                    package: 'rizo_quiz',
                    fontSize: 22,
                    color: Colors.white,
                    height: 1,
                  ),
                )
              : Text(
                  '$rank',
                  style: QuizTypography.monoLabel.copyWith(color: contentColor),
                ),
        ),
      ],
    );

    if (onTap == null) return column;
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: column,
    );
  }

  (Color, Color, Color) _palette(QuizColors c) {
    switch (rank) {
      case 1:
        return (c.clay, c.clay2, Colors.white);
      case 2:
        return (c.ink, c.ink, Colors.white);
      default:
        return (c.rank3Bg, c.rank3Border, c.ink);
    }
  }
}
