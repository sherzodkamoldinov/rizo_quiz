import 'package:flutter/material.dart';

import '../../../domain/entities/quiz_leaderboard_entry.dart';
import '../molecules/quiz_podium_column.dart';

/// Подиум из топ-3: рендер в порядке 2 — 1 — 3 (центральная колонка выше).
class QuizPodium extends StatelessWidget {
  const QuizPodium({
    required this.entries,
    this.currentUserId,
    this.youBadgeText,
    this.onTapEntry,
    super.key,
  });

  /// Должен содержать до 3 первых строк лидерборда.
  final List<QuizLeaderboardEntry> entries;

  /// userId текущего игрока. Если совпадает с entry.userId — на колонке
  /// показывается бейдж [youBadgeText].
  final String? currentUserId;
  final String? youBadgeText;

  /// Открывает разбивку по категориям при тапе на колонку.
  final ValueChanged<QuizLeaderboardEntry>? onTapEntry;

  @override
  Widget build(BuildContext context) {
    final first = entries.isNotEmpty ? entries[0] : null;
    final second = entries.length > 1 ? entries[1] : null;
    final third = entries.length > 2 ? entries[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _column(rank: 2, entry: second)),
        Expanded(child: _column(rank: 1, entry: first)),
        Expanded(child: _column(rank: 3, entry: third)),
      ],
    );
  }

  Widget _column({required int rank, required QuizLeaderboardEntry? entry}) {
    if (entry == null) return const SizedBox.shrink();
    final isMe = currentUserId != null && entry.userId == currentUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: QuizPodiumColumn(
        rank: rank,
        name: entry.userName,
        score: entry.totalScore,
        isCurrentUser: isMe,
        youBadgeText: youBadgeText,
        onTap: onTapEntry == null ? null : () => onTapEntry!(entry),
      ),
    );
  }
}
