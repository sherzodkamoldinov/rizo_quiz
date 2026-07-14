/// Game rules — single source of truth for round constants and scoring.
class QuizRules {
  const QuizRules._();

  static const int totalQuestions = 10;
  static const int questionSeconds = 15;
  static const int tickWarningAt = 5;
  static const Duration revealDelay = Duration(milliseconds: 1500);

  /// Score per correct answer. Wrong/timeout = 0.
  ///
  /// Formula from `design_handoff_rizo_quiz/README.md`: `100 + secondsLeft * 10`,
  /// но время меряется реальным `Stopwatch` в миллисекундах, а не целыми
  /// секундами. Поэтому ответ за 3.1s и за 3.9s даёт разные баллы:
  ///   • осталось 11900 мс → 100 + round(119.0) = 219
  ///   • осталось 11100 мс → 100 + round(111.0) = 211
  /// Диапазон за верный ответ: 100 (в последний момент) … 250 (мгновенно).
  static int scoreForAnswer({required bool isCorrect, required int msLeft}) {
    if (!isCorrect) return 0;
    final clampedMs = msLeft.clamp(0, questionSeconds * 1000);
    return 100 + (clampedMs / 1000 * 10).round();
  }

  /// Used by Result screen to render accuracy stat.
  static int accuracyPercent({required int correct, required int total}) {
    if (total == 0) return 0;
    return ((correct / total) * 100).round();
  }
}
