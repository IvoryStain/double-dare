import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController {
  static const String _languageKey = 'language';

  static final ValueNotifier<String> language =
      ValueNotifier('en');

  static const Map<String, String> languages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'pt': 'Português',
    'zh': '简体中文',
  };

  static Future<void> load() async {
    final prefs = SharedPreferencesAsync();

    final savedLanguage =
        await prefs.getString(_languageKey);

    if (savedLanguage != null &&
        languages.containsKey(savedLanguage)) {
      language.value = savedLanguage;
    }
  }

  static Future<void> setLanguage(
    String languageCode,
  ) async {
    if (!languages.containsKey(languageCode)) {
      return;
    }

    final prefs = SharedPreferencesAsync();

    await prefs.setString(
      _languageKey,
      languageCode,
    );

    language.value = languageCode;
  }

  static String get current {
    return language.value;
  }

  static String get currentName {
    return languages[current] ?? 'English';
  }
}
