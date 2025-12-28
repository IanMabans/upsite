import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/themes/app_colors.dart';
import '../../../shared/themes/app_text_styles.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

/// Forgot password screen.
///
/// Allows users to request a password reset email.
class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(child: _ForgotPasswordForm()),
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final controller = Get.find<AuthController>();
      await controller.forgotPassword(email: _emailController.text);

      // Check if request was successful
      if (controller.successMessage.value != null) {
        setState(() {
          _emailSent = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top App Bar
        _buildAppBar(),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _emailSent ? _buildSuccessState() : _buildFormState(),
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
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimaryDark,
            ),
          ),
          Expanded(
            child: Text(
              'Reset Password',
              style: AppTextStyles.appBarTitle.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),

          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.lock_reset,
              size: 40,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'Forgot your password?',
            style: AppTextStyles.h1.copyWith(color: AppColors.textPrimaryDark),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            "No worries! Enter your email address and we'll send you a link to reset your password.",
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
            textInputAction: TextInputAction.done,
            suffixIcon: Icons.mail_outline,
            validator: Validators.email,
            onSubmitted: (_) => _handleSubmit(),
          ),

          const SizedBox(height: 24),

          // Submit button
          Obx(() {
            final controller = Get.find<AuthController>();
            return CustomButton(
              label: 'Send Reset Link',
              icon: Icons.send,
              isLoading: controller.isLoading.value,
              onPressed: _handleSubmit,
            );
          }),

          const SizedBox(height: 24),

          // Back to login link
          _buildBackToLoginLink(),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),

        // Success icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withAlpha(26),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.mark_email_read,
            size: 40,
            color: AppColors.success,
          ),
        ),

        const SizedBox(height: 24),

        // Title
        Text(
          'Check your email',
          style: AppTextStyles.h1.copyWith(color: AppColors.textPrimaryDark),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Description
        Text(
          "We've sent a password reset link to",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 4),

        Text(
          _emailController.text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Open email app button
        CustomButton(
          label: 'Open Email App',
          icon: Icons.open_in_new,
          onPressed: () {
            // Could use url_launcher to open email app
            Get.snackbar(
              'Tip',
              'Check your inbox for the reset link',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),

        const SizedBox(height: 16),

        // Resend link
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _emailSent = false;
              });
            },
            child: Text(
              "Didn't receive the email? Try again",
              style: AppTextStyles.link.copyWith(color: AppColors.primary),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Back to login
        _buildBackToLoginLink(),
      ],
    );
  }

  Widget _buildBackToLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.arrow_back,
          size: 16,
          color: AppColors.textSecondaryDark,
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => Get.offNamed(AppRoutes.login),
          child: Text(
            'Back to login',
            style: AppTextStyles.link.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        ),
      ],
    );
  }
}
