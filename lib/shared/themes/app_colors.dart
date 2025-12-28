import 'package:flutter/material.dart';

/// App color palette based on design system.
///
/// Dark theme inspired by modern monitoring dashboards with
/// blue accent colors and semantic status colors.
class AppColors {
  AppColors._();

  // ===========================================
  // PRIMARY COLORS
  // ===========================================

  /// Primary brand color - Blue
  static const Color primary = Color(0xFF2563EB);

  /// Primary hover/pressed state
  static const Color primaryHover = Color(0xFF1D4ED8);

  /// Primary light variant for backgrounds
  static const Color primaryLight = Color(0xFF3B82F6);

  // ===========================================
  // BACKGROUND COLORS (Dark Theme)
  // ===========================================

  /// Main background color
  static const Color backgroundDark = Color(0xFF0F172A);

  /// Card/Surface background
  static const Color surfaceDark = Color(0xFF1E293B);

  /// Elevated surface (cards, modals)
  static const Color cardDark = Color(0xFF1E293B);

  /// Lighter card variant for nested elements
  static const Color cardDarkLighter = Color(0xFF334155);

  // ===========================================
  // BACKGROUND COLORS (Light Theme)
  // ===========================================

  /// Main background color - Light
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// Surface background - Light
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // ===========================================
  // BORDER COLORS
  // ===========================================

  /// Border color - Dark theme
  static const Color borderDark = Color(0xFF334155);

  /// Border color - Light theme
  static const Color borderLight = Color(0xFFE2E8F0);

  // ===========================================
  // TEXT COLORS
  // ===========================================

  /// Primary text - Dark theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);

  /// Secondary text - Dark theme
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  /// Tertiary/muted text - Dark theme
  static const Color textTertiaryDark = Color(0xFF64748B);

  /// Primary text - Light theme
  static const Color textPrimaryLight = Color(0xFF0F172A);

  /// Secondary text - Light theme
  static const Color textSecondaryLight = Color(0xFF64748B);

  // ===========================================
  // STATUS COLORS
  // ===========================================

  /// Success/Up status - Green
  static const Color success = Color(0xFF10B981);

  /// Success background
  static const Color successBackground = Color(0x1A10B981);

  /// Warning/Degraded status - Amber
  static const Color warning = Color(0xFFF59E0B);

  /// Warning background
  static const Color warningBackground = Color(0x1AF59E0B);

  /// Error/Down status - Rose/Red
  static const Color error = Color(0xFFF43F5E);

  /// Error background
  static const Color errorBackground = Color(0x1AF43F5E);

  /// Info color - Blue
  static const Color info = Color(0xFF3B82F6);

  // ===========================================
  // GRADIENT COLORS
  // ===========================================

  /// Header gradient start
  static const Color gradientStart = Color(0xFF2563EB);

  /// Header gradient end
  static const Color gradientEnd = Color(0xFF312E81);

  /// Header gradient
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradientStart, gradientEnd],
  );

  // ===========================================
  // INPUT FIELD COLORS
  // ===========================================

  /// Input background - Dark theme
  static const Color inputBackgroundDark = Color(0xFF1E293B);

  /// Input border - Dark theme
  static const Color inputBorderDark = Color(0xFF334155);

  /// Placeholder text color
  static const Color placeholder = Color(0xFF64748B);
}
