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

enum QuizDifficulty {
  easy,
  hard;

  bool get isHard => this == QuizDifficulty.hard;

  static QuizDifficulty fromRaw(String? raw) {
    return raw == 'hard' ? QuizDifficulty.hard : QuizDifficulty.easy;
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
    this.difficulty = QuizDifficulty.easy,
  });

  final String id;
  final String categoryId;
  final QuizQuestionType type;

  /// Сложность вопроса. Для [QuizDifficulty.hard] в UI показываем бейдж.
  final QuizDifficulty difficulty;

  /// Localized question text.
  final String text;

  /// Localized answer options. For [QuizQuestionType.trueFalse] length must be 2.
  final List<String> options;

  /// Index of the correct option in [options].
  final int correctIndex;

  /// Возвращает копию вопроса с перемешанными вариантами и пересчитанным
  /// [correctIndex]. Мешается перестановка индексов (устойчиво к дублям текста).
  ///
  /// [QuizQuestionType.trueFalse] не трогаем — «Верно/Неверно» должны идти в
  /// фиксированном порядке.
  QuizQuestion shuffledOptions() {
    if (type == QuizQuestionType.trueFalse || options.length < 2) return this;
    final order = List<int>.generate(options.length, (i) => i)..shuffle();
    return QuizQuestion(
      id: id,
      categoryId: categoryId,
      type: type,
      text: text,
      options: [for (final i in order) options[i]],
      correctIndex: order.indexOf(correctIndex),
      difficulty: difficulty,
    );
  }

  @override
  List<Object?> get props =>
      [id, categoryId, type, text, options, correctIndex, difficulty];
}
