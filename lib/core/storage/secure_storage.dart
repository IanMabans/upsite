import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage wrapper for sensitive data.
///
/// Uses flutter_secure_storage to securely store auth tokens
/// and other sensitive information using platform-specific
/// encryption (Keychain on iOS, EncryptedSharedPreferences on Android).
class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() => _instance;

  SecureStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ===========================================
  // KEYS
  // ===========================================

  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  // ===========================================
  // AUTH TOKEN
  // ===========================================

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  /// Get authentication token
  Future<String?> getToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  /// Delete authentication token
  Future<void> deleteToken() async {
    await _storage.delete(key: _authTokenKey);
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ===========================================
  // REFRESH TOKEN
  // ===========================================

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // ===========================================
  // USER INFO
  // ===========================================

  /// Save user ID
  Future<void> saveUserId(String id) async {
    await _storage.write(key: _userIdKey, value: id);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // ===========================================
  // CLEAR ALL
  // ===========================================

  /// Clear all stored data (used on logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
