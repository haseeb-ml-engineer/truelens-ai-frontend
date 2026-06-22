import '../../../../core/config/settings_config.dart';

/// Domain entity representing all user-configurable application settings.
class Settings {
  /// The user's preferred theme mode key.
  final String themeMode;

  /// The selected AI provider key.
  final String selectedProvider;

  /// API keys keyed by [SettingsConfig] provider identifiers.
  final Map<String, String> apiKeys;

  const Settings({
    required this.themeMode,
    required this.selectedProvider,
    required this.apiKeys,
  });

  /// Default settings applied on first launch or when storage is unavailable.
  factory Settings.defaults() {
    return const Settings(
      themeMode: SettingsConfig.themeSystem,
      selectedProvider: SettingsConfig.providerGemini,
      apiKeys: {},
    );
  }

  /// Returns the API key for the given [providerKey], or an empty string.
  String apiKeyFor(String providerKey) => apiKeys[providerKey] ?? '';

  /// Whether the currently selected provider requires an API key.
  bool get selectedProviderRequiresApiKey =>
      SettingsConfig.apiKeyProviders.contains(selectedProvider);

  /// Whether the currently selected provider has a valid non-empty API key.
  bool get hasValidApiKeyForSelectedProvider {
    if (!selectedProviderRequiresApiKey) return true;
    final key = apiKeyFor(selectedProvider);
    return key.length >= SettingsConfig.apiKeyMinLength;
  }

  Settings copyWith({
    String? themeMode,
    String? selectedProvider,
    Map<String, String>? apiKeys,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      apiKeys: apiKeys ?? this.apiKeys,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          themeMode == other.themeMode &&
          selectedProvider == other.selectedProvider &&
          _mapEquals(apiKeys, other.apiKeys);

  @override
  int get hashCode =>
      Object.hash(themeMode, selectedProvider, Object.hashAll(apiKeys.entries));

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
