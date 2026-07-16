import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/quiz_category_best_model.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_leaderboard_entry_model.dart';
import '../models/quiz_my_win_model.dart';
import '../models/quiz_prize_tier_model.dart';
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
  String get _tPrizeTiers => '${tablePrefix}prize_tiers';

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
  /// Набираем [limit] вопросов с фиксированным соотношением по сложности:
  /// [hardCount] hard + остальные easy (по умолчанию 3 hard + 7 easy). Каждую
  /// корзину перемешиваем, берём нужное количество, при нехватке одной из них
  /// добираем из остатка. Итоговый список ещё раз перемешиваем — easy и hard
  /// идут вперемешку, а не блоками.
  Future<List<QuizQuestionModel>> getQuestions({
    required String categoryId,
    int limit = 10,
    int hardCount = 3,
  }) async {
    final raw = await client
        .from(_tQuestions)
        .select()
        .eq('is_active', true)
        .eq('category_id', categoryId);
    final all = _cast(raw).map(QuizQuestionModel.fromJson).toList();

    final easy = all.where((q) => q.difficulty != 'hard').toList()..shuffle();
    final hard = all.where((q) => q.difficulty == 'hard').toList()..shuffle();

    final wantHard = hardCount.clamp(0, limit);
    final wantEasy = limit - wantHard;

    final selected = <QuizQuestionModel>[
      ...easy.take(wantEasy),
      ...hard.take(wantHard),
    ];

    // Одной из корзин не хватило — добираем недостающее из остатка.
    if (selected.length < limit) {
      final chosen = selected.toSet();
      final rest = all.where((q) => !chosen.contains(q)).toList()..shuffle();
      selected.addAll(rest.take(limit - selected.length));
    }

    return selected..shuffle();
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
        .select(
          'user_id, user_name, user_avatar_url, score, category_id, '
          'avg_seconds, updated_at',
        )
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
      // Тай-брейк: копим сумму avg_seconds (усредним ниже) и самый поздний
      // updated_at (момент, когда игрок добрал свой текущий счёт).
      agg.avgSecondsSum += (row['avg_seconds'] as num?)?.toDouble() ?? 0;
      agg.rowCount += 1;
      final updated = DateTime.tryParse(row['updated_at'] as String? ?? '');
      if (updated != null &&
          (agg.latestUpdatedAt == null || updated.isAfter(agg.latestUpdatedAt!))) {
        agg.latestUpdatedAt = updated;
      }
      // newest user_name wins (in case a user changed display name mid-week)
      final name = row['user_name'] as String? ?? '';
      if (name.isNotEmpty) agg.userName = name;
      // same for avatar — keep the most recent non-empty URL seen.
      final avatar = row['user_avatar_url'] as String?;
      if (avatar != null && avatar.isNotEmpty) agg.avatarUrl = avatar;
    }

    // Тай-брейк-цепочка: score ↓ → avg_seconds ↑ (быстрее выше) →
    // updated_at ↑ (раньше набрал) → user_id (стабильный якорь, чтобы порядок
    // никогда не мигал между обновлениями).
    final sorted = byUser.values.toList()
      ..sort((a, b) {
        final byScore = b.totalScore.compareTo(a.totalScore);
        if (byScore != 0) return byScore;
        final bySpeed = a.avgSeconds.compareTo(b.avgSeconds);
        if (bySpeed != 0) return bySpeed;
        final byTime = _compareTime(a.latestUpdatedAt, b.latestUpdatedAt);
        if (byTime != 0) return byTime;
        return a.userId.compareTo(b.userId);
      });

    return sorted.take(limit).map((a) {
      return QuizLeaderboardEntryModel(
        userId: a.userId,
        userName: a.userName,
        totalScore: a.totalScore,
        categoriesPlayed: a.categoryIds.where((id) => id.isNotEmpty).length,
        avatarUrl: a.avatarUrl,
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

  // ─── My last win (RPC, no promocode) ───────────────────────────────────────
  Future<QuizMyWinModel?> getMyLastWin(String userId) async {
    final raw = await client.rpc<dynamic>(
      'quiz_my_last_win',
      params: {'p_user_id': userId},
    );
    if (raw is! List || raw.isEmpty) return null;
    final rows = raw.cast<Map<String, dynamic>>();
    return QuizMyWinModel.fromJson(rows.first);
  }

  // ─── Prize tiers (public) ──────────────────────────────────────────────────
  Future<List<QuizPrizeTierModel>> getPrizeTiers() async {
    final raw = await client
        .from(_tPrizeTiers)
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);
    return _cast(raw).map(QuizPrizeTierModel.fromJson).toList();
  }

  List<Map<String, dynamic>> _cast(dynamic raw) =>
      (raw as List).cast<Map<String, dynamic>>();

  /// Ранний тайм выше. `null` (нет данных) уходит в конец.
  int _compareTime(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }
}

class _Aggregate {
  _Aggregate({required this.userId, required this.userName});

  final String userId;
  String userName;
  String? avatarUrl;
  int totalScore = 0;
  final Set<String> categoryIds = <String>{};

  /// Сумма avg_seconds по строкам игрока + счётчик — для среднего темпа.
  double avgSecondsSum = 0;
  int rowCount = 0;

  /// Самый поздний updated_at — момент достижения текущего счёта.
  DateTime? latestUpdatedAt;

  /// Средний темп ответа игрока за неделю (меньше = быстрее).
  double get avgSeconds => rowCount == 0 ? 0 : avgSecondsSum / rowCount;
}
