import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../../../theme/quiz_typography.dart';
import '../atoms/quiz_avatar_circle.dart';

/// Строка в rest-list лидерборда (rank 4+). С опциональным бейджем «ВЫ».
class QuizLeaderboardRow extends StatelessWidget {
  const QuizLeaderboardRow({
    required this.rank,
    required this.name,
    required this.metaLabel,
    required this.score,
    this.isCurrentUser = false,
    this.youBadgeText,
    super.key,
  });

  final int rank;
  final String name;
  final String metaLabel;
  final int score;
  final bool isCurrentUser;
  final String? youBadgeText;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final bg = isCurrentUser ? colors.claySoft : colors.card;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      color: bg,
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$rank',
              style: QuizTypography.monoMeta.copyWith(color: colors.mute),
            ),
          ),
          const SizedBox(width: 6),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: SizedBox(
              width: 32,
              height: 32,
              child: QuizAvatarCircle(
                initial: name,
                size: 32,
                background: isCurrentUser ? colors.clay : colors.bg2,
                foreground: isCurrentUser ? Colors.white : colors.ink,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: QuizTypography.bodyMedium.copyWith(color: colors.ink),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser && youBadgeText != null) ...[
                      const SizedBox(width: 8),
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
                  ],
                ),
                Text(
                  metaLabel,
                  style: QuizTypography.monoMeta.copyWith(color: colors.mute),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$score',
            style: QuizTypography.leaderScore.copyWith(color: colors.ink),
          ),
        ],
      ),
    );
  }
}
