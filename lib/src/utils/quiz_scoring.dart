/// Game rules — single source of truth for round constants and scoring.
class QuizRules {
  const QuizRules._();

  static const int totalQuestions = 10;
  static const int questionSeconds = 15;
  static const int tickWarningAt = 5;
  static const Duration revealDelay = Duration(milliseconds: 1500);

  /// Score per correct answer. Wrong/timeout = 0.
  /// Formula from `design_handoff_rizo_quiz/README.md`: `100 + secondsLeft * 10`.
  static int scoreForAnswer({required bool isCorrect, required int secondsLeft}) {
    if (!isCorrect) return 0;
    final clamped = secondsLeft.clamp(0, questionSeconds);
    return 100 + clamped * 10;
  }

  /// Used by Result screen to render accuracy stat.
  static int accuracyPercent({required int correct, required int total}) {
    if (total == 0) return 0;
    return ((correct / total) * 100).round();
  }
}
