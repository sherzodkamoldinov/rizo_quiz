import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz_bloc.dart';
import '../../domain/entities/quiz_leaderboard_entry.dart';
import '../../localization/quiz_strings.dart';
import '../../theme/quiz_colors.dart';
import '../../theme/quiz_radii.dart';
import '../../theme/quiz_typography.dart';
import '../../utils/quiz_scoring.dart';
import '../widgets/molecules/quiz_breakdown_header.dart';
import '../widgets/organisms/quiz_breakdown_list.dart';

/// Открывает bottom sheet с разбивкой очков игрока по категориям за текущую
/// неделю. Слушает `state.selectedPlayerBests` и `isLoadingPlayerBests`.
Future<void> showQuizPlayerBreakdownSheet({
  required BuildContext context,
  required QuizLeaderboardEntry entry,
  required String lang,
}) {
  context.read<QuizBloc>().add(QuizLoadPlayerBestsEvent(userId: entry.userId));

  final colors = QuizColorsScope.of(context);
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.bg,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: QuizRadii.xl),
    ),
    builder: (sheetContext) => BlocProvider.value(
      value: context.read<QuizBloc>(),
      child: QuizPlayerBreakdownSheet(entry: entry, lang: lang),
    ),
  );
}

class QuizPlayerBreakdownSheet extends StatelessWidget {
  const QuizPlayerBreakdownSheet({required this.entry, required this.lang, super.key});

  final QuizLeaderboardEntry entry;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final strings = QuizStrings.of(lang);
    final colors = QuizColorsScope.of(context);

    return BlocBuilder<QuizBloc, QuizGameState>(
      buildWhen: (a, b) =>
          a.selectedPlayerBests != b.selectedPlayerBests ||
          a.isLoadingPlayerBests != b.isLoadingPlayerBests,
      builder: (context, state) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              QuizRadii.contentPadding,
              16,
              QuizRadii.contentPadding,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.line2,
                      borderRadius: QuizRadii.brPill,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                QuizBreakdownHeader(
                  name: entry.userName,
                  totalScore: entry.totalScore,
                  totalLabel: strings.get('breakdown_total'),
                ),
                const SizedBox(height: 16),
                if (state.isLoadingPlayerBests)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colors.clay,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                else if (state.selectedPlayerBests.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      strings.get('breakdown_empty'),
                      style: QuizTypography.body.copyWith(color: colors.mute),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: QuizRadii.brLg,
                      border: Border.all(color: colors.line),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: QuizBreakdownList(
                      bests: state.selectedPlayerBests,
                      totalQuestions: QuizRules.totalQuestions,
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
}
