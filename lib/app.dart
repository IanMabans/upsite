import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'shared/themes/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'shared/widgets/loading_indicator.dart';
import 'shared/themes/app_colors.dart';

/// Main app widget with GetX configuration.
///
/// Sets up:
/// - Theme configuration
/// - GetX routing
/// - Initial bindings
/// - Session check on startup
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Upsite',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Routing
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,

      // Initial binding - AuthController persists throughout app lifecycle
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),

      // Builder for session check wrapper
      builder: (context, child) {
        return _SessionWrapper(child: child);
      },
    );
  }
}

/// Wrapper widget that handles session restoration.
///
/// Shows loading state while checking for existing session.
class _SessionWrapper extends StatelessWidget {
  final Widget? child;

  const _SessionWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final authController = Get.find<AuthController>();

      // Show loading while checking session
      if (authController.isCheckingSession.value) {
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.show_chart,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                const LoadingIndicator(message: 'Loading...'),
              ],
            ),
          ),
        );
      }

      // If user is authenticated and on login/register, redirect to dashboard
      if (authController.isAuthenticated) {
        final currentRoute = Get.currentRoute;
        if (currentRoute == AppRoutes.login ||
            currentRoute == AppRoutes.register ||
            currentRoute == '/') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(AppRoutes.dashboard);
          });
        }
      }

      return child ?? const SizedBox.shrink();
    });
  }
}
