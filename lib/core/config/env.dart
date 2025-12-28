/// Environment configuration wrapper.
///
/// Provides access to compile-time environment variables.
/// Values are passed via --dart-define at build/run time.
///
/// Example:
/// ```bash
/// flutter run --dart-define=API_BASE_URL=https://api.example.com
/// ```
class Env {
  Env._();

  /// Base URL for Laravel API
  /// Default to localhost for development
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Enable debug mode for additional logging
  static const bool debugMode = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: true,
  );

  /// App environment (development, staging, production)
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Check if running in development
  static bool get isDevelopment => environment == 'development';

  /// Check if running in production
  static bool get isProduction => environment == 'production';
}
