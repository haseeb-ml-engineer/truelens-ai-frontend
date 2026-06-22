import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/settings_config.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/settings_state.dart';

/// Manages application settings with Hive persistence.
class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(SettingsState.initial()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.loadSettings();
    result.fold(
      (settings) {
        state = state.copyWith(
          settings: settings,
          isLoading: false,
          isInitialized: true,
          clearError: true,
        );
      },
      (error) {
        state = state.copyWith(
          settings: Settings.defaults(),
          isLoading: false,
          isInitialized: true,
          errorMessage: error.message,
        );
      },
    );
  }

  Future<void> setThemeMode(String themeMode) async {
    // Root cause fix: theme must update in-memory before the async Hive write
    // so MaterialApp (settingsThemeModeProvider) and toggles rebuild instantly.
    final previousSettings = state.settings;
    state = state.copyWith(
      settings: previousSettings.copyWith(themeMode: themeMode),
      isSaving: true,
      clearError: true,
    );

    final result = await _repository.saveSettings(state.settings);
    result.fold(
      (settings) {
        state = state.copyWith(
          settings: settings,
          isSaving: false,
          clearError: true,
        );
      },
      (error) {
        state = state.copyWith(
          settings: previousSettings,
          isSaving: false,
          errorMessage: error.message,
        );
      },
    );
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await setThemeMode(
      isDark ? SettingsConfig.themeDark : SettingsConfig.themeLight,
    );
  }

  Future<void> setSelectedProvider(String providerKey) async {
    state = state.copyWith(isSaving: true, clearError: true);
    final result = await _repository.saveSettings(
      state.settings.copyWith(selectedProvider: providerKey),
    );
    _handleSaveResult(result);
  }

  Future<bool> saveApiKey({
    required String providerKey,
    required String apiKey,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _repository.updateApiKey(
      providerKey: providerKey,
      apiKey: apiKey,
      current: state.settings,
    );

    return result.fold(
      (settings) {
        state = state.copyWith(
          settings: settings,
          isSaving: false,
          clearError: true,
        );
        return true;
      },
      (error) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: error.message,
        );
        return false;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void _handleSaveResult(Result<Settings> result) {
    result.fold(
      (settings) {
        state = state.copyWith(
          settings: settings,
          isSaving: false,
          clearError: true,
        );
      },
      (error) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: error.message,
        );
      },
    );
  }
}
