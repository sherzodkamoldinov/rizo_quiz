import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Wrapper над `audioplayers` для коротких SFX из ассетов пакета.
///
/// Использует один [AudioPlayer] на эффект, чтобы события не вытесняли друг
/// друга (тик может зазвучать поверх правильного ответа).
class QuizAudioService {
  QuizAudioService({this.enabled = true});

  bool enabled;

  /// AudioCache с пустым префиксом: дефолтный `AudioCache.instance.prefix`
  /// равен `'assets/'`, что ломает загрузку cross-package ассетов вида
  /// `packages/rizo_quiz/assets/sounds/...` (Flutter регистрирует их без
  /// `assets/` в rootBundle). Свой кэш с `prefix: ''` подаёт точный ключ.
  final AudioCache _cache = AudioCache(prefix: '');

  final Map<_QuizSfx, AudioPlayer> _players = {};
  bool _audioContextConfigured = false;

  AudioPlayer _newPlayer() {
    final p = AudioPlayer();
    p.audioCache = _cache;
    return p;
  }

  /// Идемпотентно — повторные вызовы безопасны.
  Future<void> warmUp() async {
    if (!enabled) return;
    await _ensureAudioContext();
    for (final sfx in _QuizSfx.values) {
      final p = _players.putIfAbsent(sfx, _newPlayer);
      await p.setReleaseMode(ReleaseMode.stop);
      try {
        await p.setSource(AssetSource(sfx.assetPath));
      } on Object catch (e, st) {
        debugPrint('[QuizAudioService] warmUp ${sfx.assetPath} failed: $e\n$st');
      }
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

  /// iOS по умолчанию использует категорию `playAndRecord` или `ambient`,
  /// последняя глушит звук при физическом switch «без звука». Для игровых
  /// SFX выставляем `playback` + `mixWithOthers`, чтобы звуки играли даже
  /// в silent mode и не прерывали фоновую музыку пользователя.
  Future<void> _ensureAudioContext() async {
    if (_audioContextConfigured) return;
    try {
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.mixWithOthers},
          ),
          android: const AudioContextAndroid(
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.none,
          ),
        ),
      );
      _audioContextConfigured = true;
    } on Object catch (_) {
      // Не критично — продолжим с дефолтным контекстом.
    }
  }

  Future<void> _play(_QuizSfx sfx) async {
    if (!enabled) return;
    await _ensureAudioContext();
    final player = _players.putIfAbsent(sfx, _newPlayer);
    try {
      // Если source ещё не загружен (пропустили warmUp или iOS его сбросил),
      // загружаем сейчас. setSource идемпотентен по идентичному пути.
      await player.setSource(AssetSource(sfx.assetPath));
      await player.seek(Duration.zero);
      await player.resume();
    } on Object catch (e, st) {
      debugPrint('[QuizAudioService] play ${sfx.assetPath} failed: $e\n$st');
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
