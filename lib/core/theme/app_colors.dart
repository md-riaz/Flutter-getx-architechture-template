import 'package:flutter/material.dart';

/// Centralized color definitions for the app theme.
///
/// This class provides a structured way to define and manage all colors
/// used throughout the application. Update these values to customize
/// your app's brand colors.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ============================================
  // PRIMARY BRAND COLORS
  // ============================================

  /// Primary brand color - main color representing your brand
  /// Used for primary buttons, app bars, and key UI elements
  static const Color primary = Color(0xFF6366F1); // Indigo

  /// Secondary brand color - complementary to primary
  /// Used for floating action buttons, selection controls, and highlights
  static const Color secondary = Color(0xFF8B5CF6); // Purple

  /// Accent color - for emphasis and call-to-action elements
  /// Used sparingly to draw attention to important actions
  static const Color accent = Color(0xFFEC4899); // Pink

  // ============================================
  // SEMANTIC COLORS
  // ============================================

  /// Success color - for positive actions and confirmations
  static const Color success = Color(0xFF10B981); // Green

  /// Warning color - for cautionary messages
  static const Color warning = Color(0xFFF59E0B); // Amber

  /// Error color - for errors and destructive actions
  static const Color error = Color(0xFFEF4444); // Red

  /// Info color - for informational messages
  static const Color info = Color(0xFF3B82F6); // Blue

  // ============================================
  // NEUTRAL COLORS - LIGHT THEME
  // ============================================

  /// Light theme background color
  static const Color lightBackground = Color(0xFFFAFAFA);

  /// Light theme surface color (cards, sheets)
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Light theme text color - primary
  static const Color lightTextPrimary = Color(0xFF1F2937);

  /// Light theme text color - secondary
  static const Color lightTextSecondary = Color(0xFF6B7280);

  /// Light theme divider color
  static const Color lightDivider = Color(0xFFE5E7EB);

  // ============================================
  // NEUTRAL COLORS - DARK THEME
  // ============================================

  /// Dark theme background color
  static const Color darkBackground = Color(0xFF111827);

  /// Dark theme surface color (cards, sheets)
  static const Color darkSurface = Color(0xFF1F2937);

  /// Dark theme text color - primary
  static const Color darkTextPrimary = Color(0xFFF9FAFB);

  /// Dark theme text color - secondary
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  /// Dark theme divider color
  static const Color darkDivider = Color(0xFF374151);

  // ============================================
  // GRADIENT COLORS
  // ============================================

  /// Primary gradient - for decorative backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient - for special highlights
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================
  // SHADOW COLORS
  // ============================================

  /// Light shadow color
  static final Color lightShadow = Colors.black.withValues(alpha: (0.1 * 255));

  /// Dark shadow color
  static final Color darkShadow = Colors.black.withValues(alpha: (0.3 * 255));
}
