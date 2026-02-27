import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple global controller for app theme.
/// Persists the choice in SharedPreferences under the key 'dark_mode'.
class ThemeController {
  static final ThemeController instance = ThemeController._internal();

  ThemeController._internal();

  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static const _prefKey = 'dark_mode';

  /// Load saved theme from SharedPreferences.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_prefKey) ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Set dark mode on/off and persist the choice.
  Future<void> setDarkMode(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, isDark);
  }
}

