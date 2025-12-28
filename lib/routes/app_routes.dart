/// Route name constants.
///
/// Centralized route names for navigation.
/// Use these constants with Get.toNamed() instead of hardcoded strings.
abstract class AppRoutes {
  AppRoutes._();

  // ===========================================
  // AUTH ROUTES
  // ===========================================

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // ===========================================
  // MAIN ROUTES
  // ===========================================

  static const String dashboard = '/dashboard';
  static const String home = '/home';

  // ===========================================
  // ENDPOINTS ROUTES
  // ===========================================

  static const String endpoints = '/endpoints';
  static const String endpointDetail = '/endpoints/:id';
  static const String endpointCreate = '/endpoints/create';
  static const String endpointEdit = '/endpoints/:id/edit';

  // ===========================================
  // INCIDENTS ROUTES
  // ===========================================

  static const String incidents = '/incidents';
  static const String incidentDetail = '/incidents/:id';

  // ===========================================
  // ALERTS ROUTES
  // ===========================================

  static const String alerts = '/alerts';
  static const String alertChannels = '/alerts/channels';
  static const String alertRules = '/alerts/rules';

  // ===========================================
  // PROFILE ROUTES
  // ===========================================

  static const String profile = '/profile';
  static const String settings = '/settings';
}
