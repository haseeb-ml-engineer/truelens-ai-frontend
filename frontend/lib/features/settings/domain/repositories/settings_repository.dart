import '../../../../core/utils/result.dart';
import '../entities/settings.dart';

/// Contract for persisting and retrieving application settings.
abstract class SettingsRepository {
  /// Loads settings from local storage.
  ///
  /// Returns [Settings.defaults] wrapped in [Success] when no data exists.
  Future<Result<Settings>> loadSettings();

  /// Persists the complete [settings] snapshot.
  Future<Result<Settings>> saveSettings(Settings settings);

  /// Updates only the theme mode.
  Future<Result<Settings>> updateThemeMode(String themeMode);

  /// Updates only the selected AI provider.
  Future<Result<Settings>> updateSelectedProvider(String providerKey);

  /// Updates a single provider API key using [current] as the base snapshot.
  Future<Result<Settings>> updateApiKey({
    required String providerKey,
    required String apiKey,
    required Settings current,
  });
}
