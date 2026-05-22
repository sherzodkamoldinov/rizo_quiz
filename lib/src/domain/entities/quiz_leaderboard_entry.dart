import 'package:equatable/equatable.dart';

/// Aggregated weekly result for one player.
///
/// Sum of all per-category bests in the current period. One entry per user.
class QuizLeaderboardEntry extends Equatable {
  const QuizLeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.totalScore,
    required this.categoriesPlayed,
    this.avatarUrl,
  });

  final String userId;
  final String userName;
  final int totalScore;

  /// How many categories the player has at least one score in this week.
  final int categoriesPlayed;

  /// Profile photo URL denormalized from the latest player_scores row.
  /// Null/empty → letter fallback.
  final String? avatarUrl;

  @override
  List<Object?> get props =>
      [userId, userName, totalScore, categoriesPlayed, avatarUrl];
}
