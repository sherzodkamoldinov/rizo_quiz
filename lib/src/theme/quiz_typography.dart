import 'package:flutter/material.dart';

/// Design tokens — typography.
///
/// Fonts are bundled inside the `rizo_quiz` package. Every TextStyle declares
/// `package: _package` so the host app resolves the asset path correctly,
/// even if its own pubspec doesn't list these families.
class QuizTypography {
  const QuizTypography._();

  static const String _package = 'rizo_quiz';

  static const String serif = 'SourceSerif4';
  static const String sans = 'Geist';
  static const String mono = 'JetBrainsMono';

  // ─── Display / Headlines ────────────────────────────────────────────────
  static const TextStyle displayH1 = TextStyle(
    fontFamily: serif,
    package: _package,
    fontSize: 42,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.05, // -0.025em
    height: 1.05,
  );

  static const TextStyle questionText = TextStyle(
    fontFamily: serif,
    package: _package,
    fontSize: 30,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6, // -0.02em
    height: 1.12,
  );

  static const TextStyle sectionH2 = TextStyle(
    fontFamily: serif,
    package: _package,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.44,
  );

  static const TextStyle scoreBig = TextStyle(
    fontFamily: serif,
    package: _package,
    fontSize: 76,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  // ─── Body ──────────────────────────────────────────────────────────────
  static const TextStyle body = TextStyle(
    fontFamily: sans,
    package: _package,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: sans,
    package: _package,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: sans,
    package: _package,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle optionLabel = TextStyle(
    fontFamily: sans,
    package: _package,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: serif,
    package: _package,
    fontSize: 19,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: sans,
    package: _package,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // ─── Mono ──────────────────────────────────────────────────────────────
  static const TextStyle eyebrow = TextStyle(
    fontFamily: mono,
    package: _package,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.98, // 0.18em
  );

  static const TextStyle eyebrowSmall = TextStyle(
    fontFamily: mono,
    package: _package,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.8,
  );

  static const TextStyle monoTimer = TextStyle(
    fontFamily: mono,
    package: _package,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle monoLabel = TextStyle(
    fontFamily: mono,
    package: _package,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle monoMeta = TextStyle(
    fontFamily: mono,
    package: _package,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ─── Specialty ─────────────────────────────────────────────────────────
  static const TextStyle categoryGlyph = TextStyle(
    fontFamily: serif,
    package: _package,
    fontSize: 38,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  static const TextStyle leaderScore = TextStyle(
    fontFamily: serif,
    package: _package,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );
}
