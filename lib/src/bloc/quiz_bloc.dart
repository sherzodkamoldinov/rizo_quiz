import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/quiz_category.dart';
import '../domain/entities/quiz_category_best.dart';
import '../domain/entities/quiz_leaderboard_entry.dart';
import '../domain/entities/quiz_player.dart';
import '../domain/entities/quiz_question.dart';
import '../domain/repositories/quiz_repository.dart';
import '../localization/quiz_strings.dart';
import '../utils/quiz_period.dart';
import '../utils/quiz_scoring.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

/// Owns the entire quiz round lifecycle: load categories → start round →
/// timed answers → upsert per-category best → weekly leaderboard.
class QuizBloc extends Bloc<QuizEvent, QuizGameState> {
  QuizBloc({
    required this.repository,
    required this.player,
  })  : _strings = QuizStrings.of(player.lang),
        super(const QuizGameState()) {
    on<QuizLoadCategoriesEvent>(_onLoadCategories);
    on<QuizStartRoundEvent>(_onStartRound);
    on<QuizAnswerSelectedEvent>(_onAnswerSelected);
    on<QuizTimerTickedEvent>(_onTimerTicked);
    on<QuizTimerExpiredEvent>(_onTimerExpired);
    on<QuizNextQuestionEvent>(_onNextQuestion);
    on<QuizFinishRoundEvent>(_onFinishRound);
    on<QuizLoadLeaderboardEvent>(_onLoadLeaderboard);
    on<QuizLoadPlayerBestsEvent>(_onLoadPlayerBests);
    on<QuizExitRoundEvent>(_onExitRound);
  }

  final QuizRepository repository;
  final QuizPlayer player;
  final QuizStrings _strings;

  Timer? _tickTimer;
  Timer? _revealTimer;

  @override
  Future<void> close() {
    _cancelTimers();
    return super.close();
  }

  // ─── Handlers ───────────────────────────────────────────────────────────

