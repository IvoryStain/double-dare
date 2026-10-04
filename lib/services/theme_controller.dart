import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static const String _darkModeKey = 'dark_mode';

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  static Future<void> load() async {
    final prefs = SharedPreferencesAsync();

    final darkMode =
        await prefs.getBool(_darkModeKey) ?? false;

    themeMode.value =
        darkMode ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> setDarkMode(bool enabled) async {
    final prefs = SharedPreferencesAsync();

    await prefs.setBool(
      _darkModeKey,
      enabled,
    );

    themeMode.value =
        enabled ? ThemeMode.dark : ThemeMode.light;
  }

  static bool get isDarkMode {
    return themeMode.value == ThemeMode.dark;
  }
}
