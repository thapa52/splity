import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Manages the app theme mode (light/dark/system).
///
/// Persists the user's preference using SharedPreferences
/// so it survives app restarts.
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const String _themeKey = 'is_dark_mode';

  @override
  ThemeMode build() {
    // Load saved preference asynchronously
    Future.microtask(() => _loadTheme());
    return ThemeMode.system; // default until loaded
  }

  /// Loads saved theme from SharedPreferences.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey);

    if (isDark == null) {
      // No preference saved — use system
      state = ThemeMode.system;
    } else {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  /// Toggles between light and dark mode.
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      await prefs.setBool(_themeKey, false);
    } else {
      state = ThemeMode.dark;
      await prefs.setBool(_themeKey, true);
    }
  }

  /// Sets a specific theme mode.
  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    state = mode;

    if (mode == ThemeMode.system) {
      await prefs.remove(_themeKey);
    } else {
      await prefs.setBool(_themeKey, mode == ThemeMode.dark);
    }
  }
}
