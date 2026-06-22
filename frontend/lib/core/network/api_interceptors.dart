import 'package:dio/dio.dart';
import '../config/env_config.dart';

/// Interceptor that injects provider-specific authentication headers
/// or query parameters dynamically.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final provider = EnvConfig.activeProvider;

    try {
      final apiKey = EnvConfig.activeProviderApiKey;

      switch (provider) {
        case 'gemini':
          // Gemini generally expects the key in the query parameter 'key'
          // but can also accept the 'x-goog-api-key' header.
          options.headers['x-goog-api-key'] = apiKey;
          break;
        case 'openai':
          options.headers['Authorization'] = 'Bearer $apiKey';
          break;
        case 'claude':
          options.headers['x-api-key'] = apiKey;
          options.headers['anthropic-version'] = '2023-06-01'; // Claude requires version
          break;
        case 'truelens':
          options.headers['Authorization'] = 'Bearer $apiKey';
          break;
      }
    } catch (e) {
      // If the API key is not configured, we allow the request to proceed
      // so it fails naturally with a 401/403, which the ErrorMapper will handle.
      // Alternatively, we could reject here. We let the server reject.
    }

    handler.next(options);
  }
}

/// Interceptor that provides automatic retry mechanism for transient network errors.
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final int retryDelayBaseMs;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelayBaseMs = 1000,
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] ?? 0;

    if (_shouldRetry(err) && retryCount < maxRetries) {
      // Exponential backoff
      final delay = retryDelayBaseMs * (1 << retryCount);
      await Future.delayed(Duration(milliseconds: delay));

      try {
        final options = err.requestOptions;
        options.extra['retryCount'] = retryCount + 1;
        
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response != null && (err.response!.statusCode == 429 || err.response!.statusCode! >= 500));
  }
}
