import 'package:flutter/material.dart';

import '../../domain/entities/theme_preference.dart';

/// Maps domain [ThemePreference] keys to Flutter [ThemeMode] values.
class ThemeModeMapper {
  ThemeModeMapper._();

  static ThemeMode fromStorageKey(String themeModeKey) {
    switch (ThemePreference.fromKey(themeModeKey)) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
    }
  }
}
