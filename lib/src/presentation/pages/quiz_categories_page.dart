import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz_bloc.dart';
import '../../domain/entities/quiz_player.dart';
import '../../localization/quiz_strings.dart';
import '../../theme/quiz_colors.dart';
import '../../theme/quiz_radii.dart';
import '../widgets/atoms/quiz_circle_icon_button.dart';
import '../widgets/atoms/quiz_eyebrow.dart';
import '../widgets/atoms/quiz_serif_heading.dart';
import '../widgets/molecules/quiz_header_bar.dart';
import '../widgets/organisms/quiz_categories_grid.dart';
import '../widgets/organisms/quiz_categories_grid_skeleton.dart';

/// Главный экран — приветствие, hero, сетка категорий.
class QuizCategoriesPage extends StatelessWidget {
  const QuizCategoriesPage({
    required this.player,
    required this.onSelectCategory,
    this.onClose,
    super.key,
  });

  final QuizPlayer player;
  final ValueChanged<String> onSelectCategory;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = QuizColorsScope.of(context);
    final strings = QuizStrings.of(player.lang);

    return BlocBuilder<QuizBloc, QuizGameState>(
      buildWhen: (a, b) => a.status != b.status || a.categories != b.categories,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                QuizRadii.contentPadding,
                12,
                QuizRadii.contentPadding,
                24,
              ),
              children: [
                QuizHeaderBar(
                  greeting: strings.get('hello'),
                  name: player.displayName.isEmpty ? strings.get('guest') : player.displayName,
                  trailing: onClose == null
                      ? null
                      : QuizCircleIconButton(
                          icon: Icons.close_rounded,
                          onTap: onClose!,
                        ),
                ),
                const SizedBox(height: 28),
                QuizEyebrow(strings.get('eyebrow_round')),
                const SizedBox(height: 10),
                QuizSerifHeading(
                  text: strings.get('hero_title_part_1'),
                  accent: strings.get('hero_title_part_2'),
                ),
                const SizedBox(height: 14),
                Text(
                  strings.get('hero_subtitle'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.ink2),
                ),
                const SizedBox(height: 24),
                QuizSerifHeading(
                  text: strings.get('section_categories'),
                  variant: QuizHeadingVariant.section,
                ),
                const SizedBox(height: 14),
                if (state.status == QuizStatus.loadingCategories &&
                    state.categories.isEmpty)
                  const QuizCategoriesGridSkeleton()
                else
                  QuizCategoriesGrid(
                    categories: state.categories,
                    onTap: onSelectCategory,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
