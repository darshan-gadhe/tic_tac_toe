import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A static class to manage all sound-related functionality.
class SoundService {
  // A single, shared audio player instance for the whole app.
  static final AudioPlayer _audioPlayer = AudioPlayer();

  // A static variable to hold the current sound preference in memory.
  static bool _soundEnabled = true;

  // The key used to save the preference on the device's local storage.
  static const _soundKey = 'sound_enabled';

  /// Initializes the service. Call this once when the app starts to load
  /// the user's saved sound preference.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // Load the preference, defaulting to 'true' (on) if it's never been set.
    _soundEnabled = prefs.getBool(_soundKey) ?? true;
  }

  /// Returns the current sound status.
  static bool isSoundEnabled() => _soundEnabled;

  /// Toggles the sound on or off and saves the new preference to local storage.
  static Future<void> toggleSound(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = enabled;
    await prefs.setBool(_soundKey, enabled);
  }

  /// Plays the tile tap sound if sound is enabled.
  static void playClickSound() {
    if (_soundEnabled) {
      // We don't wait for the sound to finish, just fire and forget.
      _audioPlayer.play(AssetSource('sounds/click.mp3'));
    }
  }

  /// Plays the win sound if sound is enabled.
  static void playWinSound() {
    if (_soundEnabled) {
      _audioPlayer.play(AssetSource('sounds/win.mp3'));
    }
  }

  /// Plays the draw sound if sound is enabled.
  static void playDrawSound() {
    if (_soundEnabled) {
      _audioPlayer.play(AssetSource('sounds/draw.mp3'));
    }
  }
}