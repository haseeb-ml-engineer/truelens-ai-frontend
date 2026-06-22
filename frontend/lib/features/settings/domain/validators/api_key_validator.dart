import '../../../../core/config/settings_config.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/result.dart';

/// Validates API keys before they are persisted to Hive.
class ApiKeyValidator {
  ApiKeyValidator._();

  /// Validates [apiKey] for the given [providerKey].
  ///
  /// Returns [Success] with the trimmed key, or [Failure] with a
  /// [ValidationException] describing the issue.
  static Result<String> validate({
    required String providerKey,
    required String apiKey,
  }) {
    final trimmed = apiKey.trim();

    if (!SettingsConfig.apiKeyProviders.contains(providerKey)) {
      return Failure(
        ValidationException(
          message: 'API keys are not required for this provider.',
        ),
      );
    }

    if (trimmed.isEmpty) {
      return Failure(
        ValidationException(
          message: 'API key cannot be empty.',
        ),
      );
    }

    if (trimmed.length < SettingsConfig.apiKeyMinLength) {
      return Failure(
        ValidationException(
          message:
              'API key must be at least ${SettingsConfig.apiKeyMinLength} characters.',
        ),
      );
    }

    if (trimmed.length > SettingsConfig.apiKeyMaxLength) {
      return Failure(
        ValidationException(
          message:
              'API key must not exceed ${SettingsConfig.apiKeyMaxLength} characters.',
        ),
      );
    }

    return Success(trimmed);
  }

  /// Returns a masked representation of [apiKey] for display purposes.
  ///
  /// Shows bullet characters with only the last four characters visible.
  static String mask(String apiKey) {
    if (apiKey.isEmpty) return '';

    final suffixLength = SettingsConfig.apiKeyVisibleSuffixLength;
    if (apiKey.length <= suffixLength) {
      return '•' * apiKey.length;
    }

    final visibleSuffix = apiKey.substring(apiKey.length - suffixLength);
    return '${'•' * 12}$visibleSuffix';
  }
}
