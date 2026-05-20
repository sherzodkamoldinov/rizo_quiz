import 'package:flutter/material.dart';

import '../../bloc/quiz_bloc.dart';
import '../../localization/quiz_strings.dart';
import '../../theme/quiz_colors.dart';
import '../../theme/quiz_radii.dart';
import '../../utils/quiz_scoring.dart';
import '../widgets/atoms/quiz_eyebrow.dart';
import '../widgets/atoms/quiz_serif_heading.dart';
import '../widgets/molecules/quiz_score_card.dart';
import '../widgets/molecules/quiz_stat_tile.dart';
import '../widgets/organisms/quiz_results_cta_stack.dart';
import '../widgets/organisms/quiz_review_list.dart';

/// Экран финального экрана раунда. Только композит.
class QuizResultPage extends StatelessWidget {
  const QuizResultPage({
    required this.state,
    required this.lang,
    required this.onPlayAgain,
    required this.onLeaderboard,
    required this.onHome,
    super.key,
  });

  final QuizGameState state;
  final String lang;
  final VoidCallback onPlayAgain;
  final VoidCallback onLeaderboard;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final strings = QuizStrings.of(lang);
    final correct = state.correctCount;
    final accuracy = QuizRules.accuracyPercent(
      correct: correct,
      total: QuizRules.totalQuestions,
    );

    final results = List<bool>.generate(
      state.questions.length,
      (i) => i < state.correctCount,
    );

    final subtitle = strings.get('result_subtitle')
        .replaceAll('{correct}', '$correct')
        .replaceAll('{total}', '${QuizRules.totalQuestions}')
        .replaceAll('{sec}', state.averageSeconds.toStringAsFixed(1));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            QuizRadii.contentPadding,
            16,
            QuizRadii.contentPadding,
            32,
          ),
          children: [
            QuizEyebrow(strings.get('eyebrow_round_summary')),
            const SizedBox(height: 12),
            QuizSerifHeading(
              text: strings.verdict(correct).split(' ').take(
                strings.verdict(correct).split(' ').length - 1,
              ).join(' '),
              accent: strings.verdictAccent(correct),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.ink2),
            ),
            const SizedBox(height: 22),
            QuizScoreCard(label: strings.get('label_points'), score: state.score),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: QuizStatTile(
                    label: strings.get('stat_accuracy'),
                    value: '$accuracy%',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuizStatTile(
                    label: strings.get('stat_speed'),
                    value: '${state.averageSeconds.toStringAsFixed(1)} ${strings.get('stat_sec_unit')}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            QuizReviewList(
              title: strings.get('review_title'),
              questions: state.questions,
              results: results,
            ),
            const SizedBox(height: 24),
            QuizResultsCtaStack(
              primaryLabel: strings.get('cta_play_again'),
              secondaryLabel: strings.get('cta_leaderboard'),
              tertiaryLabel: strings.get('cta_home'),
              onPrimary: onPlayAgain,
              onSecondary: onLeaderboard,
              onTertiary: onHome,
            ),
          ],
        ),
      ),
    );
  }
}
