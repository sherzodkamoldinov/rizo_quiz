import 'package:equatable/equatable.dart';

/// One prize tier: a rank range and the promocode value awarded to it.
///
/// Single source of truth from `quiz_prize_tiers` — the app displays these,
/// the backend/cron use the same rows to know how much to award per rank.
class QuizPrizeTier extends Equatable {
  const QuizPrizeTier({
    required this.rankFrom,
    required this.rankTo,
    required this.amount,
    required this.currency,
    required this.sortOrder,
  });

  final int rankFrom;
  final int rankTo;

  /// Prize value, e.g. 60000.
  final int amount;

  /// Prize unit code, e.g. 'points' (mapped to балл/ball/points for display).
  final String currency;

  final int sortOrder;

  bool get isSingleRank => rankFrom == rankTo;

  @override
  List<Object?> get props => [rankFrom, rankTo, amount, currency, sortOrder];
}
