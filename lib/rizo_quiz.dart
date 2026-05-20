/// Rizo Quiz — shared quiz game package.
///
/// Single entry point: [QuizEntry].
///
/// Example (any host app):
/// ```dart
/// Navigator.of(context).push(MaterialPageRoute(
///   builder: (_) => QuizEntry(
///     supabaseClient: Supabase.instance.client,
///     player: const QuizPlayer(userId: '...', displayName: 'Sherzod', lang: 'ru'),
///     contextBannerBuilder: (ctx) => MyHostBanner(),
///   ),
/// ));
/// ```
library;

// ─── Public API ──────────────────────────────────────────────────────────────
export 'src/entry/quiz_entry.dart' show QuizEntry;
export 'src/entry/rizo_quiz_config.dart' show RizoQuizConfig;
export 'src/domain/entities/quiz_player.dart' show QuizPlayer;

// Theme primitives — only QuizColors is needed for host customization.
export 'src/theme/quiz_colors.dart' show QuizColors;

// Repository interface — host may swap in a custom impl (tests, other backend).
export 'src/domain/repositories/quiz_repository.dart' show QuizRepository;

// Entities — re-exported for hosts that want to compose UI around quiz data
// (e.g. show last leaderboard entry on home screen).
export 'src/domain/entities/quiz_category.dart' show QuizCategory;
export 'src/domain/entities/quiz_category_best.dart' show QuizCategoryBest;
export 'src/domain/entities/quiz_question.dart' show QuizQuestion, QuizQuestionType;
export 'src/domain/entities/quiz_leaderboard_entry.dart' show QuizLeaderboardEntry;
