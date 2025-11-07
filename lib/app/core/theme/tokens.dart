import 'package:flutter/material.dart';

/// Design tokens for spacing, sizing, and timing
class AppTokens {
  // Spacing - 8-point grid
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Border Radius
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius24 = 24.0;
  static const double radiusFull = 9999.0;

  // Animation Durations
  static const Duration duration120ms = Duration(milliseconds: 120);
  static const Duration duration200ms = Duration(milliseconds: 200);
  static const Duration duration300ms = Duration(milliseconds: 300);
  static const Duration duration500ms = Duration(milliseconds: 500);

  // Elevations
  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation4 = 4;
  static const double elevation8 = 8;

  // Seed Color - Restrained Red Accent
  static const Color seedColor = Color(0xFFB00020);

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
}
