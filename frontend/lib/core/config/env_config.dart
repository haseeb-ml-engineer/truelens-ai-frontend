import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed, null-safe wrapper around environment variables loaded via flutter_dotenv.
///
/// Exposes every environment variable as a strongly-typed static getter.
/// Must be initialized by calling [init] before accessing any property.
///
/// Usage:
/// ```dart
/// await EnvConfig.init();
/// final key = EnvConfig.geminiApiKey;
/// ```
class EnvConfig {
  EnvConfig._();

  /// Whether the environment has been successfully initialized.
  static bool _initialized = false;

  /// Loads the environment file and marks the config as initialized.
  ///
  /// Defaults to `.env.dev` if no [fileName] is provided.
  /// Handles missing files gracefully by logging a warning and
  /// allowing the app to continue with default values.
  static Future<void> init({String fileName = '.env.dev'}) async {
    try {
      await dotenv.load(fileName: fileName);
      _initialized = true;
    } catch (e) {
      _initialized = false;
      // Log but don't crash — defaults will be used.
      // ignore: avoid_print
      print('[EnvConfig] Warning: Could not load $fileName — $e');
      // ignore: avoid_print
      print('[EnvConfig] Falling back to default configuration values.');
    }
  }

  // ---------------------------------------------------------------------------
  // LLM Provider API Keys
  // ---------------------------------------------------------------------------

  /// API key for Google Gemini.
  ///
  /// Required when [activeProvider] is `gemini`.
  static String get geminiApiKey => _getString('GEMINI_API_KEY', '');

  /// API key for OpenAI.
  ///
  /// Required when [activeProvider] is `openai`.
  static String get openaiApiKey => _getString('OPENAI_API_KEY', '');

  /// API key for Anthropic Claude.
  ///
  /// Required when [activeProvider] is `claude`.
  static String get claudeApiKey => _getString('CLAUDE_API_KEY', '');

  // ---------------------------------------------------------------------------
  // Active Provider & Model
  // ---------------------------------------------------------------------------

  /// The currently active LLM provider identifier.
  ///
  /// Must be one of: `gemini`, `openai`, `claude`.
  static String get activeProvider =>
      _getString('ACTIVE_PROVIDER', 'gemini').toLowerCase();

  /// The specific model identifier for the active provider.
  ///
  /// Examples: `gemini-2.5-flash`, `gpt-4o`, `claude-sonnet-4-20250514`.
  static String get activeModel =>
      _getString('ACTIVE_MODEL', 'gemini-2.5-flash');

  /// Returns the API key for the currently active provider.
  ///
  /// Throws [EnvironmentConfigException] if the active provider's key
  /// is empty or set to a placeholder value.
  static String get activeProviderApiKey {
    final String key;
    switch (activeProvider) {
      case 'gemini':
        key = geminiApiKey;
      case 'openai':
        key = openaiApiKey;
      case 'claude':
        key = claudeApiKey;
      default:
        throw EnvironmentConfigException(
          'Unknown provider "$activeProvider". '
          'Supported providers: gemini, openai, claude.',
        );
    }

    if (key.isEmpty || key.startsWith('your_')) {
      throw EnvironmentConfigException(
        'API key for provider "$activeProvider" is not configured. '
        'Set the corresponding key in your .env file.',
      );
    }

    return key;
  }

  // ---------------------------------------------------------------------------
  // API Configuration
  // ---------------------------------------------------------------------------

  /// Base URL for the TrueLens backend API.
  static String get apiBaseUrl =>
      _getString('API_BASE_URL', 'https://api.truelens.ai/v1');

  /// HTTP request timeout as a [Duration].
  static Duration get requestTimeout =>
      Duration(seconds: _getInt('REQUEST_TIMEOUT_SECONDS', 60));

  /// Maximum upload file size in bytes.
  static int get maxUploadSizeBytes =>
      _getInt('MAX_UPLOAD_SIZE_MB', 50) * 1024 * 1024;

  // ---------------------------------------------------------------------------
  // Feature Flags
  // ---------------------------------------------------------------------------

  /// Whether video analysis is enabled.
  static bool get enableVideoAnalysis =>
      _getBool('ENABLE_VIDEO_ANALYSIS', true);

  /// Whether PDF report export is enabled.
  static bool get enablePdfExport => _getBool('ENABLE_PDF_EXPORT', false);

  /// Whether cloud sync is enabled.
  static bool get enableCloudSync => _getBool('ENABLE_CLOUD_SYNC', false);

  /// Whether developer mode is enabled.
  ///
  /// Enables debug logs, provider info overlays, and raw JSON inspection.
  static bool get enableDeveloperMode =>
      _getBool('ENABLE_DEVELOPER_MODE', false);

  // ---------------------------------------------------------------------------
  // Debug
  // ---------------------------------------------------------------------------

  /// Whether verbose debug logging is enabled.
  static bool get enableDebugLogging =>
      _getBool('ENABLE_DEBUG_LOGGING', false);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns a string env variable, or [defaultValue] if not set or not initialized.
  static String _getString(String key, String defaultValue) {
    if (!_initialized) return defaultValue;
    final value = dotenv.env[key];
    return (value != null && value.isNotEmpty) ? value : defaultValue;
  }

  /// Returns an integer env variable, or [defaultValue] if not set or not parseable.
  static int _getInt(String key, int defaultValue) {
    if (!_initialized) return defaultValue;
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  /// Returns a boolean env variable, or [defaultValue] if not set.
  ///
  /// Recognizes `true`, `1`, `yes` (case-insensitive) as truthy values.
  static bool _getBool(String key, bool defaultValue) {
    if (!_initialized) return defaultValue;
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) return defaultValue;
    return value.toLowerCase() == 'true' ||
        value == '1' ||
        value.toLowerCase() == 'yes';
  }
}

/// Exception thrown when an environment configuration value
/// is missing, invalid, or otherwise unusable.
class EnvironmentConfigException implements Exception {
  /// A human-readable description of the configuration error.
  final String message;

  /// Creates an [EnvironmentConfigException] with the given [message].
  const EnvironmentConfigException(this.message);

  @override
  String toString() => 'EnvironmentConfigException: $message';
}
