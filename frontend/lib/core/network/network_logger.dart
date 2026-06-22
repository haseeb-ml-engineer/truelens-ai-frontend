import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../config/env_config.dart';

/// A robust network logger interceptor that logs requests and responses
/// ONLY in debug mode and NEVER logs sensitive information like API keys.
class NetworkLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!EnvConfig.enableDebugLogging) {
      return handler.next(options);
    }

    final buffer = StringBuffer();
    buffer.writeln('==================== REQUEST ====================');
    buffer.writeln('--> ${options.method.toUpperCase()} ${options.uri}');
    
    // Safely print headers (mask API keys)
    if (options.headers.isNotEmpty) {
      buffer.writeln('Headers:');
      options.headers.forEach((key, value) {
        if (key.toLowerCase().contains('key') || 
            key.toLowerCase().contains('auth') || 
            key.toLowerCase().contains('token')) {
          buffer.writeln('  $key: ********');
        } else {
          buffer.writeln('  $key: $value');
        }
      });
    }

    if (options.data != null) {
      if (options.data is FormData) {
        buffer.writeln('Body: [FormData]');
      } else {
        buffer.writeln('Body: ${options.data}');
      }
    }
    
    developer.log(buffer.toString(), name: 'NetworkLogger');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!EnvConfig.enableDebugLogging) {
      return handler.next(response);
    }

    final buffer = StringBuffer();
    buffer.writeln('==================== RESPONSE ===================');
    buffer.writeln('<-- ${response.statusCode} ${response.statusMessage} ${response.requestOptions.uri}');
    
    if (response.data != null) {
      // Limit output size for large responses to prevent console lag
      final dataStr = response.data.toString();
      if (dataStr.length > 1000) {
        buffer.writeln('Response: ${dataStr.substring(0, 1000)}... [TRUNCATED]');
      } else {
        buffer.writeln('Response: $dataStr');
      }
    }
    
    developer.log(buffer.toString(), name: 'NetworkLogger');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!EnvConfig.enableDebugLogging) {
      return handler.next(err);
    }

    final buffer = StringBuffer();
    buffer.writeln('==================== ERROR ====================');
    buffer.writeln('<-- ${err.response?.statusCode} ${err.requestOptions.uri}');
    buffer.writeln('Type: ${err.type}');
    buffer.writeln('Message: ${err.message}');
    
    if (err.response?.data != null) {
      buffer.writeln('Error Data: ${err.response?.data}');
    }
    
    developer.log(buffer.toString(), name: 'NetworkLogger', error: err);
    handler.next(err);
  }
}
