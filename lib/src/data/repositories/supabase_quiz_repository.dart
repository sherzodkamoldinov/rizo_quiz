import '../../domain/entities/quiz_category.dart';
import '../../domain/entities/quiz_category_best.dart';
import '../../domain/entities/quiz_leaderboard_entry.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../data_sources/supabase_quiz_data_source.dart';

class SupabaseQuizRepository implements QuizRepository {
  const SupabaseQuizRepository({required this.dataSource});

  final SupabaseQuizDataSource dataSource;

  @override
  Future<List<QuizCategory>> getCategories({required String lang}) async {
    final models = await dataSource.getCategories();
    return models.map((m) => m.toEntity(lang)).toList();
  }

  @override
  Future<List<QuizQuestion>> getQuestions({
    required String categoryId,
    required String lang,
    int limit = 10,
  }) async {
    final models = await dataSource.getQuestions(categoryId: categoryId, limit: limit);
    return models.map((m) => m.toEntity(lang)).toList();
  }

  @override
  Future<void> submitScore({
    required String userId,
    required String userName,
    required String categoryId,
    required String periodKey,
    required int score,
    required int correctCount,
    required double avgSeconds,
    String? avatarUrl,
  }) async {
    await dataSource.upsertPlayerScore({
      'user_id': userId,
      'user_name': userName,
      'user_avatar_url': avatarUrl,
      'category_id': categoryId,
      'period_key': periodKey,
      'score': score,
      'correct_count': correctCount,
      'avg_seconds': avgSeconds,
    });
  }

  @override
  Future<List<QuizLeaderboardEntry>> getWeeklyLeaderboard({
    required String periodKey,
    int limit = 100,
  }) async {
    final models = await dataSource.getWeeklyLeaderboard(
      periodKey: periodKey,
      limit: limit,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<QuizCategoryBest>> getPlayerCategoryBests({
    required String userId,
    required String periodKey,
    required String lang,
  }) async {
    final models = await dataSource.getPlayerCategoryBests(
      userId: userId,
      periodKey: periodKey,
    );
    return models.map((m) => m.toEntity(lang)).toList();
  }
}
