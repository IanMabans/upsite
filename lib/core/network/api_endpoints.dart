/// Centralized API endpoint paths.
///
/// All API paths should be defined here to avoid hardcoding
/// in service files and enable easy maintenance.
class ApiEndpoints {
  ApiEndpoints._();

  // ===========================================
  // BASE
  // ===========================================

  static const String apiPrefix = '/api';

  // ===========================================
  // AUTHENTICATION
  // ===========================================

  /// POST - Login with email and password
  static const String login = '$apiPrefix/login';

  /// POST - Register new account
  static const String register = '$apiPrefix/register';

  /// POST - Logout (revoke token)
  static const String logout = '$apiPrefix/logout';

  /// GET - Get current authenticated user
  static const String user = '$apiPrefix/user';

  /// POST - Request password reset email
  static const String forgotPassword = '$apiPrefix/forgot-password';

  /// POST - Reset password with token
  static const String resetPassword = '$apiPrefix/reset-password';

  // ===========================================
  // DASHBOARD
  // ===========================================

  /// GET - Dashboard statistics
  static const String dashboardStats = '$apiPrefix/dashboard/stats';

  // ===========================================
  // ENDPOINTS
  // ===========================================

  /// GET/POST - List all endpoints / Create endpoint
  static const String endpoints = '$apiPrefix/endpoints';

  /// GET/PUT/DELETE - Single endpoint operations
  static String endpoint(int id) => '$apiPrefix/endpoints/$id';

  /// GET - Get endpoint checks
  static String endpointChecks(int id) => '$apiPrefix/endpoints/$id/checks';

  /// POST - Trigger immediate check
  static String endpointTest(int id) => '$apiPrefix/endpoints/$id/test-now';

  // ===========================================
  // INCIDENTS
  // ===========================================

  /// GET - List incidents
  static const String incidents = '$apiPrefix/incidents';

  /// GET - Single incident
  static String incident(int id) => '$apiPrefix/incidents/$id';

  // ===========================================
  // ALERTS
  // ===========================================

  /// GET/POST - Alert channels
  static const String alertChannels = '$apiPrefix/alert-channels';

  /// GET/PUT/DELETE - Single alert channel
  static String alertChannel(int id) => '$apiPrefix/alert-channels/$id';

  /// POST - Test alert channel
  static String alertChannelTest(int id) =>
      '$apiPrefix/alert-channels/$id/test';

  /// GET/POST - Alert rules
  static const String alertRules = '$apiPrefix/alert-rules';

  /// GET/PUT/DELETE - Single alert rule
  static String alertRule(int id) => '$apiPrefix/alert-rules/$id';
}
