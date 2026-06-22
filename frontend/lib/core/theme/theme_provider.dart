import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the app's theme mode (light, dark, system).
///
/// Persists the user's choice so it can later be saved to
/// SharedPreferences for cross-session persistence.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  /// Switch to light mode.
  void setLightMode() => state = ThemeMode.light;

  /// Switch to dark mode.
  void setDarkMode() => state = ThemeMode.dark;

  /// Follow the system theme.
  void setSystemMode() => state = ThemeMode.system;

  /// Toggle between light and dark.
  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
  }

  /// Check if dark mode is active (explicit or system).
  bool isDarkMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}

/// Global provider for the theme mode.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);