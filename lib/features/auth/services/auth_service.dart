import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

/// Authentication service for API calls.
///
/// Handles all authentication-related API communication:
/// - Login
/// - Register
/// - Logout
/// - Get current user
/// - Forgot password
/// - Reset password
class AuthService {
  final Dio _dio = DioClient().dio;

  /// Login with email and password.
  ///
  /// Returns [UserModel] with token on success.
  /// Throws [DioException] on network/validation errors.
  ///
  /// API: POST /api/login
  /// Body: { email, password }
  /// Response: { user: {...}, token: "..." }
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password, 'device_name': 'mobile_app'},
    );

    return UserModel.fromJson(response.data);
  }

  /// Register a new user account.
  ///
  /// Returns [UserModel] with token on success.
  /// Throws [DioException] on network/validation errors.
  ///
  /// API: POST /api/register
  /// Body: { name, email, password, password_confirmation }
  /// Response: { user: {...}, token: "..." }
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'device_name': 'mobile_app',
      },
    );

    return UserModel.fromJson(response.data);
  }

  /// Logout current user (revoke token).
  ///
  /// API: POST /api/logout
  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }

  /// Get current authenticated user.
  ///
  /// Returns [UserModel] for the authenticated user.
  /// Throws [DioException] on network errors or 401 if not authenticated.
  ///
  /// API: GET /api/user
  /// Response: { id, name, email, ... }
  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.user);
    return UserModel.fromJson(response.data);
  }

  /// Request password reset email.
  ///
  /// Sends password reset link to the provided email.
  /// Returns success message from server.
  ///
  /// API: POST /api/forgot-password
  /// Body: { email }
  /// Response: { message: "..." }
  Future<String> forgotPassword({required String email}) async {
    final response = await _dio.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );

    return response.data['message'] ?? 'Password reset link sent';
  }

  /// Reset password with token.
  ///
  /// Resets the user's password using the token from email.
  ///
  /// API: POST /api/reset-password
  /// Body: { email, token, password, password_confirmation }
  Future<String> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return response.data['message'] ?? 'Password reset successful';
  }
}
