import 'package:dio/dio.dart';
import '../config/env.dart';
import 'api_interceptor.dart';

/// Dio HTTP client singleton.
///
/// Provides a configured Dio instance with:
/// - Base URL from environment
/// - Timeouts configured
/// - Auth interceptor for token handling
/// - Error handling
class DioClient {
  static final DioClient _instance = DioClient._internal();

  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(ApiInterceptor());
  }

  /// Reset the client (useful for testing)
  void reset() {
    dio.options.baseUrl = Env.apiBaseUrl;
  }
}
