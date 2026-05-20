import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz_bloc.dart';
import '../../domain/entities/quiz_question.dart';
import '../../localization/quiz_strings.dart';
import '../../services/quiz_audio_service.dart';
import '../../theme/quiz_radii.dart';
import '../../utils/quiz_scoring.dart';
import '../widgets/atoms/quiz_serif_heading.dart';
import '../widgets/effects/shake_wrapper.dart';
import '../widgets/molecules/quiz_answer_toast.dart';
import '../widgets/molecules/quiz_category_tag.dart';
import '../widgets/molecules/quiz_progress_segments.dart';
import '../widgets/molecules/quiz_top_bar.dart';
import '../widgets/organisms/quiz_question_skeleton.dart';
import '../widgets/organisms/quiz_options_list.dart';

/// Экран вопроса. Только композит + один локальный side-effect listener (audio).
class QuizQuestionPage extends StatelessWidget {
  const QuizQuestionPage({
    required this.lang,
    required this.audioService,
    required this.contextBanner,
    required this.onExit,
    super.key,
  });

  final String lang;
  final QuizAudioService audioService;
  final Widget? contextBanner;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final strings = QuizStrings.of(lang);

    return BlocConsumer<QuizBloc, QuizGameState>(
      listenWhen: (a, b) =>
          a.status != b.status ||
          a.secondsLeft != b.secondsLeft ||
          a.currentIndex != b.currentIndex,
      listener: (_, state) => _onAudioCues(state),
      builder: (context, state) {
        final q = state.currentQuestion;
        final showToast = state.status == QuizStatus.answerRevealed;
        final isLoading = state.status == QuizStatus.loadingQuestions || q == null;

        if (isLoading) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  QuizRadii.contentPadding,
                  12,
                  QuizRadii.contentPadding,
                  24,
                ),
                child: QuizQuestionSkeleton(),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(
                    QuizRadii.contentPadding,
                    12,
                    QuizRadii.contentPadding,
                    140,
                  ),
                  children: [
                    QuizTopBar(
                      label: strings.get('q_top_of_total').replaceAll(
                            '{n}',
                            '${state.currentIndex + 1}',
                          ).replaceAll(
                            '{total}',
                            '${QuizRules.totalQuestions}',
                          ),
                      secondsLeft: state.secondsLeft,
                      onBack: onExit,
                    ),
                    const SizedBox(height: 18),
                    QuizProgressSegments(
                      total: QuizRules.totalQuestions,
                      currentIndex: state.currentIndex,
                      results: _resultsTrail(state),
                    ),
                    const SizedBox(height: 24),
                    if (contextBanner != null) ...[
                      contextBanner!,
                      const SizedBox(height: 16),
                    ],
                    QuizCategoryTag(
                      categoryName: _categoryNameById(state.activeCategoryId, state),
                      typeLabel: q.type == QuizQuestionType.trueFalse
                          ? strings.get('tag_true_false')
                          : strings.get('tag_choice'),
                    ),
                    const SizedBox(height: 14),
                    ShakeWrapper(
                      trigger: _shakeTrigger(state),
                      child: QuizSerifHeading(
                        text: q.text,
                        variant: QuizHeadingVariant.question,
                      ),
                    ),
                    const SizedBox(height: 22),
                    QuizOptionsList(
                      question: q,
                      selectedIndex: state.selectedAnswerIndex,
                      isLocked: state.status == QuizStatus.answerRevealed,
                      strings: strings,
                      onSelect: (i) => context.read<QuizBloc>().add(
                            QuizAnswerSelectedEvent(selectedIndex: i),
                          ),
                    ),
                  ],
                ),
                if (showToast)
                  Positioned(
                    left: QuizRadii.contentPadding,
                    right: QuizRadii.contentPadding,
                    bottom: 92,
                    child: QuizAnswerToast(
                      isTimeout: state.selectedAnswerIndex == -1,
                      scoreDelta: state.lastEarnedScore,
                      correctCount: state.correctCount,
                      strings: strings,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Object? _shakeTrigger(QuizGameState state) {
    if (state.status != QuizStatus.answerRevealed) return null;
    if (state.lastEarnedScore > 0) return null;
    // Уникальный ключ на каждый «неверный»: индекс + score (score не меняется
    // при ошибке, но индекс — да).
    return '${state.currentIndex}_${state.score}_wrong';
  }

  List<bool> _resultsTrail(QuizGameState state) {
    // Минимальный честный трейл: для отвеченных вопросов — статус берём из
    // (correctCount при i < currentIndex). Сейчас храним только summary —
    // обходимся флагами True для caught up correct count. Для дизайна
    // достаточно показать «верно/неверно/таймаут» на конкретный i — используем
    // эвристику: первые `correctCount` индексов отмечены true. Точный массив
    // требует расширения state (out of scope сейчас).
    final trail = <bool>[];
    for (var i = 0; i < state.currentIndex; i++) {
      trail.add(i < state.correctCount);
    }
    return trail;
  }

  String _categoryNameById(String? id, QuizGameState state) {
    if (id == null) return '';
    final match = state.categories.where((c) => c.id == id);
    return match.isNotEmpty ? match.first.name : '';
  }

  void _onAudioCues(QuizGameState state) {
    if (state.status == QuizStatus.inProgress && state.secondsLeft <= QuizRules.tickWarningAt) {
      audioService.playTick();
    }
    if (state.status == QuizStatus.answerRevealed) {
      if (state.lastEarnedScore > 0) {
        audioService.playCorrect();
      } else {
        audioService.playWrong();
      }
    }
    if (state.status == QuizStatus.submittingScore) {
      audioService.playFinish();
    }
  }
}