  Future<void> _onLoadCategories(
    QuizLoadCategoriesEvent event,
    Emitter<QuizGameState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loadingCategories, failureMessage: () => null));
    try {
      final categories = await repository.getCategories(lang: player.lang);
      emit(state.copyWith(status: QuizStatus.categoriesLoaded, categories: categories));
    } on Object catch (_) {
      emit(state.copyWith(
        status: QuizStatus.error,
        failureMessage: () => _strings.get('error_server'),
      ));
    }
  }

  Future<void> _onStartRound(
    QuizStartRoundEvent event,
    Emitter<QuizGameState> emit,
  ) async {
    _cancelTimers();
    emit(state.copyWith(
      status: QuizStatus.loadingQuestions,
      activeCategoryId: () => event.categoryId,
      currentIndex: 0,
      score: 0,
      correctCount: 0,
      lastEarnedScore: 0,
      totalElapsedSeconds: 0,
      selectedAnswerIndex: () => null,
      secondsLeft: QuizRules.questionSeconds,
      failureMessage: () => null,
    ));

    try {
      final questions = await repository.getQuestions(
        categoryId: event.categoryId,
        lang: player.lang,
        limit: QuizRules.totalQuestions,
      );
      if (questions.isEmpty) {
        emit(state.copyWith(
          status: QuizStatus.error,
          failureMessage: () => _strings.get('error_no_questions'),
        ));
        return;
      }
      emit(state.copyWith(
        status: QuizStatus.inProgress,
        questions: questions,
        secondsLeft: QuizRules.questionSeconds,
      ));
      _startTimer();
    } on Object catch (_) {
      emit(state.copyWith(
        status: QuizStatus.error,
        failureMessage: () => _strings.get('error_server'),
      ));
    }
  }

  void _onTimerTicked(QuizTimerTickedEvent event, Emitter<QuizGameState> emit) {
    if (state.status != QuizStatus.inProgress) return;
    if (event.secondsLeft <= 0) {
      add(const QuizTimerExpiredEvent());
      return;
    }
    emit(state.copyWith(secondsLeft: event.secondsLeft));
  }

  void _onTimerExpired(QuizTimerExpiredEvent event, Emitter<QuizGameState> emit) {
    if (state.status != QuizStatus.inProgress) return;
    _cancelTimers();
    emit(state.copyWith(
      status: QuizStatus.answerRevealed,
      secondsLeft: 0,
      selectedAnswerIndex: () => -1,
      lastEarnedScore: 0,
      totalElapsedSeconds: state.totalElapsedSeconds + QuizRules.questionSeconds,
    ));
    _scheduleNextQuestion();
  }

  void _onAnswerSelected(QuizAnswerSelectedEvent event, Emitter<QuizGameState> emit) {
    if (state.status != QuizStatus.inProgress) return;
    final question = state.currentQuestion;
    if (question == null) return;

    _cancelTimers();

    final isCorrect = event.selectedIndex == question.correctIndex;
    final earned = QuizRules.scoreForAnswer(
      isCorrect: isCorrect,
      secondsLeft: state.secondsLeft,
    );
    final elapsed = QuizRules.questionSeconds - state.secondsLeft;

    emit(state.copyWith(
      status: QuizStatus.answerRevealed,
      selectedAnswerIndex: () => event.selectedIndex,
      score: state.score + earned,
      correctCount: state.correctCount + (isCorrect ? 1 : 0),
      lastEarnedScore: earned,
      totalElapsedSeconds: state.totalElapsedSeconds + elapsed,
    ));

    _scheduleNextQuestion();
  }

  void _onNextQuestion(QuizNextQuestionEvent event, Emitter<QuizGameState> emit) {
    if (state.isLastQuestion) {
      add(const QuizFinishRoundEvent());
      return;
    }
    emit(state.copyWith(
      status: QuizStatus.inProgress,
      currentIndex: state.currentIndex + 1,
      selectedAnswerIndex: () => null,
      secondsLeft: QuizRules.questionSeconds,
    ));
    _startTimer();
  }

  Future<void> _onFinishRound(
    QuizFinishRoundEvent event,
    Emitter<QuizGameState> emit,
  ) async {
    _cancelTimers();
    emit(state.copyWith(status: QuizStatus.submittingScore));
    final categoryId = state.activeCategoryId;
    if (categoryId != null) {
      try {
        await repository.submitScore(
          userId: player.userId,
          userName: player.displayName.isEmpty ? _strings.get('guest') : player.displayName,
          avatarUrl: player.avatarUrl,
          categoryId: categoryId,
          periodKey: QuizPeriodKey.currentWeek(),
          score: state.score,
          correctCount: state.correctCount,
          avgSeconds: state.averageSeconds,
        );
      } on Object catch (_) {
        // Не показываем ошибку — счёт уже виден игроку. Просто не уйдёт в облако.
      }
    }
    emit(state.copyWith(status: QuizStatus.finished));
  }

  Future<void> _onLoadLeaderboard(
    QuizLoadLeaderboardEvent event,
    Emitter<QuizGameState> emit,
  ) async {
    emit(state.copyWith(isLoadingLeaderboard: true));
    try {
      final entries = await repository.getWeeklyLeaderboard(
        periodKey: QuizPeriodKey.currentWeek(),
      );
      emit(state.copyWith(weeklyLeaderboard: entries, isLoadingLeaderboard: false));
    } on Object catch (_) {
      emit(state.copyWith(weeklyLeaderboard: const [], isLoadingLeaderboard: false));
    }
  }

  Future<void> _onLoadPlayerBests(
    QuizLoadPlayerBestsEvent event,
    Emitter<QuizGameState> emit,
  ) async {
    emit(state.copyWith(isLoadingPlayerBests: true, selectedPlayerBests: const []));
    try {
      final bests = await repository.getPlayerCategoryBests(
        userId: event.userId,
        periodKey: QuizPeriodKey.currentWeek(),
        lang: player.lang,
      );
      emit(state.copyWith(selectedPlayerBests: bests, isLoadingPlayerBests: false));
    } on Object catch (_) {
      emit(state.copyWith(
        selectedPlayerBests: const [],
        isLoadingPlayerBests: false,
      ));
    }
  }

  void _onExitRound(QuizExitRoundEvent event, Emitter<QuizGameState> emit) {
    _cancelTimers();
    emit(state.copyWith(
      status: QuizStatus.categoriesLoaded,
      questions: const [],
      currentIndex: 0,
      selectedAnswerIndex: () => null,
      secondsLeft: QuizRules.questionSeconds,
      score: 0,
      correctCount: 0,
      lastEarnedScore: 0,
      totalElapsedSeconds: 0,
      activeCategoryId: () => null,
    ));
  }

  // ─── Timers ─────────────────────────────────────────────────────────────

  void _startTimer() {
    _tickTimer?.cancel();
    var remaining = QuizRules.questionSeconds;
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      remaining -= 1;
      if (isClosed) return;
      add(QuizTimerTickedEvent(secondsLeft: remaining));
    });
  }

  void _scheduleNextQuestion() {
    _revealTimer?.cancel();
    _revealTimer = Timer(QuizRules.revealDelay, () {
      if (isClosed) return;
      add(const QuizNextQuestionEvent());
    });
  }

  void _cancelTimers() {
    _tickTimer?.cancel();
    _revealTimer?.cancel();
  }
}
