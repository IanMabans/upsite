import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import '../storage/secure_storage.dart';
import '../../routes/app_routes.dart';

/// API Interceptor for handling auth tokens and errors.
///
/// Automatically:
/// - Adds auth token to request headers
/// - Handles 401 unauthorized responses (auto-logout)
/// - Logs requests/responses in debug mode
class ApiInterceptor extends Interceptor {
  final SecureStorage _secureStorage = SecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token to headers if available
    final token = await _secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add common headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    // Skip ngrok browser warning (for development with ngrok)
    options.headers['ngrok-skip-browser-warning'] = 'true';

    // Debug logging
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ 🚀 REQUEST: ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────────────────');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Debug logging
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ ✅ RESPONSE: ${response.statusCode}');
      debugPrint('│ ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└─────────────────────────────────────────────────');
    }

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Debug logging
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────');
      debugPrint('│ ❌ ERROR: ${err.response?.statusCode}');
      debugPrint('│ ${err.requestOptions.uri}');
      debugPrint('│ Message: ${err.message}');
      debugPrint('│ Response: ${err.response?.data}');
      debugPrint('└─────────────────────────────────────────────────');
    }

    // Handle 401 Unauthorized - Auto logout
    if (err.response?.statusCode == 401) {
      await _handleUnauthorized();
    }

    handler.next(err);
  }

  /// Handle 401 unauthorized response.
  /// Clears stored tokens and redirects to login.
  Future<void> _handleUnauthorized() async {
    await _secureStorage.clearAll();

    // Navigate to login screen and clear navigation stack
    if (Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
        'Session Expired',
        'Please log in again to continue.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
