import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'app_exceptions.dart';

/// Centralized mapper that converts raw 3rd-party or platform exceptions
/// into strictly-typed [AppException] subclasses.
///
/// This ensures the UI layer only ever interacts with the [AppException]
/// hierarchy, containing clean, user-friendly messages, while retaining
/// underlying details for logging.
class ErrorMapper {
  ErrorMapper._();

  /// Maps an arbitrary object (usually caught in a catch block)
  /// to a corresponding [AppException].
  ///
  /// Optionally accepts an [overrideMessage] to explicitly set the user-facing text,
  /// and [stackTrace] to preserve the execution context.
  static AppException map(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _mapDioException(error, stackTrace);
    }

    if (error is SocketException) {
      return NoInternetException(
        technicalDetails: error.message,
        originalException: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return JsonParsingException(
        technicalDetails: error.message,
        originalException: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FileSystemException) {
      return FileException(
        technicalDetails: error.message,
        originalException: error,
        stackTrace: stackTrace,
      );
    }

    if (error is PlatformException) {
      return UnknownException(
        message: 'A device specific error occurred.',
        technicalDetails: 'Code: ${error.code}, Message: ${error.message}',
        originalException: error,
        stackTrace: stackTrace,
      );
    }

    // Default fallback
    return UnknownException(
      technicalDetails: error.toString(),
      originalException: error,
      stackTrace: stackTrace,
    );
  }

  /// Specialized mapping for Dio HTTP exceptions.
  static AppException _mapDioException(DioException error, StackTrace? stackTrace) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          technicalDetails: error.message,
          originalException: error,
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final statusMessage = error.response?.statusMessage;
        final responseData = error.response?.data?.toString();
        final technicalInfo = 'Status: $statusCode - $statusMessage. Response: $responseData';

        if (statusCode == 401) {
          return AuthenticationException(
            technicalDetails: technicalInfo,
            originalException: error,
            stackTrace: stackTrace,
          );
        } else if (statusCode == 403) {
          return AuthorizationException(
            technicalDetails: technicalInfo,
            originalException: error,
            stackTrace: stackTrace,
          );
        } else if (statusCode == 429) {
          return RateLimitException(
            technicalDetails: technicalInfo,
            originalException: error,
            stackTrace: stackTrace,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            technicalDetails: technicalInfo,
            originalException: error,
            stackTrace: stackTrace,
          );
        }

        return ApiException(
          statusCode: statusCode,
          technicalDetails: technicalInfo,
          originalException: error,
          stackTrace: stackTrace,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'The request was cancelled.',
          technicalDetails: error.message,
          originalException: error,
          stackTrace: stackTrace,
        );

      case DioExceptionType.connectionError:
        return NoInternetException(
          technicalDetails: error.message,
          originalException: error,
          stackTrace: stackTrace,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Secure connection failed. Please check your network.',
          technicalDetails: 'Bad certificate: ${error.message}',
          originalException: error,
          stackTrace: stackTrace,
        );

      case DioExceptionType.unknown:
        // Attempt to unwrap inner SocketExceptions nested inside DioException
        if (error.error is SocketException) {
          return NoInternetException(
            technicalDetails: (error.error as SocketException).message,
            originalException: error.error,
            stackTrace: stackTrace,
          );
        }
        return NetworkException(
          technicalDetails: error.message,
          originalException: error,
          stackTrace: stackTrace,
        );
    }
  }
}
