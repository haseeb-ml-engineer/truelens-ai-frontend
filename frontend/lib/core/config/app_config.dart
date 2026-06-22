import 'env_config.dart';

/// App-wide configuration.
///
/// Provides a unified facade for both compile-time constants and
/// runtime environment values loaded from [EnvConfig].
///
/// Runtime values (API URLs, timeouts, feature flags) delegate to
/// [EnvConfig] so they can be controlled per-environment without
/// rebuilding the app. Compile-time constants (supported formats)
/// remain as `const` fields for tree-shaking and performance.
class AppConfig {
  AppConfig._();

  // ---------------------------------------------------------------------------
  // Runtime Configuration (delegated to EnvConfig)
  // ---------------------------------------------------------------------------

  /// Base URL for the backend API.
  ///
  /// Read from `API_BASE_URL` in the active `.env` file.
  /// Falls back to `https://api.truelens.ai/v1` if not configured.
  static String get apiBaseUrl => EnvConfig.apiBaseUrl;

  /// HTTP request timeout duration.
  ///
  /// Read from `REQUEST_TIMEOUT_SECONDS` in the active `.env` file.
  /// Falls back to 60 seconds if not configured.
  static Duration get requestTimeout => EnvConfig.requestTimeout;

  /// Maximum file upload size in bytes.
  ///
  /// Read from `MAX_UPLOAD_SIZE_MB` in the active `.env` file.
  /// Falls back to 50 MB if not configured.
  static int get maxUploadSizeBytes => EnvConfig.maxUploadSizeBytes;

  // ---------------------------------------------------------------------------
  // Compile-Time Constants
  // ---------------------------------------------------------------------------

  /// Supported image formats for upload validation.
  static const List<String> supportedImageFormats = [
    'jpg', 'jpeg', 'png', 'webp', 'bmp',
  ];

  /// Supported video formats for upload validation.
  static const List<String> supportedVideoFormats = [
    'mp4', 'mov', 'avi', 'mkv',
  ];

  /// All supported media formats (images + videos).
  static const List<String> supportedFormats = [
    ...supportedImageFormats,
    ...supportedVideoFormats,
  ];

  // ---------------------------------------------------------------------------
  // Feature Flags (delegated to EnvConfig)
  // ---------------------------------------------------------------------------

  /// Whether video analysis is enabled.
  static bool get enableVideoAnalysis => EnvConfig.enableVideoAnalysis;

  /// Whether PDF report export is enabled.
  static bool get enablePdfExport => EnvConfig.enablePdfExport;

  /// Whether cloud sync is enabled.
  static bool get enableCloudSync => EnvConfig.enableCloudSync;

  /// Whether developer mode is enabled.
  static bool get enableDeveloperMode => EnvConfig.enableDeveloperMode;

  /// Whether verbose debug logging is enabled.
  static bool get enableDebugLogging => EnvConfig.enableDebugLogging;

  // ---------------------------------------------------------------------------
  // Provider Configuration (delegated to EnvConfig)
  // ---------------------------------------------------------------------------

  /// The currently active LLM provider identifier.
  static String get activeProvider => EnvConfig.activeProvider;

  /// The specific model identifier for the active provider.
  static String get activeModel => EnvConfig.activeModel;
}