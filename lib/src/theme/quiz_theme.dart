import 'package:flutter/material.dart';

import 'quiz_colors.dart';
import 'quiz_typography.dart';

/// Builds a [ThemeData] from package design tokens. Used inside [QuizEntry]
/// so the package renders identically in any host app.
class QuizTheme {
  const QuizTheme._();

  static ThemeData build(QuizColors colors) {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: colors.clay,
      onPrimary: Colors.white,
      secondary: colors.ink,
      onSecondary: colors.bg,
      error: colors.no,
      onError: Colors.white,
      surface: colors.card,
      onSurface: colors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.bg,
      // ThemeData uses fully-qualified `packages/<pkg>/<family>` form because
      // there's no `package` field here. Inline `QuizTypography.*` styles use
      // the `package` parameter directly.
      fontFamily: 'packages/rizo_quiz/${QuizTypography.sans}',
      splashFactory: InkRipple.splashFactory,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.clay,
        selectionColor: colors.claySoft,
        selectionHandleColor: colors.clay,
      ),
      iconTheme: IconThemeData(color: colors.ink),
      dividerTheme: DividerThemeData(color: colors.line, thickness: 1),
      textTheme: const TextTheme(
        displayLarge: QuizTypography.displayH1,
        headlineLarge: QuizTypography.questionText,
        headlineMedium: QuizTypography.sectionH2,
        titleLarge: QuizTypography.cardTitle,
        bodyLarge: QuizTypography.body,
        bodyMedium: QuizTypography.body,
        bodySmall: QuizTypography.bodySmall,
        labelLarge: QuizTypography.optionLabel,
        labelSmall: QuizTypography.eyebrow,
      ),
    );
  }
}
