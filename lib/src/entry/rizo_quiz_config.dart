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
    this.colors,
    this.tablePrefix = 'quiz_',
  });

  /// SFX playback enabled by default. Apps may flip this from a settings screen.
  final bool soundEnabled;

  /// Override the design palette. Pass `null` to use [QuizColors.defaults].
  final QuizColors? colors;

  /// Prefix for Supabase tables (`{prefix}categories`, `{prefix}questions`,
  /// `{prefix}leaderboard`). Defaults to `quiz_`.
  final String tablePrefix;
}
