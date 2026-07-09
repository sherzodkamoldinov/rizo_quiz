import 'package:equatable/equatable.dart';

/// The current player's most recent weekly win — rank + prize, no promocode.
///
/// Comes from the `quiz_my_last_win` RPC. Used to show the one-time
/// congratulation sheet. The promocode itself is never exposed here; it is
/// delivered by the backend into Menu → My promocodes.
class QuizMyWin extends Equatable {
  const QuizMyWin({
    required this.periodKey,
    required this.rank,
    required this.prizeAmount,
    required this.prizeCurrency,
  });

  /// Week of the win, `YYYY-MM-DD` (Monday UTC). Used as the "seen" key.
  final String periodKey;
  final int rank;
  final int prizeAmount;
  final String prizeCurrency;

  @override
  List<Object?> get props => [periodKey, rank, prizeAmount, prizeCurrency];
}
