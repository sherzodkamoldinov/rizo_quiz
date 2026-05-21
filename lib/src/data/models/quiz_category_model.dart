import '../../domain/entities/quiz_category.dart';
import '../../utils/quiz_lang.dart';

/// Maps `quiz_categories` row to [QuizCategory].
class QuizCategoryModel {
  const QuizCategoryModel({
    required this.id,
    required this.key,
    required this.nameRu,
    required this.nameUz,
    required this.nameEn,
    required this.subtitleRu,
    required this.subtitleUz,
    required this.subtitleEn,
    required this.glyph,
    required this.sortOrder,
  });

  factory QuizCategoryModel.fromJson(Map<String, dynamic> json) {
    return QuizCategoryModel(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      nameRu: json['name_ru'] as String? ?? '',
      nameUz: json['name_uz'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      subtitleRu: json['subtitle_ru'] as String? ?? '',
      subtitleUz: json['subtitle_uz'] as String? ?? '',
      subtitleEn: json['subtitle_en'] as String? ?? '',
      glyph: json['glyph'] as String? ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String key;
  final String nameRu;
  final String nameUz;
  final String nameEn;
  final String subtitleRu;
  final String subtitleUz;
  final String subtitleEn;
  final String glyph;
  final int sortOrder;

  QuizCategory toEntity(String lang) {
    return QuizCategory(
      id: id,
      key: key,
      name: _pick(nameRu, nameUz, nameEn, lang),
      subtitle: _pick(subtitleRu, subtitleUz, subtitleEn, lang),
      glyph: glyph,
      sortOrder: sortOrder,
    );
  }

  static String _pick(String ru, String uz, String en, String lang) {
    switch (normalizeQuizLang(lang)) {
      case 'uz':
        return uz.isNotEmpty ? uz : ru;
      case 'en':
        return en.isNotEmpty ? en : ru;
      case 'ru':
      default:
        return ru;
    }
  }
}
