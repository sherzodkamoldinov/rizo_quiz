import 'package:flutter/material.dart';

import '../../../domain/entities/quiz_leaderboard_entry.dart';
import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../molecules/quiz_leaderboard_row.dart';

/// Список оставшихся участников (rank 4+).
class QuizLeaderboardList extends StatelessWidget {
  const QuizLeaderboardList({
    required this.entries,
    required this.startRank,
    required this.currentUserId,
    required this.youBadgeText,
    required this.metaBuilder,
    required this.onTapEntry,
    super.key,
  });

  final List<QuizLeaderboardEntry> entries;
  final int startRank;
  final String currentUserId;
  final String youBadgeText;

  /// Билдер мета-подписи под именем («1 ta kategoriya», «2 категории», …).
  final String Function(int categoriesPlayed) metaBuilder;

  final ValueChanged<QuizLeaderboardEntry> onTapEntry;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final colors = QuizColorsScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: QuizRadii.brLg,
        border: Border.all(color: colors.line),
      ),
      child: ClipRRect(
        borderRadius: QuizRadii.brLg,
        child: Column(
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              InkWell(
                onTap: () => onTapEntry(entries[i]),
                child: QuizLeaderboardRow(
                  rank: startRank + i,
                  name: entries[i].userName,
                  metaLabel: _meta(entries[i]),
                  score: entries[i].totalScore,
                  isCurrentUser: entries[i].userId == currentUserId,
                  youBadgeText: youBadgeText,
                ),
              ),
              if (i < entries.length - 1)
                Divider(height: 1, thickness: 1, color: colors.line),
            ],
          ],
        ),
      ),
    );
  }

  String _meta(QuizLeaderboardEntry e) => metaBuilder(e.categoriesPlayed);
}
