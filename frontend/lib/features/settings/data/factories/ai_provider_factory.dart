import '../../../../core/api/analysis_provider.dart';
import '../../../../core/api/providers/claude_provider.dart';
import '../../../../core/api/providers/gemini_provider.dart';
import '../../../../core/api/providers/openai_provider.dart';
import '../../../../core/api/providers/truelens_provider.dart';
import '../../../../core/config/provider_config.dart';
import '../../../../core/config/settings_config.dart';
import '../../domain/entities/settings.dart';

/// Resolves the correct [AnalysisProvider] from the current [Settings] snapshot.
///
/// Lives in the settings data layer so core API code never depends on
/// feature domain entities.
class AiProviderFactory {
  AiProviderFactory._();

  /// Creates the [AnalysisProvider] matching [settings.selectedProvider].
  static AnalysisProvider create(Settings settings) {
    final providerType =
        ProviderType.tryParse(settings.selectedProvider) ?? ProviderType.gemini;

    switch (providerType) {
      case ProviderType.gemini:
        return GeminiProvider(
          apiKey: settings.apiKeyFor(SettingsConfig.providerGemini),
        );
      case ProviderType.openAI:
        return OpenAIProvider(
          apiKey: settings.apiKeyFor(SettingsConfig.providerOpenAI),
        );
      case ProviderType.claude:
        return ClaudeProvider(
          apiKey: settings.apiKeyFor(SettingsConfig.providerClaude),
        );
      case ProviderType.trueLens:
        return TrueLensProvider(
          apiKey: settings.apiKeyFor(SettingsConfig.providerTrueLens),
        );
    }
  }

  /// Returns whether [providerKey] maps to a known provider.
  static bool isValidProvider(String providerKey) {
    return ProviderType.tryParse(providerKey) != null;
  }

  /// Returns a user-facing message when the active provider is misconfigured.
  static String? configurationMessage(Settings settings) {
    if (!isValidProvider(settings.selectedProvider)) {
      return 'The selected AI provider is not recognized.';
    }

    if (settings.selectedProviderRequiresApiKey &&
        !settings.hasValidApiKeyForSelectedProvider) {
      final providerType = ProviderType.tryParse(settings.selectedProvider);
      final name = providerType?.displayName ?? settings.selectedProvider;
      return 'An API key is required for $name. Add one in Settings.';
    }

    return null;
  }
}
