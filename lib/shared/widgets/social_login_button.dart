import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

/// Social login button (GitHub, Google, etc.)
///
/// Outlined button with icon for social authentication.
class SocialLoginButton extends StatelessWidget {
  /// Button label
  final String label;

  /// Social provider type
  final SocialProvider provider;

  /// On pressed callback
  final VoidCallback? onPressed;

  /// Show loading state
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.provider,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondaryDark,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: AppColors.borderDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textSecondaryDark,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon(),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textSecondaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case SocialProvider.github:
        return const Icon(
          Icons.code,
          size: 20,
          color: AppColors.textSecondaryDark,
        );
      case SocialProvider.google:
        return SvgPicture.string(_googleIconSvg, width: 20, height: 20);
      case SocialProvider.apple:
        return const Icon(
          Icons.apple,
          size: 20,
          color: AppColors.textSecondaryDark,
        );
    }
  }

  // Google icon SVG (colorful)
  static const String _googleIconSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
  <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
  <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
  <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
</svg>
''';
}

/// Social authentication provider types.
enum SocialProvider { github, google, apple }
