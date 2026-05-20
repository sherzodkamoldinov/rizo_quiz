import 'package:flutter/material.dart';

/// Design tokens — colors. Matches `design_handoff_rizo_quiz/mobile-styles.css`.
@immutable
class QuizColors {
  const QuizColors({
    this.bg = const Color(0xFFFAF9F5),
    this.bg2 = const Color(0xFFF0EDE3),
    this.bg3 = const Color(0xFFE8E4D5),
    this.card = const Color(0xFFFFFFFF),
    this.cardWarm = const Color(0xFFF5F1E8),
    this.ink = const Color(0xFF0B184B),
    this.ink2 = const Color(0xFF2A3568),
    this.mute = const Color(0xFF8C8A82),
    this.mute2 = const Color(0xFFB8B5A8),
    this.line = const Color(0xFFE2DDCD),
    this.line2 = const Color(0xFFD4CFB8),
    this.clay = const Color(0xFF3DA5B8),
    this.clay2 = const Color(0xFF2A8090),
    this.claySoft = const Color(0xFFD9ECF0),
    this.ok = const Color(0xFF6A8F4D),
    this.okSoft = const Color(0xFFE6EBD8),
    this.okBorder = const Color(0xFFB4C99B),
    this.no = const Color(0xFFB4513F),
    this.noSoft = const Color(0xFFF2DDD6),
    this.noBorder = const Color(0xFFDFB9AB),
    this.warn = const Color(0xFFFBEEDD),
    this.warnBorder = const Color(0xFFE8C9A1),
    this.warnText = const Color(0xFF8A5A1E),
    this.rank3Bg = const Color(0xFFD9ECF0),
    this.rank3Border = const Color(0xFFE2C9BC),
  });

  /// Default palette from design tokens.
  static const QuizColors defaults = QuizColors();

  final Color bg;
  final Color bg2;
  final Color bg3;
  final Color card;
  final Color cardWarm;
  final Color ink;
  final Color ink2;
  final Color mute;
  final Color mute2;
  final Color line;
  final Color line2;
  final Color clay;
  final Color clay2;
  final Color claySoft;
  final Color ok;
  final Color okSoft;
  final Color okBorder;
  final Color no;
  final Color noSoft;
  final Color noBorder;
  final Color warn;
  final Color warnBorder;
  final Color warnText;
  final Color rank3Bg;
  final Color rank3Border;
}

/// InheritedWidget exposing [QuizColors] to descendants.
class QuizColorsScope extends InheritedWidget {
  const QuizColorsScope({
    required this.colors,
    required super.child,
    super.key,
  });

  final QuizColors colors;

  static QuizColors of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<QuizColorsScope>();
    return scope?.colors ?? QuizColors.defaults;
  }

  @override
  bool updateShouldNotify(QuizColorsScope oldWidget) => colors != oldWidget.colors;
}
