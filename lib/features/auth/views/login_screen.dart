import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/themes/app_colors.dart';
import '../../../shared/themes/app_text_styles.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/social_login_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

/// Login screen for user authentication.
///
/// Features:
/// - Gradient header with branding
/// - Email and password fields
/// - Forgot password link
/// - Social login options (GitHub, Google)
/// - Link to register screen
class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(child: _LoginForm()),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final controller = Get.find<AuthController>();
      await controller.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            // Header image with gradient
            _buildHeaderImage(),

            const SizedBox(height: 24),

            // Title
            Text(
              'Welcome back',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Sign in to continue monitoring your APIs.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Email field
            CustomTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'name@company.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              suffixIcon: Icons.mail_outline,
              validator: Validators.email,
            ),

            const SizedBox(height: 20),

            // Password field
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: (value) => Validators.required(value, 'Password'),
              onSubmitted: (_) => _handleLogin(),
            ),

            const SizedBox(height: 12),

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.link.copyWith(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Login button
            Obx(() {
              final controller = Get.find<AuthController>();
              return CustomButton(
                label: 'Log in',
                icon: Icons.arrow_forward,
                isLoading: controller.isLoading.value,
                onPressed: _handleLogin,
              );
            }),

            const SizedBox(height: 24),

            // Divider with text
            _buildDivider(),

            const SizedBox(height: 24),

            // Social login buttons
            Row(
              children: [
                Expanded(
                  child: SocialLoginButton(
                    label: 'GitHub',
                    provider: SocialProvider.github,
                    onPressed: () {
                      Get.snackbar(
                        'Coming Soon',
                        'GitHub login will be available soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SocialLoginButton(
                    label: 'Google',
                    provider: SocialProvider.google,
                    onPressed: () {
                      Get.snackbar(
                        'Coming Soon',
                        'Google login will be available soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Register link
            _buildRegisterLink(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppColors.headerGradient,
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(painter: _NetworkPatternPainter()),
          ),

          // Logo/Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha(51)),
              ),
              child: const Icon(
                Icons.show_chart,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderDark)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.borderDark)),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.register),
          child: Text(
            'Register',
            style: AppTextStyles.link.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for network pattern background.
class _NetworkPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(13)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();

    for (var i = 0; i < 5; i++) {
      final startX = size.width * 0.1 + (i * size.width * 0.2);
      path.moveTo(startX, size.height);
      path.lineTo(startX + size.width * 0.3, 0);
    }

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = Colors.white.withAlpha(26)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 8; i++) {
      final x = size.width * 0.1 + (i * size.width * 0.12);
      final y = size.height * 0.3 + ((i % 3) * size.height * 0.2);
      canvas.drawCircle(Offset(x, y), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
