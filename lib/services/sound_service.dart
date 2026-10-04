import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static const String _enabledKey = 'sound_effects_enabled';

  static final AudioPlayer _player = AudioPlayer();
  static final ValueNotifier<bool> enabledNotifier = ValueNotifier<bool>(true);

  static bool get enabled => enabledNotifier.value;

  static Future<void> initialise() async {
    final prefs = await SharedPreferences.getInstance();
    enabledNotifier.value = prefs.getBool(_enabledKey) ?? true;
  }

  static Future<void> setEnabled(bool enabled) async {
    enabledNotifier.value = enabled;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);

    if (!enabled) {
      await _player.stop();
    }
  }

  static Future<void> playCardDraw() async {
    await _play('sounds/card_draw.mp3');
  }

  static Future<void> playSend() async {
    await _play('sounds/send_whoosh.mp3');
  }

  static Future<void> playIncomingSlap() async {
    await _play('sounds/incoming_slap.mp3');
  }

  static Future<void> playResolve() async {
    await _play('sounds/resolve_ping.mp3');
  }

  static Future<void> _play(String assetPath) async {
    if (!enabled) {
      return;
    }

    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath), volume: 0.75);
    } catch (error) {
      debugPrint('SOUND ERROR ($assetPath): $error');
    }
  }
}
