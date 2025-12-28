import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/themes/app_colors.dart';
import '../../../shared/themes/app_text_styles.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/social_login_button.dart';
import '../../../shared/widgets/password_strength_indicator.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

/// Register screen for new user sign up.
///
/// Features:
/// - Gradient header with branding
/// - Email, password, confirm password fields
/// - Password strength indicator
/// - Social login options (GitHub, Google)
/// - Link to login screen
class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(child: _RegisterForm()),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _passwordStrength = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordStrength = Validators.passwordStrength(value);
    });
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final controller = Get.find<AuthController>();
      await controller.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top App Bar
        _buildAppBar(),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // Header image with gradient
                  _buildHeaderImage(),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'Create your account',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.textPrimaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Start monitoring your APIs and server uptime in seconds.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Name field
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'John Doe',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    suffixIcon: Icons.person_outline,
                    validator: (value) => Validators.required(value, 'Name'),
                  ),

                  const SizedBox(height: 20),

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
                    hint: 'Create a password',
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    validator: Validators.password,
                    onChanged: _onPasswordChanged,
                  ),

                  const SizedBox(height: 8),

                  // Password strength indicator
                  PasswordStrengthIndicator(strength: _passwordStrength),

                  const SizedBox(height: 20),

                  // Confirm password field
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    onSubmitted: (_) => _handleRegister(),
                  ),

                  const SizedBox(height: 24),

                  // Register button
                  Obx(() {
                    final controller = Get.find<AuthController>();
                    return CustomButton(
                      label: 'Register',
                      icon: Icons.arrow_forward,
                      isLoading: controller.isLoading.value,
                      onPressed: _handleRegister,
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
                            // TODO: Implement GitHub OAuth
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
                            // TODO: Implement Google OAuth
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

                  // Login link
                  _buildLoginLink(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimaryDark,
            ),
          ),

          // Title
          Expanded(
            child: Text(
              'Register',
              style: AppTextStyles.appBarTitle.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Spacer for symmetry
          const SizedBox(width: 48),
        ],
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
          // Background pattern (optional)
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

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        GestureDetector(
          onTap: () => Get.offNamed(AppRoutes.login),
          child: Text(
            'Log in',
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

    // Draw subtle network lines
    final path = Path();

    // Diagonal lines
    for (var i = 0; i < 5; i++) {
      final startX = size.width * 0.1 + (i * size.width * 0.2);
      path.moveTo(startX, size.height);
      path.lineTo(startX + size.width * 0.3, 0);
    }

    canvas.drawPath(path, paint);

    // Draw dots at intersections
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
