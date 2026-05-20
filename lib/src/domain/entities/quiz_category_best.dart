import 'package:equatable/equatable.dart';

/// One row in a player's per-category breakdown for the current week.
class QuizCategoryBest extends Equatable {
  const QuizCategoryBest({
    required this.categoryId,
    required this.categoryName,
    required this.categoryGlyph,
    required this.score,
    required this.correctCount,
    required this.avgSeconds,
  });

  final String categoryId;
  final String categoryName;
  final String categoryGlyph;
  final int score;
  final int correctCount;
  final double avgSeconds;

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        categoryGlyph,
        score,
        correctCount,
        avgSeconds,
      ];
}
