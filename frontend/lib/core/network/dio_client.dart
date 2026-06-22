import 'dart:io';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../exceptions/app_exceptions.dart';
import '../exceptions/error_mapper.dart';
import '../utils/result.dart';
import 'api_endpoints.dart';
import 'api_interceptors.dart';
import 'network_logger.dart';

/// Centralized networking client providing a strictly-typed, exception-safe
/// interface for all HTTP operations using [Result].
///
/// Ensures no raw [DioException] ever leaks to upper layers.
class DioClient {
  late final Dio _dio;

  // Singleton pattern
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.activeBaseUrl,
        connectTimeout: EnvConfig.requestTimeout,
        receiveTimeout: EnvConfig.requestTimeout,
        sendTimeout: EnvConfig.requestTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Register interceptors (order matters)
    _dio.interceptors.addAll([
      AuthInterceptor(),
      RetryInterceptor(dio: _dio, maxRetries: 2),
      NetworkLoggerInterceptor(),
    ]);
  }

  static final DioClient _instance = DioClient._internal();

  /// Returns the singleton instance of the [DioClient].
  static DioClient get instance => _instance;

  /// Performs a generic HTTP GET request.
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) async {
    return _safeApiCall(() async {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      
      return parser != null ? parser(response.data) : response.data as T;
    });
  }

  /// Performs a generic HTTP POST request.
  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) async {
    return _safeApiCall(() async {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return parser != null ? parser(response.data) : response.data as T;
    });
  }

  /// Performs a multipart file upload.
  ///
  /// Uses [FormData] to upload images or videos and optionally reports
  /// progress via [onSendProgress].
  Future<Result<T>> uploadFile<T>(
    String path, {
    required File file,
    required String fileKey,
    Map<String, String>? additionalData,
    String? customMimeType,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) async {
    return _safeApiCall(() async {
      final fileName = file.path.split('/').last;
      
      final formDataMap = <String, dynamic>{
        fileKey: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      };

      if (additionalData != null) {
        formDataMap.addAll(additionalData);
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return parser != null ? parser(response.data) : response.data as T;
    });
  }

  /// Wraps any Dio operation in a try-catch block, ensuring that all errors
  /// are converted strictly to [Failure] containing an [AppException].
  Future<Result<T>> _safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      final data = await apiCall();
      return Success(data);
    } catch (e, stackTrace) {
      final mappedError = ErrorMapper.map(e, stackTrace);
      return Failure(mappedError);
    }
  }

  /// Updates the base URL dynamically if the active provider changes.
  void updateBaseUrl() {
    _dio.options.baseUrl = ApiEndpoints.activeBaseUrl;
  }
}
