import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../bloc/quiz_bloc.dart';
import '../data/data_sources/supabase_quiz_data_source.dart';
import '../data/repositories/supabase_quiz_repository.dart';
import '../domain/entities/quiz_player.dart';
import '../localization/quiz_strings.dart';
import '../presentation/pages/quiz_categories_page.dart';
import '../presentation/pages/quiz_leaderboard_page.dart';
import '../presentation/pages/quiz_question_page.dart';
import '../presentation/pages/quiz_result_page.dart';
import '../presentation/widgets/effects/quiz_backdrop_decor.dart';
import '../presentation/widgets/organisms/quiz_bottom_tab_bar.dart';
import '../presentation/widgets/organisms/quiz_config_dialog.dart';
import '../services/quiz_audio_service.dart';
import '../services/quiz_haptics_service.dart';
import '../theme/quiz_colors.dart';
import '../theme/quiz_theme.dart';
import 'rizo_quiz_config.dart';

/// Single entry point of `rizo_quiz`. Host opens it via Navigator.push.
///
/// Owns its own theme, navigator and BLoC — the host doesn't need to register
/// anything in DI or Theme.
class QuizEntry extends StatefulWidget {
  const QuizEntry({
    required this.supabaseClient,
    required this.player,
    this.config = const RizoQuizConfig(),
    this.contextBannerBuilder,
    this.onClose,
    super.key,
  });

  /// Initialized Supabase client from the host (`Supabase.instance.client`).
  final SupabaseClient supabaseClient;

  final QuizPlayer player;
  final RizoQuizConfig config;

  /// Optional banner widget shown above the question. Host decides content —
  /// e.g. "Searching for a driver…" in passenger app, "New offer" in driver app.
  final Widget? Function(BuildContext context)? contextBannerBuilder;

  /// Called when the user taps the close button on the categories screen.
  /// Defaults to `Navigator.pop`.
  final VoidCallback? onClose;

  @override
  State<QuizEntry> createState() => _QuizEntryState();
}

class _QuizEntryState extends State<QuizEntry> {
  late final QuizAudioService _audio = QuizAudioService(enabled: widget.config.soundEnabled);
  late final QuizHapticsService _haptics =
      QuizHapticsService(enabled: widget.config.vibrationEnabled);
  late final QuizBloc _bloc;

  late bool _soundEnabled = widget.config.soundEnabled;
  late bool _vibrationEnabled = widget.config.vibrationEnabled;

