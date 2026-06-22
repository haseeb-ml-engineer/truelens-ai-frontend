import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/config/settings_config.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/settings_model.dart';

/// Contract for reading and writing settings to the local Hive box.
abstract class SettingsLocalDataSource {
  Future<SettingsModel?> readSettings();

  Future<void> writeSettings(SettingsModel model);
}

/// Hive-backed implementation of [SettingsLocalDataSource].
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  Box get _box => HiveService.getSettingsBox();

  @override
  Future<SettingsModel?> readSettings() async {
    try {
      final themeMode = _box.get(SettingsConfig.hiveKeyThemeMode);
      final selectedProvider = _box.get(SettingsConfig.hiveKeySelectedProvider);

      if (themeMode == null && selectedProvider == null) {
        return null;
      }

      return SettingsModel.fromHiveMap({
        SettingsConfig.hiveKeyThemeMode: themeMode,
        SettingsConfig.hiveKeySelectedProvider: selectedProvider,
        SettingsConfig.hiveKeyApiKeyGemini: _box.get(
          SettingsConfig.hiveKeyApiKeyGemini,
        ),
        SettingsConfig.hiveKeyApiKeyOpenAI: _box.get(
          SettingsConfig.hiveKeyApiKeyOpenAI,
        ),
        SettingsConfig.hiveKeyApiKeyClaude: _box.get(
          SettingsConfig.hiveKeyApiKeyClaude,
        ),
      });
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to load settings.',
        technicalDetails: 'Hive read error: $e',
        originalException: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> writeSettings(SettingsModel model) async {
    try {
      final entries = model.toHiveMap();
      for (final entry in entries.entries) {
        await _box.put(entry.key, entry.value);
      }
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to save settings.',
        technicalDetails: 'Hive write error: $e',
        originalException: e,
        stackTrace: stackTrace,
      );
    }
  }
}
