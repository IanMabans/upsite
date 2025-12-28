import 'package:get/get.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/register_screen.dart';
import '../features/auth/views/forgot_password_screen.dart';
import '../features/dashboard/views/dashboard_screen.dart';
import 'app_routes.dart';

/// GetX page routing configuration.
///
/// Defines all app routes with their associated:
/// - Page widget
/// - Bindings (dependency injection)
/// - Transitions
abstract class AppPages {
  AppPages._();

  /// Initial route - shown after splash/session check
  static const initial = AppRoutes.login;

  /// All app routes
  static final routes = <GetPage>[
    // ===========================================
    // AUTH ROUTES
    // ===========================================
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
      transition: Transition.rightToLeft,
    ),

    // ===========================================
    // MAIN ROUTES
    // ===========================================
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      // binding: BindingsBuilder(() {
      //   Get.lazyPut(() => DashboardController());
      // }),
      transition: Transition.fadeIn,
    ),
  ];
}
