import '../../../../core/config/provider_config.dart';
import '../../../../core/config/settings_config.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/validators/api_key_validator.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

/// Production implementation of [SettingsRepository] backed by Hive.
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<Result<Settings>> loadSettings() async {
    try {
      final model = await _localDataSource.readSettings();
      if (model == null) {
        return Success(Settings.defaults());
      }
      return Success(_normalize(model.toEntity()));
    } on AppException catch (e) {
      return Failure(e);
    } catch (e, stackTrace) {
      return Failure(
        StorageException(
          message: 'Failed to load settings.',
          technicalDetails: '$e',
          originalException: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Settings>> saveSettings(Settings settings) async {
    try {
      final normalized = _normalize(settings);
      final model = SettingsModel.fromEntity(normalized);
      await _localDataSource.writeSettings(model);
      return Success(normalized);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e, stackTrace) {
      return Failure(
        StorageException(
          message: 'Failed to save settings.',
          technicalDetails: '$e',
          originalException: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Settings>> updateThemeMode(String themeMode) async {
    if (!_isValidThemeMode(themeMode)) {
      return Failure(
        ValidationException(message: 'Invalid theme mode selected.'),
      );
    }

    final current = await loadSettings();
    return current.fold(
      (settings) => saveSettings(settings.copyWith(themeMode: themeMode)),
      (error) => Failure<Settings>(error),
    );
  }

  @override
  Future<Result<Settings>> updateSelectedProvider(String providerKey) async {
    if (!_isValidProviderKey(providerKey)) {
      return Failure(
        ValidationException(message: 'Invalid AI provider selected.'),
      );
    }

    final current = await loadSettings();
    return current.fold(
      (settings) =>
          saveSettings(settings.copyWith(selectedProvider: providerKey)),
      (error) => Failure<Settings>(error),
    );
  }

  @override
  Future<Result<Settings>> updateApiKey({
    required String providerKey,
    required String apiKey,
    required Settings current,
  }) async {
    final validation = ApiKeyValidator.validate(
      providerKey: providerKey,
      apiKey: apiKey,
    );

    return validation.fold(
      (validatedKey) {
        final updatedKeys = Map<String, String>.from(current.apiKeys);
        updatedKeys[providerKey] = validatedKey;
        return saveSettings(current.copyWith(apiKeys: updatedKeys));
      },
      (error) => Failure<Settings>(error),
    );
  }

  Settings _normalize(Settings settings) {
    final themeMode = _isValidThemeMode(settings.themeMode)
        ? settings.themeMode
        : SettingsConfig.themeSystem;
    final selectedProvider = _isValidProviderKey(settings.selectedProvider)
        ? settings.selectedProvider
        : SettingsConfig.providerGemini;

    return settings.copyWith(
      themeMode: themeMode,
      selectedProvider: selectedProvider,
    );
  }

  bool _isValidThemeMode(String themeMode) {
    return themeMode == SettingsConfig.themeSystem ||
        themeMode == SettingsConfig.themeLight ||
        themeMode == SettingsConfig.themeDark;
  }

  bool _isValidProviderKey(String providerKey) {
    return ProviderType.tryParse(providerKey) != null;
  }
}
