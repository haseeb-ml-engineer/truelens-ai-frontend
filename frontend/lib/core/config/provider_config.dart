import 'settings_config.dart';

enum ProviderType {
  gemini(SettingsConfig.providerGemini, 'Google Gemini', 'gemini-3.1-pro'),
  openAI(SettingsConfig.providerOpenAI, 'OpenAI', 'gpt-4.5-turbo'),
  claude(SettingsConfig.providerClaude, 'Anthropic Claude', 'claude-3.7-sonnet'),
  trueLens(SettingsConfig.providerTrueLens, 'TrueLens AI', 'truelens-1.0');

  final String key;
  final String displayName;
  final String defaultModel;

  const ProviderType(this.key, this.displayName, this.defaultModel);

  /// Returns the matching provider, or `null` when [key] is unknown.
  static ProviderType? tryParse(String key) {
    for (final provider in values) {
      if (provider.key == key) return provider;
    }
    return null;
  }

  static ProviderType fromKey(String key) {
    return tryParse(key) ?? ProviderType.gemini;
  }
}
