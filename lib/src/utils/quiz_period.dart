/// Computes the weekly period key used as the third component of the
/// `(user_id, category_id, period_key)` unique tuple in `quiz_player_scores`.
///
/// Format: `YYYY-MM-DD` of the Monday (UTC) of the current week.
/// Stable across client/server and human-readable for debugging.
class QuizPeriodKey {
  const QuizPeriodKey._();

  /// Current week key (UTC).
  static String currentWeek({DateTime? now}) {
    final reference = (now ?? DateTime.now()).toUtc();
    final daysSinceMonday = reference.weekday - DateTime.monday;
    final monday = DateTime.utc(reference.year, reference.month, reference.day)
        .subtract(Duration(days: daysSinceMonday));
    final mm = monday.month.toString().padLeft(2, '0');
    final dd = monday.day.toString().padLeft(2, '0');
    return '${monday.year}-$mm-$dd';
  }
}
