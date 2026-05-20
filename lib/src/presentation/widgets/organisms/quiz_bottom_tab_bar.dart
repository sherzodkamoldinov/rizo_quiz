import 'package:flutter/material.dart';

import '../molecules/quiz_bottom_tab_item.dart';

enum QuizTab { home, leaderboard }

/// Нижний бар-навигации. Прозрачный фон — за ним просвечивает декор страницы.
/// Табы растянуты на всю ширину поровну.
class QuizBottomTabBar extends StatelessWidget {
  const QuizBottomTabBar({
    required this.active,
    required this.labelHome,
    required this.labelLeaderboard,
    required this.onTap,
    super.key,
  });

  final QuizTab active;
  final String labelHome;
  final String labelLeaderboard;
  final ValueChanged<QuizTab> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: QuizBottomTabItem(
              icon: Icons.home_rounded,
              label: labelHome,
              isActive: active == QuizTab.home,
              onTap: () => onTap(QuizTab.home),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: QuizBottomTabItem(
              icon: Icons.bar_chart_rounded,
              label: labelLeaderboard,
              isActive: active == QuizTab.leaderboard,
              onTap: () => onTap(QuizTab.leaderboard),
            ),
          ),
        ],
      ),
    );
  }
}
