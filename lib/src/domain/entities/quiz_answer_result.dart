import 'package:equatable/equatable.dart';

/// Result of a single answer — pre-computed once on submit, then re-used by UI
/// to render correct/wrong/timeout state and the +score chip.
class QuizAnswerResult extends Equatable {
  const QuizAnswerResult({
    required this.selectedIndex,
    required this.isCorrect,
    required this.isTimeout,
    required this.scoreEarned,
    required this.secondsTaken,
  });

  /// -1 when the timer ran out without a selection.
  final int selectedIndex;
  final bool isCorrect;
  final bool isTimeout;
  final int scoreEarned;
  final int secondsTaken;

  @override
  List<Object?> get props => [selectedIndex, isCorrect, isTimeout, scoreEarned, secondsTaken];
}