  @override
  void initState() {
    super.initState();
    _audio.warmUp();
    final repo = SupabaseQuizRepository(
      dataSource: SupabaseQuizDataSource(
        client: widget.supabaseClient,
        tablePrefix: widget.config.tablePrefix,
      ),
    );
    _bloc = QuizBloc(repository: repo, player: widget.player)
      ..add(const QuizLoadCategoriesEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    _audio.dispose();
    super.dispose();
  }

  void _toggleSound() {
    setState(() {
      _soundEnabled = !_soundEnabled;
      _audio.enabled = _soundEnabled;
    });
  }

  void _toggleVibration() {
    setState(() {
      _vibrationEnabled = !_vibrationEnabled;
      _haptics.enabled = _vibrationEnabled;
    });
    if (_vibrationEnabled) {
      _haptics.selection();
    }
  }

  void _openConfigDialog(BuildContext dialogContext) {
    showQuizConfigDialog(
      context: dialogContext,
      lang: widget.player.lang,
      soundEnabled: _soundEnabled,
      vibrationEnabled: _vibrationEnabled,
      onToggleSound: _toggleSound,
      onToggleVibration: _toggleVibration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.config.colors ?? QuizColors.defaults;
    return QuizColorsScope(
      colors: colors,
      child: Theme(
        data: QuizTheme.build(colors),
        child: BlocProvider.value(
          value: _bloc,
          child: _QuizNavigator(
            player: widget.player,
            audio: _audio,
            haptics: _haptics,
            contextBannerBuilder: widget.contextBannerBuilder,
            onClose: widget.onClose,
            onOpenConfig: _openConfigDialog,
          ),
        ),
      ),
    );
  }
}

class _QuizNavigator extends StatefulWidget {
  const _QuizNavigator({
    required this.player,
    required this.audio,
    required this.haptics,
    required this.contextBannerBuilder,
    required this.onClose,
    required this.onOpenConfig,
  });

  final QuizPlayer player;
  final QuizAudioService audio;
  final QuizHapticsService haptics;
  final Widget? Function(BuildContext context)? contextBannerBuilder;
  final VoidCallback? onClose;
  final void Function(BuildContext context) onOpenConfig;

  @override
  State<_QuizNavigator> createState() => _QuizNavigatorState();
}

class _QuizNavigatorState extends State<_QuizNavigator> {
  QuizTab _tab = QuizTab.home;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return BlocBuilder<QuizBloc, QuizGameState>(
      buildWhen: (a, b) => a.status != b.status,
      builder: (context, state) {
        return ColoredBox(
          color: bg,
          child: Stack(
            children: [
              const Positioned.fill(child: QuizBackdropDecor()),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: _bodyForStatus(state),
                bottomNavigationBar: _showTabBar(state)
                    ? SafeArea(
                        top: false,
                        child: QuizBottomTabBar(
                          active: _tab,
                          labelHome: QuizStrings.of(widget.player.lang).get('tab_home'),
                          labelLeaderboard:
                              QuizStrings.of(widget.player.lang).get('tab_leaderboard'),
                          onTap: _onTab,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  bool _showTabBar(QuizGameState state) {
    if (_tab == QuizTab.leaderboard) return true;
    return state.status == QuizStatus.idle ||
        state.status == QuizStatus.loadingCategories ||
        state.status == QuizStatus.categoriesLoaded ||
        state.status == QuizStatus.error;
  }

  void _closeEntry() {
    final cb = widget.onClose;
    if (cb != null) {
      cb();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Widget _bodyForStatus(QuizGameState state) {
    if (_tab == QuizTab.leaderboard) {
      return QuizLeaderboardPage(
        player: widget.player,
        onClose: _closeEntry,
      );
    }
    switch (state.status) {
      case QuizStatus.inProgress:
      case QuizStatus.answerRevealed:
      case QuizStatus.loadingQuestions:
        return QuizQuestionPage(
          lang: widget.player.lang,
          audioService: widget.audio,
          hapticsService: widget.haptics,
          contextBanner: widget.contextBannerBuilder?.call(context),
          onExit: () => context.read<QuizBloc>().add(const QuizExitRoundEvent()),
        );
      case QuizStatus.submittingScore:
      case QuizStatus.finished:
        return QuizResultPage(
          state: state,
          lang: widget.player.lang,
          onPlayAgain: () {
            final categoryId = state.activeCategoryId;
            if (categoryId != null) {
              context.read<QuizBloc>().add(QuizStartRoundEvent(categoryId: categoryId));
            }
          },
          onLeaderboard: () {
            context.read<QuizBloc>().add(const QuizLoadLeaderboardEvent());
            setState(() => _tab = QuizTab.leaderboard);
          },
          onHome: () => context.read<QuizBloc>().add(const QuizExitRoundEvent()),
        );
      case QuizStatus.idle:
      case QuizStatus.loadingCategories:
      case QuizStatus.categoriesLoaded:
      case QuizStatus.error:
        return QuizCategoriesPage(
          player: widget.player,
          onClose: _closeEntry,
          onAvatarTap: () => widget.onOpenConfig(context),
          onSelectCategory: (categoryId) {
            context.read<QuizBloc>().add(QuizStartRoundEvent(categoryId: categoryId));
          },
        );
    }
  }

  void _onTab(QuizTab tab) {
    if (tab == _tab) return;
    setState(() => _tab = tab);
    if (tab == QuizTab.leaderboard) {
      context.read<QuizBloc>().add(const QuizLoadLeaderboardEvent());
    }
  }
}
