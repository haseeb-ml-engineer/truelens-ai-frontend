/// Base exception class for all TrueLens application errors.
///
/// Contains common fields required for consistent error handling and logging
/// across the entire application architecture.
abstract class AppException implements Exception {
  /// A human-readable message safe to display in the UI.
  final String message;

  /// Optional technical details for logging and debugging.
  /// Never displayed directly to the end user.
  final String? technicalDetails;

  /// The original underlying exception that caused this error, if any.
  final dynamic originalException;

  /// The stack trace where the error occurred or was caught.
  final StackTrace? stackTrace;

  /// An optional predefined error code for programmatic handling.
  final String? errorCode;

  const AppException({
    required this.message,
    this.technicalDetails,
    this.originalException,
    this.stackTrace,
    this.errorCode,
  });

  @override
  String toString() {
    final buffer = StringBuffer('AppException: $message');
    if (errorCode != null) {
      buffer.write(' [Code: $errorCode]');
    }
    if (technicalDetails != null) {
      buffer.write('\nDetails: $technicalDetails');
    }
    return buffer.toString();
  }
}

// ---------------------------------------------------------------------------
// Network & Connectivity Exceptions
// ---------------------------------------------------------------------------

/// Exception thrown when the device has no internet connection.
class NoInternetException extends AppException {
  const NoInternetException({
    super.message = 'No internet connection. Please check your network and try again.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'NO_INTERNET');
}

/// Exception thrown when a network request times out.
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'The connection timed out. Please try again later.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'TIMEOUT');
}

/// General exception for network-related failures not covered by timeout or no-internet.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'A network error occurred. Please try again.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'NETWORK_ERROR');
}

// ---------------------------------------------------------------------------
// API & Provider Exceptions
// ---------------------------------------------------------------------------

/// Exception thrown when an API request fails (e.g. 500 server error).
class ApiException extends AppException {
  final int? statusCode;

  const ApiException({
    super.message = 'The server encountered an error. Please try again later.',
    this.statusCode,
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
    super.errorCode = 'API_ERROR',
  });
}

/// Exception thrown when the user is not authenticated or a token is invalid.
class AuthenticationException extends AppException {
  const AuthenticationException({
    super.message = 'Your session has expired. Please log in again.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'UNAUTHENTICATED');
}

/// Exception thrown when the user lacks permission to access a resource (e.g. 403 Forbidden).
class AuthorizationException extends AppException {
  const AuthorizationException({
    super.message = 'You do not have permission to perform this action.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'UNAUTHORIZED');
}

/// Exception thrown when API rate limits are exceeded (e.g. 429 Too Many Requests).
class RateLimitException extends AppException {
  const RateLimitException({
    super.message = 'You have made too many requests. Please wait a moment and try again.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'RATE_LIMIT_EXCEEDED');
}

/// Exception thrown when the server response is invalid or malformed.
class InvalidResponseException extends AppException {
  const InvalidResponseException({
    super.message = 'Received an invalid response from the server.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'INVALID_RESPONSE');
}

/// Exception thrown when parsing JSON from the server fails.
class JsonParsingException extends AppException {
  const JsonParsingException({
    super.message = 'Failed to process the server data. Please try again.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'JSON_PARSE_ERROR');
}

/// Exception thrown when an upstream server or provider has an internal issue.
class ServerException extends AppException {
  const ServerException({
    super.message = 'The service is temporarily unavailable. Please try again later.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'SERVER_ERROR');
}

// ---------------------------------------------------------------------------
// Storage & Local Data Exceptions
// ---------------------------------------------------------------------------

/// General exception for local storage or database failures (e.g. Hive/Isar).
class StorageException extends AppException {
  const StorageException({
    super.message = 'Failed to save or load data locally.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'STORAGE_ERROR');
}

/// Exception thrown when cache operations fail.
class CacheException extends AppException {
  const CacheException({
    super.message = 'Failed to load cached data.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'CACHE_ERROR');
}

// ---------------------------------------------------------------------------
// File & Media Exceptions
// ---------------------------------------------------------------------------

/// General exception for file system operations.
class FileException extends AppException {
  const FileException({
    super.message = 'An error occurred while accessing the file.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'FILE_ERROR');
}

/// Exception thrown when a selected media file is not in a supported format.
class UnsupportedMediaException extends AppException {
  const UnsupportedMediaException({
    super.message = 'The selected file format is not supported.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'UNSUPPORTED_MEDIA');
}

/// Exception thrown when a selected media file exceeds the allowed size limit.
class FileTooLargeException extends AppException {
  const FileTooLargeException({
    super.message = 'The selected file is too large to be uploaded.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'FILE_TOO_LARGE');
}

// ---------------------------------------------------------------------------
// General & Domain Exceptions
// ---------------------------------------------------------------------------

/// Exception thrown when domain validation rules are violated (e.g. empty fields).
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'VALIDATION_ERROR');
}

/// Exception thrown when the application configuration is invalid or missing.
class ConfigurationException extends AppException {
  const ConfigurationException({
    super.message = 'A configuration error occurred.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'CONFIGURATION_ERROR');
}

/// Fallback exception for unknown or unmapped errors.
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred. Please try again.',
    super.technicalDetails,
    super.originalException,
    super.stackTrace,
  }) : super(errorCode: 'UNKNOWN_ERROR');
}
