import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Loops a single ambient track, exposed via [playing] for the app bar
/// control. Starts lazily on the first [toggle] call rather than at app
/// launch, since browsers block audio that isn't triggered by a user
/// gesture (a click) — starting it in main() gets silently blocked.
class BackgroundAudio {
  BackgroundAudio._();

  static final BackgroundAudio instance = BackgroundAudio._();

  final AudioPlayer _player = AudioPlayer();
  final ValueNotifier<bool> playing = ValueNotifier<bool>(false);
  bool _started = false;

  Future<void> toggle() async {
    if (!_started) {
      _started = true;
      try {
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.play(AssetSource('audio/background.mp3'), volume: 0.5);
        playing.value = true;
      } catch (e) {
        _started = false;
        debugPrint('Background audio failed to start: $e');
      }
      return;
    }

    if (playing.value) {
      await _player.pause();
      playing.value = false;
    } else {
      await _player.resume();
      playing.value = true;
    }
  }
}
