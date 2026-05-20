import '../../domain/entities/quiz_leaderboard_entry.dart';

/// Result of `SELECT user_id, user_name, sum(score), count(distinct category_id)`.
class QuizLeaderboardEntryModel {
  const QuizLeaderboardEntryModel({
    required this.userId,
    required this.userName,
    required this.totalScore,
    required this.categoriesPlayed,
  });

  factory QuizLeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return QuizLeaderboardEntryModel(
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      categoriesPlayed: (json['categories_played'] as num?)?.toInt() ?? 0,
    );
  }

  final String userId;
  final String userName;
  final int totalScore;
  final int categoriesPlayed;

  QuizLeaderboardEntry toEntity() {
    return QuizLeaderboardEntry(
      userId: userId,
      userName: userName,
      totalScore: totalScore,
      categoriesPlayed: categoriesPlayed,
    );
  }
}
