import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/quiz_category_best_model.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_leaderboard_entry_model.dart';
import '../models/quiz_question_model.dart';

class SupabaseQuizDataSource {
  SupabaseQuizDataSource({
    required this.client,
    this.tablePrefix = 'quiz_',
  });

  final SupabaseClient client;
  final String tablePrefix;

  String get _tCategories => '${tablePrefix}categories';
  String get _tQuestions => '${tablePrefix}questions';
  String get _tPlayerScores => '${tablePrefix}player_scores';

  // ─── Categories ────────────────────────────────────────────────────────────
  Future<List<QuizCategoryModel>> getCategories() async {
    final raw = await client
        .from(_tCategories)
        .select()
        .eq('is_active', true)
        .order('sort_order');
    return _cast(raw).map(QuizCategoryModel.fromJson).toList();
  }

  // ─── Questions ─────────────────────────────────────────────────────────────
  Future<List<QuizQuestionModel>> getQuestions({
    required String categoryId,
    int limit = 10,
  }) async {
    final raw = await client
        .from(_tQuestions)
        .select()
        .eq('is_active', true)
        .eq('category_id', categoryId);
    final all = _cast(raw).map(QuizQuestionModel.fromJson).toList()..shuffle();
    return all.take(limit).toList();
  }

  // ─── Player scores: upsert ─────────────────────────────────────────────────
  /// Insert or replace (only if higher) via Supabase upsert. The unique
  /// constraint `quiz_player_scores_unique (user_id, category_id, period_key)`
  /// ensures we keep one row per slot. PostgREST's upsert maps to
  /// `INSERT … ON CONFLICT … DO UPDATE`. We pre-filter on the client to skip
  /// the network round-trip when the new score is not higher.
  Future<void> upsertPlayerScore(Map<String, dynamic> body) async {
    final userId = body['user_id'] as String;
    final categoryId = body['category_id'] as String;
    final periodKey = body['period_key'] as String;
    final newScore = body['score'] as int;

    final existing = await client
        .from(_tPlayerScores)
        .select('score')
        .eq('user_id', userId)
        .eq('category_id', categoryId)
        .eq('period_key', periodKey)
        .maybeSingle();

    if (existing != null) {
      final currentScore = (existing['score'] as num?)?.toInt() ?? 0;
      if (newScore <= currentScore) return;
    }

    await client
        .from(_tPlayerScores)
        .upsert(body, onConflict: 'user_id,category_id,period_key');
  }

  // ─── Leaderboard (weekly aggregated) ───────────────────────────────────────
  /// PostgREST has no SUM aggregation in select strings, so we fetch raw rows
  /// for the period and aggregate on the client. The volume is small
  /// (≤ ~1k rows per week) — fine for MVP.
  Future<List<QuizLeaderboardEntryModel>> getWeeklyLeaderboard({
    required String periodKey,
    int limit = 100,
  }) async {
    final raw = await client
        .from(_tPlayerScores)
        .select('user_id, user_name, score, category_id')
        .eq('period_key', periodKey);
    final rows = _cast(raw);

    final byUser = <String, _Aggregate>{};
    for (final row in rows) {
      final userId = row['user_id'] as String? ?? '';
      if (userId.isEmpty) continue;
      final agg = byUser.putIfAbsent(
        userId,
        () => _Aggregate(userId: userId, userName: row['user_name'] as String? ?? ''),
      );
      agg.totalScore += (row['score'] as num?)?.toInt() ?? 0;
      agg.categoryIds.add(row['category_id'] as String? ?? '');
      // newest user_name wins (in case a user changed display name mid-week)
      final name = row['user_name'] as String? ?? '';
      if (name.isNotEmpty) agg.userName = name;
    }

    final sorted = byUser.values.toList()
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

    return sorted.take(limit).map((a) {
      return QuizLeaderboardEntryModel(
        userId: a.userId,
        userName: a.userName,
        totalScore: a.totalScore,
        categoriesPlayed: a.categoryIds.where((id) => id.isNotEmpty).length,
      );
    }).toList();
  }

  // ─── Player breakdown (bottom sheet) ───────────────────────────────────────
  Future<List<QuizCategoryBestModel>> getPlayerCategoryBests({
    required String userId,
    required String periodKey,
  }) async {
    final raw = await client
        .from(_tPlayerScores)
        .select(
          'category_id, score, correct_count, avg_seconds, '
          'category:$_tCategories(name_ru, name_uz, name_en, glyph)',
        )
        .eq('user_id', userId)
        .eq('period_key', periodKey)
        .order('score', ascending: false);
    return _cast(raw).map(QuizCategoryBestModel.fromJson).toList();
  }

  List<Map<String, dynamic>> _cast(dynamic raw) =>
      (raw as List).cast<Map<String, dynamic>>();
}

class _Aggregate {
  _Aggregate({required this.userId, required this.userName});

  final String userId;
  String userName;
  int totalScore = 0;
  final Set<String> categoryIds = <String>{};
}
