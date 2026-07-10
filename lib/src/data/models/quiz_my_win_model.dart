import '../../domain/entities/quiz_my_win.dart';

/// Maps a `quiz_my_last_win` RPC row to [QuizMyWin].
class QuizMyWinModel {
  const QuizMyWinModel({
    required this.periodKey,
    required this.rank,
    required this.prizeAmount,
    required this.prizeCurrency,
  });

  factory QuizMyWinModel.fromJson(Map<String, dynamic> json) {
    return QuizMyWinModel(
      periodKey: json['period_key'] as String? ?? '',
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      prizeAmount: (json['prize_amount'] as num?)?.toInt() ?? 0,
      prizeCurrency: json['prize_currency'] as String? ?? 'points',
    );
  }

  final String periodKey;
  final int rank;
  final int prizeAmount;
  final String prizeCurrency;

  QuizMyWin toEntity() {
    return QuizMyWin(
      periodKey: periodKey,
      rank: rank,
      prizeAmount: prizeAmount,
      prizeCurrency: prizeCurrency,
    );
  }
}
