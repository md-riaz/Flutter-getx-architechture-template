import 'package:flutter/material.dart';

/// Centralized theme configuration for the entire application.
///
/// This class provides a single source of truth for all theme-related
/// configurations including colors, typography, spacing, borders, and more.
/// Modify these values to customize your app's look and feel.
class AppThemeConfig {
  // Prevent instantiation
  AppThemeConfig._();

  // ============================================
  // SPACING
  // ============================================

  /// Extra small spacing (4px)
  static const double spaceXS = 4.0;

  /// Small spacing (8px)
  static const double spaceS = 8.0;

  /// Medium spacing (16px)
  static const double spaceM = 16.0;

  /// Large spacing (24px)
  static const double spaceL = 24.0;

  /// Extra large spacing (32px)
  static const double spaceXL = 32.0;

  /// Extra extra large spacing (48px)
  static const double spaceXXL = 48.0;

  // ============================================
  // BORDER RADIUS
  // ============================================

  /// Small border radius (4px)
  static const double radiusS = 4.0;

  /// Medium border radius (8px)
  static const double radiusM = 8.0;

  /// Large border radius (12px)
  static const double radiusL = 12.0;

  /// Extra large border radius (16px)
  static const double radiusXL = 16.0;

  /// Circular border radius (9999px)
  static const double radiusCircular = 9999.0;

  // ============================================
  // ELEVATION
  // ============================================

  /// No elevation
  static const double elevationNone = 0.0;

  /// Low elevation (1dp)
  static const double elevationLow = 1.0;

  /// Medium elevation (2dp)
  static const double elevationMedium = 2.0;

  /// High elevation (4dp)
  static const double elevationHigh = 4.0;

  /// Extra high elevation (8dp)
  static const double elevationXHigh = 8.0;

  // ============================================
  // TYPOGRAPHY - FONT FAMILIES
  // ============================================

  /// Primary font family for the app
  /// Update this to use your custom brand font
  static const String fontFamilyPrimary = 'Roboto';

  /// Secondary font family (optional)
  /// Can be used for headings or special text
  static const String? fontFamilySecondary = null;

  // ============================================
  // TYPOGRAPHY - FONT SIZES
  // ============================================

  /// Display large font size (57px)
  static const double fontSizeDisplayLarge = 57.0;

  /// Display medium font size (45px)
  static const double fontSizeDisplayMedium = 45.0;

  /// Display small font size (36px)
  static const double fontSizeDisplaySmall = 36.0;

  /// Headline large font size (32px)
  static const double fontSizeHeadlineLarge = 32.0;

  /// Headline medium font size (28px)
  static const double fontSizeHeadlineMedium = 28.0;

  /// Headline small font size (24px)
  static const double fontSizeHeadlineSmall = 24.0;

  /// Title large font size (22px)
  static const double fontSizeTitleLarge = 22.0;

  /// Title medium font size (16px)
  static const double fontSizeTitleMedium = 16.0;

  /// Title small font size (14px)
  static const double fontSizeTitleSmall = 14.0;

  /// Body large font size (16px)
  static const double fontSizeBodyLarge = 16.0;

  /// Body medium font size (14px)
  static const double fontSizeBodyMedium = 14.0;

  /// Body small font size (12px)
  static const double fontSizeBodySmall = 12.0;

  /// Label large font size (14px)
  static const double fontSizeLabelLarge = 14.0;

  /// Label medium font size (12px)
  static const double fontSizeLabelMedium = 12.0;

  /// Label small font size (11px)
  static const double fontSizeLabelSmall = 11.0;

  // ============================================
  // COMPONENT SPECIFIC
  // ============================================

  /// AppBar height
  static const double appBarHeight = 56.0;

  /// AppBar elevation
  static const double appBarElevation = elevationNone;

  /// Card elevation
  static const double cardElevation = elevationMedium;

  /// Card border radius
  static const double cardBorderRadius = radiusL;

  /// Button height
  static const double buttonHeight = 48.0;

  /// Button border radius
  static const double buttonBorderRadius = radiusM;

  /// Input field border radius
  static const double inputBorderRadius = radiusM;

  /// Input field content padding
  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: spaceM,
    vertical: spaceM,
  );

  /// Dialog border radius
  static const double dialogBorderRadius = radiusXL;

  /// Bottom sheet border radius
  static const double bottomSheetBorderRadius = radiusXL;

  // ============================================
  // ANIMATION DURATIONS
  // ============================================

  /// Fast animation duration (150ms)
  static const Duration animationFast = Duration(milliseconds: 150);

  /// Normal animation duration (300ms)
  static const Duration animationNormal = Duration(milliseconds: 300);

  /// Slow animation duration (500ms)
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============================================
  // BREAKPOINTS (for responsive design)
  // ============================================

  /// Mobile breakpoint (< 600px)
  static const double breakpointMobile = 600.0;

  /// Tablet breakpoint (< 900px)
  static const double breakpointTablet = 900.0;

  /// Desktop breakpoint (>= 900px)
  static const double breakpointDesktop = 900.0;

  // ============================================
  // ICON SIZES
  // ============================================

  /// Small icon size (16px)
  static const double iconSizeS = 16.0;

  /// Medium icon size (24px)
  static const double iconSizeM = 24.0;

  /// Large icon size (32px)
  static const double iconSizeL = 32.0;

  /// Extra large icon size (48px)
  static const double iconSizeXL = 48.0;

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Get rounded border radius
  static BorderRadius borderRadius(double radius) {
    return BorderRadius.circular(radius);
  }

  /// Get card shape with default border radius
  static RoundedRectangleBorder get cardShape {
    return RoundedRectangleBorder(
      borderRadius: borderRadius(cardBorderRadius),
    );
  }

  /// Get button shape with default border radius
  static RoundedRectangleBorder get buttonShape {
    return RoundedRectangleBorder(
      borderRadius: borderRadius(buttonBorderRadius),
    );
  }

  /// Get input border with default border radius
  static OutlineInputBorder get inputBorder {
    return OutlineInputBorder(
      borderRadius: borderRadius(inputBorderRadius),
    );
  }
}
