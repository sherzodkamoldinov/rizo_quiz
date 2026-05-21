import 'package:flutter/services.dart';

/// Тонкая обёртка над [HapticFeedback] с runtime-флагом.
///
/// Создаётся в [QuizEntry] и пробрасывается в страницы. Без зависимостей,
/// использует системный haptics — на iOS это Taptic Engine, на Android —
/// стандартная вибрация.
class QuizHapticsService {
  QuizHapticsService({this.enabled = true});

  bool enabled;

  Future<void> selection() async {
    if (!enabled) return;
    await HapticFeedback.selectionClick();
  }

  Future<void> light() async {
    if (!enabled) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> medium() async {
    if (!enabled) return;
    await HapticFeedback.mediumImpact();
  }

  Future<void> heavy() async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
  }
}
