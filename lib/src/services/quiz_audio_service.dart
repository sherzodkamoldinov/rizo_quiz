import 'package:audioplayers/audioplayers.dart';

/// Wrapper над `audioplayers` для коротких SFX из ассетов пакета.
///
/// Использует один [AudioPlayer] на эффект, чтобы события не вытесняли друг
/// друга (тик может зазвучать поверх правильного ответа).
class QuizAudioService {
  QuizAudioService({this.enabled = true});

  bool enabled;

  final Map<_QuizSfx, AudioPlayer> _players = {};

  /// Идемпотентно — повторные вызовы безопасны.
  Future<void> warmUp() async {
    if (!enabled) return;
    for (final sfx in _QuizSfx.values) {
      _players.putIfAbsent(sfx, AudioPlayer.new);
    }
  }

  Future<void> playTick() => _play(_QuizSfx.tick);
  Future<void> playSelect() => _play(_QuizSfx.select);
  Future<void> playCorrect() => _play(_QuizSfx.correct);
  Future<void> playWrong() => _play(_QuizSfx.wrong);
  Future<void> playFinish() => _play(_QuizSfx.finish);

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }

  Future<void> _play(_QuizSfx sfx) async {
    if (!enabled) return;
    final player = _players.putIfAbsent(sfx, AudioPlayer.new);
    try {
      await player.stop();
      await player.play(AssetSource(sfx.assetPath));
    } on Object catch (_) {
      // Игнорируем сбои — звук не критичен.
    }
  }
}

enum _QuizSfx {
  tick('packages/rizo_quiz/assets/sounds/tick.mp3'),
  select('packages/rizo_quiz/assets/sounds/select.mp3'),
  correct('packages/rizo_quiz/assets/sounds/correct.mp3'),
  wrong('packages/rizo_quiz/assets/sounds/wrong.mp3'),
  finish('packages/rizo_quiz/assets/sounds/finish.mp3');

  const _QuizSfx(this.assetPath);

  final String assetPath;
}
