import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../routes/app_routes.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Authentication controller using GetX.
///
/// Manages authentication state including:
/// - Login/Register/Logout flows
/// - Current user state
/// - Loading and error states
/// - Session persistence and restoration
class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final SecureStorage _secureStorage = SecureStorage();

  // ===========================================
  // REACTIVE STATE
  // ===========================================

  /// Current authenticated user
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  /// Loading state for async operations
  final RxBool isLoading = false.obs;

  /// Loading state for initial session check
  final RxBool isCheckingSession = true.obs;

  /// Error message for display
  final RxnString errorMessage = RxnString(null);

  /// Success message for display
  final RxnString successMessage = RxnString(null);

  // ===========================================
  // GETTERS
  // ===========================================

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser.value != null;

  /// Get current user (non-null)
  UserModel get user => currentUser.value!;

  // ===========================================
  // LIFECYCLE
  // ===========================================

  @override
  void onInit() {
    super.onInit();
    // Check for existing session on app start
    checkSession();
  }

  // ===========================================
  // SESSION MANAGEMENT
  // ===========================================

  /// Check for existing session and restore if valid.
  Future<void> checkSession() async {
    try {
      isCheckingSession.value = true;

      final hasToken = await _secureStorage.hasToken();
      if (!hasToken) {
        isCheckingSession.value = false;
        return;
      }

      // Try to get current user with stored token
      final user = await _authService.getCurrentUser();
      currentUser.value = user;

      debugPrint('Session restored for: ${user.email}');
    } catch (e) {
      // Token invalid or expired, clear storage
      debugPrint('Session check failed: $e');
      await _secureStorage.clearAll();
      currentUser.value = null;
    } finally {
      isCheckingSession.value = false;
    }
  }

  // ===========================================
  // LOGIN
  // ===========================================

  /// Login with email and password.
  ///
  /// On success:
  /// - Stores token securely
  /// - Updates current user
  /// - Navigates to dashboard
  Future<void> login({required String email, required String password}) async {
    try {
      _clearMessages();
      isLoading.value = true;

      final user = await _authService.login(
        email: email.trim(),
        password: password,
      );

      // Store token
      if (user.token != null) {
        await _secureStorage.saveToken(user.token!);
        await _secureStorage.saveUserEmail(user.email);
        await _secureStorage.saveUserId(user.id.toString());
      }

      currentUser.value = user;

      // Navigate to dashboard
      Get.offAllNamed(AppRoutes.dashboard);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      debugPrint('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================
  // REGISTER
  // ===========================================

  /// Register a new user account.
  ///
  /// On success:
  /// - Stores token securely
  /// - Updates current user
  /// - Navigates to dashboard
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      _clearMessages();
      isLoading.value = true;

      final user = await _authService.register(
        name: name.trim(),
        email: email.trim(),
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      // Store token
      if (user.token != null) {
        await _secureStorage.saveToken(user.token!);
        await _secureStorage.saveUserEmail(user.email);
        await _secureStorage.saveUserId(user.id.toString());
      }

      currentUser.value = user;

      // Navigate to dashboard
      Get.offAllNamed(AppRoutes.dashboard);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      debugPrint('Register error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================
  // LOGOUT
  // ===========================================

  /// Logout current user.
  ///
  /// - Calls logout API
  /// - Clears stored tokens
  /// - Navigates to login screen
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Try to call logout API (ignore errors)
      try {
        await _authService.logout();
      } catch (_) {
        // Ignore logout API errors - still clear local data
      }

      // Clear local data
      await _secureStorage.clearAll();
      currentUser.value = null;

      // Navigate to login
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================
  // FORGOT PASSWORD
  // ===========================================

  /// Request password reset email.
  ///
  /// Sends reset link to provided email address.
  Future<void> forgotPassword({required String email}) async {
    try {
      _clearMessages();
      isLoading.value = true;

      final message = await _authService.forgotPassword(email: email.trim());
      successMessage.value = message;

      Get.snackbar('Success', message, snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      debugPrint('Forgot password error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================
  // ERROR HANDLING
  // ===========================================

  /// Handle Dio errors and set appropriate error message.
  void _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage.value = 'Connection timeout. Please try again.';
        break;

      case DioExceptionType.connectionError:
        errorMessage.value =
            'No internet connection. Please check your network.';
        break;

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        if (statusCode == 401) {
          errorMessage.value = 'Invalid email or password';
        } else if (statusCode == 422) {
          // Validation errors from Laravel
          final errors = data?['errors'] as Map<String, dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage.value = firstError.first.toString();
            } else {
              errorMessage.value = firstError.toString();
            }
          } else {
            errorMessage.value = data?['message'] ?? 'Validation error';
          }
        } else if (statusCode == 429) {
          errorMessage.value = 'Too many attempts. Please try again later.';
        } else {
          errorMessage.value =
              data?['message'] ?? 'Server error. Please try again.';
        }
        break;

      default:
        errorMessage.value = 'An error occurred. Please try again.';
    }

    // Show snackbar for error
    Get.snackbar(
      'Error',
      errorMessage.value ?? 'An error occurred',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Clear error and success messages.
  void _clearMessages() {
    errorMessage.value = null;
    successMessage.value = null;
  }

  /// Clear error message (for UI dismissal)
  void clearError() {
    errorMessage.value = null;
  }
}
