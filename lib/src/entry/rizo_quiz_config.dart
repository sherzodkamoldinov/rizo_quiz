import 'package:flutter/foundation.dart';

import '../theme/quiz_colors.dart';

/// Tunables for the package — passed to [QuizEntry].
///
/// Sensible defaults; pass overrides only when the host needs custom theming
/// or a custom Supabase table layout.
@immutable
class RizoQuizConfig {
  const RizoQuizConfig({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.colors,
    this.tablePrefix = 'quiz_',
  });

  /// SFX playback enabled by default. Apps may flip this from a settings screen.
  final bool soundEnabled;

  /// Haptic feedback enabled by default. Игрок может переключать из диалога
  /// настроек внутри квиза, но изменение не персистится между сессиями.
  final bool vibrationEnabled;

  /// Override the design palette. Pass `null` to use [QuizColors.defaults].
  final QuizColors? colors;

  /// Prefix for Supabase tables (`{prefix}categories`, `{prefix}questions`,
  /// `{prefix}leaderboard`). Defaults to `quiz_`.
  final String tablePrefix;
}
