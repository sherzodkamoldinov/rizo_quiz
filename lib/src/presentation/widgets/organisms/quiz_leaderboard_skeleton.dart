import 'package:flutter/material.dart';

import '../../../theme/quiz_colors.dart';
import '../../../theme/quiz_radii.dart';
import '../atoms/quiz_skeleton_box.dart';
import '../effects/quiz_shimmer.dart';

/// Плейсхолдер таблицы лидеров: подиум + список оставшихся.
class QuizLeaderboardSkeleton extends StatelessWidget {
  const QuizLeaderboardSkeleton({this.restRows = 5, super.key});

  final int restRows;

  @override
  Widget build(BuildContext context) {
    return QuizShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header text ──────────────────────────────────────
          const QuizSkeletonBox(width: 120, height: 12, radius: 6),
          const SizedBox(height: 12),
          const QuizSkeletonBox(width: 220, height: 36, radius: 8),
          const SizedBox(height: 10),
          const QuizSkeletonBox(width: 180, height: 14, radius: 7),
          const SizedBox(height: 28),

          // ─── Podium ──────────────────────────────────────────
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _PodiumColumnSkeleton(barHeight: 90)),
              Expanded(child: _PodiumColumnSkeleton(barHeight: 120)),
              Expanded(child: _PodiumColumnSkeleton(barHeight: 70)),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Rest list ──────────────────────────────────────
          _RestListSkeleton(rows: restRows),
        ],
      ),
    );
  }
}

class _PodiumColumnSkeleton extends StatelessWidget {
  const _PodiumColumnSkeleton({required this.barHeight});

  final double barHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          const QuizSkeletonBox(width: 56, height: 56, radius: 999),
          const SizedBox(height: 8),
          const QuizSkeletonBox(width: 60, height: 12, radius: 6),
          const SizedBox(height: 8),
          const QuizSkeletonBox(width: 50, height: 16, radius: 999),
          const SizedBox(height: 10),
          QuizSkeletonBox(height: barHeight, radius: 14),
        ],
      ),
    );
  }
}

class _RestListSkeleton extends StatelessWidget {
  const _RestListSkeleton({required this.rows});

  final int rows;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: QuizRadii.brLg,
        border: Border.all(color: colors.line),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: List.generate(rows, (i) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              children: [
                QuizSkeletonBox(width: 18, height: 12, radius: 4),
                SizedBox(width: 10),
                QuizSkeletonBox(width: 32, height: 32, radius: 8),
                SizedBox(width: 12),
                Expanded(child: QuizSkeletonBox(height: 14, radius: 7)),
                SizedBox(width: 10),
                QuizSkeletonBox(width: 50, height: 18, radius: 6),
              ],
            ),
          );
        }),
      ),
    );
  }
}
