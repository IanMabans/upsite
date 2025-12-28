import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

/// Custom text field with consistent styling.
///
/// Matches the design system with dark theme support,
/// optional suffix icon, and password visibility toggle.
class CustomTextField extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;

  /// Field label displayed above input
  final String label;

  /// Placeholder text
  final String? hint;

  /// Keyboard type
  final TextInputType keyboardType;

  /// Whether this is a password field
  final bool isPassword;

  /// Suffix icon (e.g., mail icon)
  final IconData? suffixIcon;

  /// Validation function
  final String? Function(String?)? validator;

  /// On changed callback
  final ValueChanged<String>? onChanged;

  /// Whether field is enabled
  final bool enabled;

  /// Auto-focus this field
  final bool autofocus;

  /// Text input action
  final TextInputAction? textInputAction;

  /// On submitted callback
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            widget.label,
            style: AppTextStyles.inputLabel.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
        ),

        // Input field
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && _obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          style: AppTextStyles.inputText.copyWith(
            color: AppColors.textPrimaryDark,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.inputText.copyWith(
              color: AppColors.placeholder,
            ),
            filled: true,
            fillColor: AppColors.inputBackgroundDark,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorderDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            suffixIcon: _buildSuffixIcon(),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // Password toggle
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.placeholder,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // Static suffix icon
    if (widget.suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Icon(widget.suffixIcon, color: AppColors.placeholder, size: 20),
      );
    }

    return null;
  }
}
