import '../../domain/entities/quiz_prize_tier.dart';

/// Maps a `quiz_prize_tiers` row to [QuizPrizeTier].
class QuizPrizeTierModel {
  const QuizPrizeTierModel({
    required this.rankFrom,
    required this.rankTo,
    required this.amount,
    required this.currency,
    required this.sortOrder,
  });

  factory QuizPrizeTierModel.fromJson(Map<String, dynamic> json) {
    return QuizPrizeTierModel(
      rankFrom: (json['rank_from'] as num?)?.toInt() ?? 0,
      rankTo: (json['rank_to'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'points',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  final int rankFrom;
  final int rankTo;
  final int amount;
  final String currency;
  final int sortOrder;

  QuizPrizeTier toEntity() {
    return QuizPrizeTier(
      rankFrom: rankFrom,
      rankTo: rankTo,
      amount: amount,
      currency: currency,
      sortOrder: sortOrder,
    );
  }
}
