import 'package:flutter/material.dart';

import '../../../domain/entities/quiz_question.dart';
import '../../../localization/quiz_strings.dart';
import '../molecules/quiz_option_choice.dart';
import '../molecules/quiz_option_true_false.dart';

/// Рендерит варианты ответа в зависимости от типа вопроса.
class QuizOptionsList extends StatelessWidget {
  const QuizOptionsList({
    required this.question,
    required this.selectedIndex,
    required this.isLocked,
    required this.strings,
    required this.onSelect,
    super.key,
  });

  final QuizQuestion question;

  /// `null` — пока не выбрано; `-1` — таймаут.
  final int? selectedIndex;
  final bool isLocked;
  final QuizStrings strings;
  final ValueChanged<int> onSelect;

  static const _letters = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  Widget build(BuildContext context) {
    if (question.type == QuizQuestionType.trueFalse) {
      return _buildTrueFalse();
    }
    return _buildChoices();
  }

  Widget _buildChoices() {
    return Column(
      children: [
        for (var i = 0; i < question.options.length; i++) ...[
          QuizOptionChoice(
            letter: _letters[i % _letters.length],
            text: question.options[i],
            visual: _visualFor(i),
            onTap: isLocked ? null : () => onSelect(i),
          ),
          if (i < question.options.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildTrueFalse() {
    final opts = question.options;
    final trueLabel = opts.isNotEmpty ? opts[0] : strings.get('option_true');
    final falseLabel = opts.length > 1 ? opts[1] : strings.get('option_false');

    return Row(
      children: [
        Expanded(
          child: QuizOptionTrueFalse(
            label: trueLabel,
            isTrueVariant: true,
            visual: _visualFor(0),
            onTap: isLocked ? null : () => onSelect(0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: QuizOptionTrueFalse(
            label: falseLabel,
            isTrueVariant: false,
            visual: _visualFor(1),
            onTap: isLocked ? null : () => onSelect(1),
          ),
        ),
      ],
    );
  }

  QuizOptionVisual _visualFor(int i) {
    if (!isLocked) return QuizOptionVisual.idle;
    final isCorrectOption = i == question.correctIndex;
    final isPicked = selectedIndex != null && selectedIndex! >= 0 && i == selectedIndex;
    if (isCorrectOption) return QuizOptionVisual.correct;
    if (isPicked) return QuizOptionVisual.wrong;
    return QuizOptionVisual.faded;
  }
}
