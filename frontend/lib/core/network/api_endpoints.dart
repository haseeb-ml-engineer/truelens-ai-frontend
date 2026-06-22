import '../config/env_config.dart';

/// Centralized repository of all API endpoints used in the application.
///
/// This ensures no URLs are hardcoded in services and allows easy
/// switching between providers based on environment configuration.
class ApiEndpoints {
  ApiEndpoints._();

  // ---------------------------------------------------------------------------
  // Base URLs
  // ---------------------------------------------------------------------------

  /// Returns the base URL for the currently active provider.
  static String get activeBaseUrl {
    final provider = EnvConfig.activeProvider;
    switch (provider) {
      case 'gemini':
        return geminiBaseUrl;
      case 'openai':
        return openAiBaseUrl;
      case 'claude':
        return claudeBaseUrl;
      case 'truelens':
        return trueLensBaseUrl;
      default:
        // Fallback to TrueLens API as default
        return trueLensBaseUrl;
    }
  }

  // Provider-specific base URLs
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String claudeBaseUrl = 'https://api.anthropic.com/v1';
  
  /// The future TrueLens backend URL, currently loaded from environment config.
  static String get trueLensBaseUrl => EnvConfig.apiBaseUrl;

  // ---------------------------------------------------------------------------
  // Gemini Endpoints
  // ---------------------------------------------------------------------------
  
  /// Generates the Gemini inference endpoint for the configured model.
  static String get geminiGenerateContent =>
      '/models/${EnvConfig.activeModel}:generateContent';

  // ---------------------------------------------------------------------------
  // OpenAI Endpoints
  // ---------------------------------------------------------------------------
  
  static const String openAiChatCompletions = '/chat/completions';

  // ---------------------------------------------------------------------------
  // Claude Endpoints
  // ---------------------------------------------------------------------------
  
  static const String claudeMessages = '/messages';

  // ---------------------------------------------------------------------------
  // TrueLens Endpoints
  // ---------------------------------------------------------------------------
  
  static const String trueLensAnalyzeMedia = '/analysis/analyze';
  static const String trueLensHistory = '/analysis/history';
}
