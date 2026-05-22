import '../entities/quiz_category.dart';
import '../entities/quiz_category_best.dart';
import '../entities/quiz_leaderboard_entry.dart';
import '../entities/quiz_question.dart';

/// Abstract data contract. Implemented by `SupabaseQuizRepository`.
/// Host can also provide a custom impl (e.g. for tests or alternative backend).
abstract class QuizRepository {
  /// Active categories ordered by `sort_order`.
  Future<List<QuizCategory>> getCategories({required String lang});

  /// Random subset (up to [limit]) of active questions in [categoryId].
  Future<List<QuizQuestion>> getQuestions({
    required String categoryId,
    required String lang,
    int limit = 10,
  });

  /// Upserts the player's best score for `(userId, categoryId, periodKey)`.
  /// Only writes if the new [score] is higher than the stored one.
  Future<void> submitScore({
    required String userId,
    required String userName,
    required String categoryId,
    required String periodKey,
    required int score,
    required int correctCount,
    required double avgSeconds,
    String? avatarUrl,
  });

  /// Aggregated weekly leaderboard. `total_score = SUM(score) GROUP BY user_id`
  /// for rows with `period_key = periodKey`.
  Future<List<QuizLeaderboardEntry>> getWeeklyLeaderboard({
    required String periodKey,
    int limit = 100,
  });

  /// Per-category bests of [userId] in [periodKey]. Used by the tap-to-detail
  /// bottom sheet on the leaderboard.
  Future<List<QuizCategoryBest>> getPlayerCategoryBests({
    required String userId,
    required String periodKey,
    required String lang,
  });
}
