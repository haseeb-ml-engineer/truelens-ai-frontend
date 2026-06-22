import '../../domain/entities/settings.dart';

/// Presentation-layer state for the Settings module.
class SettingsState {
  /// The current persisted settings snapshot.
  final Settings settings;

  /// Whether settings are being loaded from Hive.
  final bool isLoading;

  /// Whether a save operation is in progress.
  final bool isSaving;

  /// The most recent non-fatal error message, if any.
  final String? errorMessage;

  /// Whether the initial load has completed.
  final bool isInitialized;

  const SettingsState({
    required this.settings,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.isInitialized = false,
  });

  factory SettingsState.initial() {
    return SettingsState(
      settings: Settings.defaults(),
      isLoading: true,
    );
  }

  SettingsState copyWith({
    Settings? settings,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool? isInitialized,
    bool clearError = false,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  /// Convenience accessors mirroring [Settings] for provider consumers.
  String get selectedProvider => settings.selectedProvider;

  Map<String, String> get apiKeys => settings.apiKeys;

  String get themeMode => settings.themeMode;
}
