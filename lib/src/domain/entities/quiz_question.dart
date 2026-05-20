import 'package:equatable/equatable.dart';

enum QuizQuestionType {
  multipleChoice,
  trueFalse;

  static QuizQuestionType fromRaw(String? raw) {
    switch (raw) {
      case 'true_false':
        return QuizQuestionType.trueFalse;
      case 'multiple_choice':
      default:
        return QuizQuestionType.multipleChoice;
    }
  }
}

class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.id,
    required this.categoryId,
    required this.type,
    required this.text,
    required this.options,
    required this.correctIndex,
  });

  final String id;
  final String categoryId;
  final QuizQuestionType type;

  /// Localized question text.
  final String text;

  /// Localized answer options. For [QuizQuestionType.trueFalse] length must be 2.
  final List<String> options;

  /// Index of the correct option in [options].
  final int correctIndex;

  @override
  List<Object?> get props => [id, categoryId, type, text, options, correctIndex];
}
