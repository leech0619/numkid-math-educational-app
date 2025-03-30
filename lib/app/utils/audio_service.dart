import 'package:audioplayers/audioplayers.dart';

/// Manages audio playback for background music and sound effects.
class AudioService {
  static final AudioService _instance =
      AudioService._internal(); // Singleton instance
  factory AudioService() => _instance;

  final AudioPlayer _backgroundPlayer =
      AudioPlayer(); // Player for background music
  final AudioPlayer _effectPlayer = AudioPlayer(); // Player for sound effects

  AudioService._internal();

  /// Plays the background music in a loop.
  Future<void> playBackgroundMusic() async {
    await _backgroundPlayer.stop(); // Stop any currently playing music
    await _backgroundPlayer.setVolume(0.4); // Set volume to 40%
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
    await _backgroundPlayer.play(AssetSource('audio/background_music.mp3'));
  }

  /// Plays the arcade mode music in a loop.
  Future<void> playArcadeMusic() async {
    await _backgroundPlayer.stop(); // Stop any currently playing music
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
    await _backgroundPlayer.play(AssetSource('audio/arcade_music.mp3'));
  }

  /// Pauses the background music.
  Future<void> pauseBackgroundMusic() async {
    await _backgroundPlayer.pause();
  }

  /// Resumes the background music.
  Future<void> resumeBackgroundMusic() async {
    await _backgroundPlayer.resume();
  }

  /// Stops the background music.
  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }

  /// Plays a sound effect and resumes background music after it finishes.
  Future<void> playSoundEffect() async {
    await _effectPlayer.play(AssetSource('audio/correct_sound_effect.mp3'));
    _effectPlayer.onPlayerComplete.listen((event) async {
      await _backgroundPlayer.resume(); // Resume background music
    });
  }
}
