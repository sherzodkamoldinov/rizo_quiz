import '../../domain/entities/quiz_category_best.dart';
import '../../utils/quiz_lang.dart';

/// Row from JOIN `quiz_player_scores` × `quiz_categories`.
class QuizCategoryBestModel {
  const QuizCategoryBestModel({
    required this.categoryId,
    required this.nameRu,
    required this.nameUz,
    required this.nameEn,
    required this.glyph,
    required this.score,
    required this.correctCount,
    required this.avgSeconds,
  });

  factory QuizCategoryBestModel.fromJson(Map<String, dynamic> json) {
    final cat = (json['category'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    return QuizCategoryBestModel(
      categoryId: json['category_id'] as String? ?? '',
      nameRu: cat['name_ru'] as String? ?? '',
      nameUz: cat['name_uz'] as String? ?? '',
      nameEn: cat['name_en'] as String? ?? '',
      glyph: cat['glyph'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      correctCount: (json['correct_count'] as num?)?.toInt() ?? 0,
      avgSeconds: (json['avg_seconds'] as num?)?.toDouble() ?? 0,
    );
  }

  final String categoryId;
  final String nameRu;
  final String nameUz;
  final String nameEn;
  final String glyph;
  final int score;
  final int correctCount;
  final double avgSeconds;

  QuizCategoryBest toEntity(String lang) {
    return QuizCategoryBest(
      categoryId: categoryId,
      categoryName: _pick(lang),
      categoryGlyph: glyph,
      score: score,
      correctCount: correctCount,
      avgSeconds: avgSeconds,
    );
  }

  String _pick(String lang) {
    switch (normalizeQuizLang(lang)) {
      case 'uz':
        return nameUz.isNotEmpty ? nameUz : nameRu;
      case 'en':
        return nameEn.isNotEmpty ? nameEn : nameRu;
      case 'ru':
      default:
        return nameRu;
    }
  }
}
