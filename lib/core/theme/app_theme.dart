import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_theme_config.dart';

/// Application theme configuration using Material 3 design.
/// 
/// This class provides light and dark theme configurations that use
/// the centralized [AppColors] and [AppThemeConfig] for consistent
/// branding and easy customization.
/// 
/// To customize your app's theme:
/// 1. Update colors in [AppColors]
/// 2. Adjust spacing, typography, etc. in [AppThemeConfig]
/// 3. The changes will automatically apply to both light and dark themes
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        brightness: Brightness.light,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColors.lightBackground,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: AppThemeConfig.appBarElevation,
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        scrolledUnderElevation: AppThemeConfig.elevationLow,
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: AppThemeConfig.cardElevation,
        shape: AppThemeConfig.cardShape,
        color: AppColors.lightSurface,
        surfaceTintColor: AppColors.primary,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: AppThemeConfig.inputBorder,
        enabledBorder: AppThemeConfig.inputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: AppThemeConfig.inputContentPadding,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppThemeConfig.elevationLow,
          shape: AppThemeConfig.buttonShape,
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConfig.spaceL,
            vertical: AppThemeConfig.spaceM,
          ),
          minimumSize: Size.fromHeight(AppThemeConfig.buttonHeight),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: AppThemeConfig.buttonShape,
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConfig.spaceL,
            vertical: AppThemeConfig.spaceM,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: AppThemeConfig.buttonShape,
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConfig.spaceL,
            vertical: AppThemeConfig.spaceM,
          ),
          minimumSize: Size.fromHeight(AppThemeConfig.buttonHeight),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppThemeConfig.elevationMedium,
        backgroundColor: AppColors.secondary,
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        elevation: AppThemeConfig.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.dialogBorderRadius),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppThemeConfig.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppThemeConfig.bottomSheetBorderRadius),
          ),
        ),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.lightDivider,
        space: AppThemeConfig.spaceM,
        thickness: 1,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurface,
        deleteIconColor: AppColors.lightTextSecondary,
        selectedColor: AppColors.primary.withOpacity(0.2),
        secondarySelectedColor: AppColors.secondary.withOpacity(0.2),
        padding: EdgeInsets.all(AppThemeConfig.spaceS),
        labelPadding: EdgeInsets.symmetric(horizontal: AppThemeConfig.spaceS),
        shape: RoundedRectangleBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.radiusM),
        ),
      ),
      
      // Typography
      fontFamily: AppThemeConfig.fontFamilyPrimary,
    );
  }

  /// Dark theme configuration
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        brightness: Brightness.dark,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: AppThemeConfig.appBarElevation,
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        scrolledUnderElevation: AppThemeConfig.elevationLow,
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: AppThemeConfig.cardElevation,
        shape: AppThemeConfig.cardShape,
        color: AppColors.darkSurface,
        surfaceTintColor: AppColors.primary,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: AppThemeConfig.inputBorder,
        enabledBorder: AppThemeConfig.inputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: AppThemeConfig.inputContentPadding,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppThemeConfig.elevationLow,
          shape: AppThemeConfig.buttonShape,
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConfig.spaceL,
            vertical: AppThemeConfig.spaceM,
          ),
          minimumSize: Size.fromHeight(AppThemeConfig.buttonHeight),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: AppThemeConfig.buttonShape,
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConfig.spaceL,
            vertical: AppThemeConfig.spaceM,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonThemeData: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: AppThemeConfig.buttonShape,
          padding: EdgeInsets.symmetric(
            horizontal: AppThemeConfig.spaceL,
            vertical: AppThemeConfig.spaceM,
          ),
          minimumSize: Size.fromHeight(AppThemeConfig.buttonHeight),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppThemeConfig.elevationMedium,
        backgroundColor: AppColors.secondary,
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        elevation: AppThemeConfig.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.dialogBorderRadius),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppThemeConfig.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppThemeConfig.bottomSheetBorderRadius),
          ),
        ),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.darkDivider,
        space: AppThemeConfig.spaceM,
        thickness: 1,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        deleteIconColor: AppColors.darkTextSecondary,
        selectedColor: AppColors.primary.withOpacity(0.2),
        secondarySelectedColor: AppColors.secondary.withOpacity(0.2),
        padding: EdgeInsets.all(AppThemeConfig.spaceS),
        labelPadding: EdgeInsets.symmetric(horizontal: AppThemeConfig.spaceS),
        shape: RoundedRectangleBorder(
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.radiusM),
        ),
      ),
      
      // Typography
      fontFamily: AppThemeConfig.fontFamilyPrimary,
    );
  }
}
