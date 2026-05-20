part of 'quiz_bloc.dart';

sealed class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => const [];
}

class QuizLoadCategoriesEvent extends QuizEvent {
  const QuizLoadCategoriesEvent();
}

class QuizStartRoundEvent extends QuizEvent {
  const QuizStartRoundEvent({required this.categoryId});

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class QuizAnswerSelectedEvent extends QuizEvent {
  const QuizAnswerSelectedEvent({required this.selectedIndex});

  final int selectedIndex;

  @override
  List<Object?> get props => [selectedIndex];
}

class QuizTimerTickedEvent extends QuizEvent {
  const QuizTimerTickedEvent({required this.secondsLeft});

  final int secondsLeft;

  @override
  List<Object?> get props => [secondsLeft];
}

class QuizTimerExpiredEvent extends QuizEvent {
  const QuizTimerExpiredEvent();
}

class QuizNextQuestionEvent extends QuizEvent {
  const QuizNextQuestionEvent();
}

class QuizFinishRoundEvent extends QuizEvent {
  const QuizFinishRoundEvent();
}

class QuizLoadLeaderboardEvent extends QuizEvent {
  const QuizLoadLeaderboardEvent();
}

/// Asks the BLoC to fetch a player's per-category breakdown for the current
/// week. The result lives in `state.selectedPlayerBests`; the bottom sheet
/// reads from there.
class QuizLoadPlayerBestsEvent extends QuizEvent {
  const QuizLoadPlayerBestsEvent({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class QuizExitRoundEvent extends QuizEvent {
  const QuizExitRoundEvent();
}
