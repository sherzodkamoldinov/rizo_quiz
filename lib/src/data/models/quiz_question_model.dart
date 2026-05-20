import '../../domain/entities/quiz_question.dart';

/// Maps `quiz_questions` row to [QuizQuestion].
class QuizQuestionModel {
  const QuizQuestionModel({
    required this.id,
    required this.categoryId,
    required this.type,
    required this.questionRu,
    required this.questionUz,
    required this.questionEn,
    required this.optionsRu,
    required this.optionsUz,
    required this.optionsEn,
    required this.correctIndex,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      type: json['type'] as String? ?? 'multiple_choice',
      questionRu: json['question_ru'] as String? ?? '',
      questionUz: json['question_uz'] as String? ?? '',
      questionEn: json['question_en'] as String? ?? '',
      optionsRu: _parseOptions(json['options_ru']),
      optionsUz: _parseOptions(json['options_uz']),
      optionsEn: _parseOptions(json['options_en']),
      correctIndex: (json['correct_index'] as num?)?.toInt() ?? 0,
    );
  }

  static List<String> _parseOptions(Object? raw) {
    if (raw is List) {
      return raw.map((e) => e?.toString() ?? '').toList();
    }
    return const [];
  }

  final String id;
  final String categoryId;
  final String type;
  final String questionRu;
  final String questionUz;
  final String questionEn;
  final List<String> optionsRu;
  final List<String> optionsUz;
  final List<String> optionsEn;
  final int correctIndex;

  QuizQuestion toEntity(String lang) {
    return QuizQuestion(
      id: id,
      categoryId: categoryId,
      type: QuizQuestionType.fromRaw(type),
      text: _pickText(lang),
      options: _pickOptions(lang),
      correctIndex: correctIndex,
    );
  }

  String _pickText(String lang) {
    switch (lang) {
      case 'uz':
        return questionUz.isNotEmpty ? questionUz : questionRu;
      case 'en':
        return questionEn.isNotEmpty ? questionEn : questionRu;
      case 'ru':
      default:
        return questionRu;
    }
  }

  List<String> _pickOptions(String lang) {
    switch (lang) {
      case 'uz':
        return optionsUz.isNotEmpty ? optionsUz : optionsRu;
      case 'en':
        return optionsEn.isNotEmpty ? optionsEn : optionsRu;
      case 'ru':
      default:
        return optionsRu;
    }
  }
}
