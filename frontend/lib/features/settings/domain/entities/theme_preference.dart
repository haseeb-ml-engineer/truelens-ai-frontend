import '../../../../core/config/settings_config.dart';

/// Domain representation of the user's theme preference.
enum ThemePreference {
  light(SettingsConfig.themeLight),
  dark(SettingsConfig.themeDark),
  system(SettingsConfig.themeSystem);

  final String storageKey;

  const ThemePreference(this.storageKey);

  static ThemePreference fromKey(String key) {
    return values.firstWhere(
      (mode) => mode.storageKey == key,
      orElse: () => ThemePreference.system,
    );
  }
}
