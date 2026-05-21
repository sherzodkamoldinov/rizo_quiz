import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz_bloc.dart';
import '../../domain/entities/quiz_leaderboard_entry.dart';
import '../../domain/entities/quiz_player.dart';
import '../../localization/quiz_strings.dart';
import '../../theme/quiz_colors.dart';
import '../../theme/quiz_radii.dart';
import '../../theme/quiz_typography.dart';
import '../widgets/atoms/quiz_circle_icon_button.dart';
import '../widgets/atoms/quiz_eyebrow.dart';
import '../widgets/atoms/quiz_serif_heading.dart';
import '../widgets/organisms/quiz_leaderboard_list.dart';
import '../widgets/organisms/quiz_leaderboard_skeleton.dart';
import '../widgets/organisms/quiz_podium.dart';
import 'quiz_player_breakdown_sheet.dart';

/// Экран таблицы лидеров.
class QuizLeaderboardPage extends StatelessWidget {
  const QuizLeaderboardPage({
    required this.player,
    this.onClose,
    super.key,
  });

  final QuizPlayer player;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final strings = QuizStrings.of(player.lang);

    return BlocBuilder<QuizBloc, QuizGameState>(
      buildWhen: (a, b) =>
          a.weeklyLeaderboard != b.weeklyLeaderboard ||
          a.isLoadingLeaderboard != b.isLoadingLeaderboard,
      builder: (context, state) {
        final entries = state.weeklyLeaderboard;
        final top3 = entries.take(3).toList();
        final rest = entries.length > 3
            ? entries.sublist(3)
            : const <QuizLeaderboardEntry>[];
        final showSkeleton = state.isLoadingLeaderboard && entries.isEmpty;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                QuizRadii.contentPadding,
                12,
                QuizRadii.contentPadding,
                90,
              ),
              children: [
                if (onClose != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: QuizCircleIconButton(
                      icon: Icons.close_rounded,
                      onTap: onClose!,
                    ),
                  ),
                if (onClose != null) const SizedBox(height: 12),
                QuizEyebrow(strings.get('eyebrow_top_week')),
                const SizedBox(height: 8),
                QuizSerifHeading(
                  text: strings.get('leaderboard_title_part_1'),
                  accent: strings.get('leaderboard_title_part_2'),
                ),
                const SizedBox(height: 6),
                Text(
                  strings.get('leaderboard_subtitle'),
                  style: QuizTypography.body.copyWith(color: colors.ink2),
                ),
                const SizedBox(height: 24),
                if (showSkeleton)
                  const QuizLeaderboardSkeleton()
                else if (top3.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        strings.get('leaderboard_empty'),
                        style: QuizTypography.body.copyWith(color: colors.mute),
                      ),
                    ),
                  )
                else ...[
                  QuizPodium(
                    entries: top3,
                    currentUserId: player.userId,
                    youBadgeText: strings.get('you_badge'),
                    onTapEntry: (e) => _openBreakdown(context, e),
                  ),
                  const SizedBox(height: 20),
                  QuizLeaderboardList(
                    entries: rest,
                    startRank: 4,
                    currentUserId: player.userId,
                    youBadgeText: strings.get('you_badge'),
                    metaBuilder: strings.categoriesLabel,
                    onTapEntry: (e) => _openBreakdown(context, e),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _openBreakdown(BuildContext context, QuizLeaderboardEntry entry) {
    showQuizPlayerBreakdownSheet(
      context: context,
      entry: entry,
      lang: player.lang,
    );
  }
}
