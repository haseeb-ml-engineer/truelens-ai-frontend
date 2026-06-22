import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/settings_local_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../mappers/theme_mode_mapper.dart';
import '../models/settings_state.dart';
import 'settings_notifier.dart';

// ---------------------------------------------------------------------------
// Data Layer Providers
// ---------------------------------------------------------------------------

/// Provides the Hive-backed [SettingsLocalDataSource].
final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>(
  (ref) => SettingsLocalDataSourceImpl(),
);

/// Provides the production [SettingsRepository].
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(
    ref.read(settingsLocalDataSourceProvider),
  ),
);

// ---------------------------------------------------------------------------
// Presentation Layer Providers
// ---------------------------------------------------------------------------

/// Global settings state notifier.
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(ref.read(settingsRepositoryProvider)),
);

/// Derived provider exposing the current Flutter [ThemeMode].
final settingsThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeModeKey = ref.watch(
    settingsProvider.select((state) => state.settings.themeMode),
  );
  return ThemeModeMapper.fromStorageKey(themeModeKey);
});
