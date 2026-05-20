part of 'quiz_bloc.dart';

enum QuizStatus {
  idle,
  loadingCategories,
  categoriesLoaded,
  loadingQuestions,
  inProgress,
  answerRevealed,
  submittingScore,
  finished,
  error,
}

class QuizGameState extends Equatable {
  const QuizGameState({
    this.status = QuizStatus.idle,
    this.categories = const [],
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswerIndex,
    this.secondsLeft = QuizRules.questionSeconds,
    this.score = 0,
    this.correctCount = 0,
    this.lastEarnedScore = 0,
    this.totalElapsedSeconds = 0,
    this.activeCategoryId,
    this.weeklyLeaderboard = const [],
    this.isLoadingLeaderboard = false,
    this.selectedPlayerBests = const [],
    this.isLoadingPlayerBests = false,
    this.failureMessage,
  });

  final QuizStatus status;
  final List<QuizCategory> categories;
  final List<QuizQuestion> questions;
  final int currentIndex;

  /// `null` — answer not yet selected. `-1` — timer expired without selection.
  final int? selectedAnswerIndex;

  final int secondsLeft;
  final int score;
  final int correctCount;

  /// Score earned on the last answer (for +N pill in toast).
  final int lastEarnedScore;

  /// Sum of (questionSeconds - secondsLeft) across answered questions — used
  /// for the "average speed" stat on results.
  final int totalElapsedSeconds;

  /// `null` between rounds.
  final String? activeCategoryId;

  /// Aggregated current-week leaderboard. Mutated by [QuizLoadLeaderboardEvent].
  final List<QuizLeaderboardEntry> weeklyLeaderboard;

  /// True while the leaderboard fetch is in flight — for shimmer placeholder.
  final bool isLoadingLeaderboard;

  /// Per-category bests of the currently inspected player. Populated by
  /// [QuizLoadPlayerBestsEvent] when the user taps a leaderboard row.
  final List<QuizCategoryBest> selectedPlayerBests;

  final bool isLoadingPlayerBests;

  final String? failureMessage;

  QuizQuestion? get currentQuestion =>
      currentIndex >= 0 && currentIndex < questions.length ? questions[currentIndex] : null;

  bool get isLastQuestion => currentIndex >= questions.length - 1;

  double get averageSeconds {
    final answered = currentIndex + 1;
    if (answered <= 0) return 0;
    return totalElapsedSeconds / answered;
  }

  QuizGameState copyWith({
    QuizStatus? status,
    List<QuizCategory>? categories,
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? Function()? selectedAnswerIndex,
    int? secondsLeft,
    int? score,
    int? correctCount,
    int? lastEarnedScore,
    int? totalElapsedSeconds,
    String? Function()? activeCategoryId,
    List<QuizLeaderboardEntry>? weeklyLeaderboard,
    bool? isLoadingLeaderboard,
    List<QuizCategoryBest>? selectedPlayerBests,
    bool? isLoadingPlayerBests,
    String? Function()? failureMessage,
  }) {
    return QuizGameState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswerIndex:
          selectedAnswerIndex != null ? selectedAnswerIndex() : this.selectedAnswerIndex,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      score: score ?? this.score,
      correctCount: correctCount ?? this.correctCount,
      lastEarnedScore: lastEarnedScore ?? this.lastEarnedScore,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
      activeCategoryId:
          activeCategoryId != null ? activeCategoryId() : this.activeCategoryId,
      weeklyLeaderboard: weeklyLeaderboard ?? this.weeklyLeaderboard,
      isLoadingLeaderboard: isLoadingLeaderboard ?? this.isLoadingLeaderboard,
      selectedPlayerBests: selectedPlayerBests ?? this.selectedPlayerBests,
      isLoadingPlayerBests: isLoadingPlayerBests ?? this.isLoadingPlayerBests,
      failureMessage: failureMessage != null ? failureMessage() : this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        questions,
        currentIndex,
        selectedAnswerIndex,
        secondsLeft,
        score,
        correctCount,
        lastEarnedScore,
        totalElapsedSeconds,
        activeCategoryId,
        weeklyLeaderboard,
        isLoadingLeaderboard,
        selectedPlayerBests,
        isLoadingPlayerBests,
        failureMessage,
      ];
}
