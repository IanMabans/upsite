import 'package:get/get.dart';

/// Input validators for form fields.
///
/// All validation methods return null for valid input,
/// or an error message string for invalid input.
class Validators {
  Validators._();

  // ===========================================
  // EMAIL VALIDATION
  // ===========================================

  /// Validates email address format.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // ===========================================
  // PASSWORD VALIDATION
  // ===========================================

  /// Validates password meets minimum requirements.
  ///
  /// Requirements:
  /// - At least 8 characters
  /// - Contains at least one letter
  /// - Contains at least one number
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validates confirm password matches password.
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ===========================================
  // GENERAL VALIDATION
  // ===========================================

  /// Validates required field is not empty.
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validates URL format.
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }

    if (!GetUtils.isURL(value.trim())) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validates minimum length.
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  /// Validates maximum length.
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be less than $maxLength characters';
    }
    return null;
  }

  // ===========================================
  // PASSWORD STRENGTH
  // ===========================================

  /// Calculate password strength (0-4)
  ///
  /// Returns:
  /// - 0: Very weak (empty or < 6 chars)
  /// - 1: Weak (6+ chars)
  /// - 2: Fair (8+ chars with letters)
  /// - 3: Good (8+ chars with letters and numbers)
  /// - 4: Strong (10+ chars with letters, numbers, and special chars)
  static int passwordStrength(String? value) {
    if (value == null || value.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (value.length >= 6) strength++;
    if (value.length >= 8) strength++;
    if (value.length >= 10) strength++;

    // Complexity checks
    if (RegExp(r'[a-zA-Z]').hasMatch(value) &&
        RegExp(r'[0-9]').hasMatch(value)) {
      strength++;
    }

    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      strength++;
    }

    // Cap at 4
    return strength > 4 ? 4 : strength;
  }

  /// Get password strength label
  static String passwordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
        return 'Very Weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }
}
