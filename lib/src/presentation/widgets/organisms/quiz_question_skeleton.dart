import 'package:flutter/material.dart';

import '../atoms/quiz_skeleton_box.dart';
import '../effects/quiz_shimmer.dart';

/// Плейсхолдер экрана вопроса: top-bar + сегменты + чип категории +
/// текст вопроса + 4 опции.
class QuizQuestionSkeleton extends StatelessWidget {
  const QuizQuestionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Top bar ─────────────────────────────────────────────
          const Row(
            children: [
              QuizSkeletonBox(width: 40, height: 40, radius: 999),
              Spacer(),
              QuizSkeletonBox(width: 120, height: 14, radius: 7),
              Spacer(),
              QuizSkeletonBox(width: 60, height: 32, radius: 999),
            ],
          ),
          const SizedBox(height: 18),

          // ─── Progress segments ──────────────────────────────────
          Row(
            children: List.generate(10, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 9 ? 0 : 4),
                  child: const QuizSkeletonBox(height: 3, radius: 2),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // ─── Category tag ──────────────────────────────────────
          const QuizSkeletonBox(width: 180, height: 22, radius: 999),
          const SizedBox(height: 18),

          // ─── Question text (3 lines varying width) ─────────────
          const QuizSkeletonBox(height: 24, radius: 6),
          const SizedBox(height: 10),
          const QuizSkeletonBox(width: 280, height: 24, radius: 6),
          const SizedBox(height: 10),
          const QuizSkeletonBox(width: 200, height: 24, radius: 6),
          const SizedBox(height: 26),

          // ─── 4 options ─────────────────────────────────────────
          for (int i = 0; i < 4; i++) ...[
            const QuizSkeletonBox(height: 60, radius: 14),
            if (i < 3) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
