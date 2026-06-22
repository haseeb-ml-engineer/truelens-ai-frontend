import '../../../../core/config/settings_config.dart';
import '../../domain/entities/settings.dart';

/// Data transfer object for serializing [Settings] to and from Hive.
class SettingsModel {
  final String themeMode;
  final String selectedProvider;
  final Map<String, String> apiKeys;

  const SettingsModel({
    required this.themeMode,
    required this.selectedProvider,
    required this.apiKeys,
  });

  /// Creates a [SettingsModel] from the domain [Settings] entity.
  factory SettingsModel.fromEntity(Settings settings) {
    return SettingsModel(
      themeMode: settings.themeMode,
      selectedProvider: settings.selectedProvider,
      apiKeys: Map<String, String>.unmodifiable(settings.apiKeys),
    );
  }

  /// Creates a [SettingsModel] from a Hive box map.
  factory SettingsModel.fromHiveMap(Map<dynamic, dynamic> map) {
    return SettingsModel(
      themeMode: map[SettingsConfig.hiveKeyThemeMode] as String? ??
          SettingsConfig.themeSystem,
      selectedProvider: map[SettingsConfig.hiveKeySelectedProvider] as String? ??
          SettingsConfig.providerGemini,
      apiKeys: {
        SettingsConfig.providerGemini:
            map[SettingsConfig.hiveKeyApiKeyGemini] as String? ?? '',
        SettingsConfig.providerOpenAI:
            map[SettingsConfig.hiveKeyApiKeyOpenAI] as String? ?? '',
        SettingsConfig.providerClaude:
            map[SettingsConfig.hiveKeyApiKeyClaude] as String? ?? '',
      },
    );
  }

  /// Converts this model to the domain [Settings] entity.
  Settings toEntity() {
    return Settings(
      themeMode: themeMode,
      selectedProvider: selectedProvider,
      apiKeys: Map<String, String>.from(apiKeys),
    );
  }

  /// Converts this model to Hive-compatible field entries.
  Map<String, dynamic> toHiveMap() {
    return {
      SettingsConfig.hiveKeyThemeMode: themeMode,
      SettingsConfig.hiveKeySelectedProvider: selectedProvider,
      SettingsConfig.hiveKeyApiKeyGemini:
          apiKeys[SettingsConfig.providerGemini] ?? '',
      SettingsConfig.hiveKeyApiKeyOpenAI:
          apiKeys[SettingsConfig.providerOpenAI] ?? '',
      SettingsConfig.hiveKeyApiKeyClaude:
          apiKeys[SettingsConfig.providerClaude] ?? '',
    };
  }
}
