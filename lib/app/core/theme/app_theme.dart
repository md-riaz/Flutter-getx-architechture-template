import 'package:flutter/material.dart';
import 'tokens.dart';

/// Application theme configuration using Material 3
class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppTokens.seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Card theme
      cardTheme: CardTheme(
        elevation: AppTokens.elevation1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius16),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spacing16,
          vertical: AppTokens.spacing12,
        ),
      ),

      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius16),
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spacing24,
            vertical: AppTokens.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radius12),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spacing24,
            vertical: AppTokens.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radius12),
          ),
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: AppTokens.elevation0,
        scrolledUnderElevation: AppTokens.elevation2,
      ),

      // List tile theme
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius8),
        ),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius24),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppTokens.seedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Card theme
      cardTheme: CardTheme(
        elevation: AppTokens.elevation1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius16),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spacing16,
          vertical: AppTokens.spacing12,
        ),
      ),

      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius16),
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spacing24,
            vertical: AppTokens.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radius12),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spacing24,
            vertical: AppTokens.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radius12),
          ),
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: AppTokens.elevation0,
        scrolledUnderElevation: AppTokens.elevation2,
      ),

      // List tile theme
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius8),
        ),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radius24),
        ),
      ),
    );
  }
}
