/// Central configuration for the Settings module.
///
/// Contains Hive box identifiers, persistence field keys, provider identifiers,
/// theme modes, and API key validation rules.
class SettingsConfig {
  SettingsConfig._();

  // ---------------------------------------------------------------------------
  // Hive Storage
  // ---------------------------------------------------------------------------

  /// Hive box for storing user settings.
  static const String settingsBox = 'app_settings_box';

  /// Hive field key for the persisted theme mode.
  static const String hiveKeyThemeMode = 'theme_mode';

  /// Hive field key for the selected AI provider.
  static const String hiveKeySelectedProvider = 'selected_provider';

  /// Hive field key for the Gemini API key.
  static const String hiveKeyApiKeyGemini = 'api_key_gemini';

  /// Hive field key for the OpenAI API key.
  static const String hiveKeyApiKeyOpenAI = 'api_key_openai';

  /// Hive field key for the Claude API key.
  static const String hiveKeyApiKeyClaude = 'api_key_claude';

  // ---------------------------------------------------------------------------
  // AI Provider Identifiers
  // ---------------------------------------------------------------------------

  static const String providerGemini = 'gemini';
  static const String providerOpenAI = 'openai';
  static const String providerClaude = 'claude';
  static const String providerTrueLens = 'truelens';

  /// Providers that require a user-supplied API key.
  static const List<String> apiKeyProviders = [
    providerGemini,
    providerOpenAI,
    providerClaude,
  ];

  // ---------------------------------------------------------------------------
  // Theme Modes
  // ---------------------------------------------------------------------------

  static const String themeSystem = 'system';
  static const String themeLight = 'light';
  static const String themeDark = 'dark';

  // ---------------------------------------------------------------------------
  // API Key Validation
  // ---------------------------------------------------------------------------

  /// Minimum acceptable length for a stored API key.
  static const int apiKeyMinLength = 8;

  /// Maximum acceptable length for a stored API key.
  static const int apiKeyMaxLength = 256;

  /// Number of trailing characters shown in masked key display.
  static const int apiKeyVisibleSuffixLength = 4;
}
