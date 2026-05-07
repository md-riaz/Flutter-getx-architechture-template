import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/theme/theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme has correct configuration', () {
      final lightTheme = AppTheme.light;

      expect(lightTheme.useMaterial3, isTrue);
      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.scaffoldBackgroundColor, AppColors.lightBackground);
    });

    test('dark theme has correct configuration', () {
      final darkTheme = AppTheme.dark;

      expect(darkTheme.useMaterial3, isTrue);
      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.scaffoldBackgroundColor, AppColors.darkBackground);
    });

    test('light theme uses AppColors for primary color', () {
      final lightTheme = AppTheme.light;

      expect(
        lightTheme.colorScheme.primary,
        AppColors.primary,
      );
    });

    test('dark theme uses AppColors for primary color', () {
      final darkTheme = AppTheme.dark;

      expect(
        darkTheme.colorScheme.primary,
        AppColors.primary,
      );
    });

    test('light theme has correct AppBar configuration', () {
      final lightTheme = AppTheme.light;

      expect(lightTheme.appBarTheme.centerTitle, isFalse);
      expect(lightTheme.appBarTheme.elevation, AppThemeConfig.appBarElevation);
      expect(lightTheme.appBarTheme.backgroundColor, AppColors.lightSurface);
    });

    test('dark theme has correct AppBar configuration', () {
      final darkTheme = AppTheme.dark;

      expect(darkTheme.appBarTheme.centerTitle, isFalse);
      expect(darkTheme.appBarTheme.elevation, AppThemeConfig.appBarElevation);
      expect(darkTheme.appBarTheme.backgroundColor, AppColors.darkSurface);
    });

    test('light theme has correct Card configuration', () {
      final lightTheme = AppTheme.light;

      expect(lightTheme.cardTheme.elevation, AppThemeConfig.cardElevation);
      expect(lightTheme.cardTheme.color, AppColors.lightSurface);
      expect(lightTheme.cardTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('dark theme has correct Card configuration', () {
      final darkTheme = AppTheme.dark;

      expect(darkTheme.cardTheme.elevation, AppThemeConfig.cardElevation);
      expect(darkTheme.cardTheme.color, AppColors.darkSurface);
      expect(darkTheme.cardTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('light theme input decoration uses correct border radius', () {
      final lightTheme = AppTheme.light;
      final inputBorder = lightTheme.inputDecorationTheme.border;

      expect(inputBorder, isA<OutlineInputBorder>());
    });

    test('dark theme input decoration uses correct border radius', () {
      final darkTheme = AppTheme.dark;
      final inputBorder = darkTheme.inputDecorationTheme.border;

      expect(inputBorder, isA<OutlineInputBorder>());
    });

    test('light theme uses correct font family', () {
      final lightTheme = AppTheme.light;

      expect(lightTheme.textTheme.bodyMedium?.fontFamily,
          AppThemeConfig.fontFamilyPrimary);
    });

    test('dark theme uses correct font family', () {
      final darkTheme = AppTheme.dark;

      expect(darkTheme.textTheme.bodyMedium?.fontFamily,
          AppThemeConfig.fontFamilyPrimary);
    });

    testWidgets('light theme renders correctly in MaterialApp',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: const Center(child: Text('Test Body')),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.text('Test Body'), findsOneWidget);
    });

    testWidgets('dark theme renders correctly in MaterialApp',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: const Center(child: Text('Test Body')),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.text('Test Body'), findsOneWidget);
    });
  });

  group('AppColors', () {
    test('has correct primary color', () {
      expect(AppColors.primary, const Color(0xFF6366F1));
    });

    test('has correct secondary color', () {
      expect(AppColors.secondary, const Color(0xFF8B5CF6));
    });

    test('has correct accent color', () {
      expect(AppColors.accent, const Color(0xFFEC4899));
    });

    test('has correct semantic colors', () {
      expect(AppColors.success, const Color(0xFF10B981));
      expect(AppColors.warning, const Color(0xFFF59E0B));
      expect(AppColors.error, const Color(0xFFEF4444));
      expect(AppColors.info, const Color(0xFF3B82F6));
    });

    test('has correct light theme colors', () {
      expect(AppColors.lightBackground, const Color(0xFFFAFAFA));
      expect(AppColors.lightSurface, const Color(0xFFFFFFFF));
      expect(AppColors.lightTextPrimary, const Color(0xFF1F2937));
      expect(AppColors.lightTextSecondary, const Color(0xFF6B7280));
      expect(AppColors.lightDivider, const Color(0xFFE5E7EB));
    });

    test('has correct dark theme colors', () {
      expect(AppColors.darkBackground, const Color(0xFF111827));
      expect(AppColors.darkSurface, const Color(0xFF1F2937));
      expect(AppColors.darkTextPrimary, const Color(0xFFF9FAFB));
      expect(AppColors.darkTextSecondary, const Color(0xFF9CA3AF));
      expect(AppColors.darkDivider, const Color(0xFF374151));
    });

    test('has correct gradients', () {
      expect(AppColors.primaryGradient, isA<LinearGradient>());
      expect(AppColors.accentGradient, isA<LinearGradient>());
      expect(AppColors.primaryGradient.colors.length, 2);
      expect(AppColors.accentGradient.colors.length, 2);
    });
  });

  group('AppThemeConfig', () {
    test('has correct spacing values', () {
      expect(AppThemeConfig.spaceXS, 4.0);
      expect(AppThemeConfig.spaceS, 8.0);
      expect(AppThemeConfig.spaceM, 16.0);
      expect(AppThemeConfig.spaceL, 24.0);
      expect(AppThemeConfig.spaceXL, 32.0);
      expect(AppThemeConfig.spaceXXL, 48.0);
    });

    test('has correct border radius values', () {
      expect(AppThemeConfig.radiusS, 4.0);
      expect(AppThemeConfig.radiusM, 8.0);
      expect(AppThemeConfig.radiusL, 12.0);
      expect(AppThemeConfig.radiusXL, 16.0);
      expect(AppThemeConfig.radiusCircular, 9999.0);
    });

    test('has correct elevation values', () {
      expect(AppThemeConfig.elevationNone, 0.0);
      expect(AppThemeConfig.elevationLow, 1.0);
      expect(AppThemeConfig.elevationMedium, 2.0);
      expect(AppThemeConfig.elevationHigh, 4.0);
      expect(AppThemeConfig.elevationXHigh, 8.0);
    });

    test('has correct component values', () {
      expect(AppThemeConfig.appBarHeight, 56.0);
      expect(AppThemeConfig.cardBorderRadius, 12.0);
      expect(AppThemeConfig.buttonHeight, 48.0);
      expect(AppThemeConfig.inputBorderRadius, 8.0);
    });

    test('has correct animation durations', () {
      expect(AppThemeConfig.animationFast, const Duration(milliseconds: 150));
      expect(AppThemeConfig.animationNormal, const Duration(milliseconds: 300));
      expect(AppThemeConfig.animationSlow, const Duration(milliseconds: 500));
    });

    test('has correct breakpoint values', () {
      expect(AppThemeConfig.breakpointMobile, 600.0);
      expect(AppThemeConfig.breakpointTablet, 900.0);
      expect(AppThemeConfig.breakpointDesktop, 900.0);
    });

    test('has correct icon sizes', () {
      expect(AppThemeConfig.iconSizeS, 16.0);
      expect(AppThemeConfig.iconSizeM, 24.0);
      expect(AppThemeConfig.iconSizeL, 32.0);
      expect(AppThemeConfig.iconSizeXL, 48.0);
    });

    test('borderRadius helper returns correct BorderRadius', () {
      final borderRadius = AppThemeConfig.borderRadius(10.0);
      expect(borderRadius, isA<BorderRadius>());
      expect(borderRadius.topLeft.x, 10.0);
    });

    test('cardShape helper returns correct shape', () {
      final cardShape = AppThemeConfig.cardShape;
      expect(cardShape, isA<RoundedRectangleBorder>());
    });

    test('buttonShape helper returns correct shape', () {
      final buttonShape = AppThemeConfig.buttonShape;
      expect(buttonShape, isA<RoundedRectangleBorder>());
    });

    test('inputBorder helper returns correct border', () {
      final inputBorder = AppThemeConfig.inputBorder;
      expect(inputBorder, isA<OutlineInputBorder>());
    });

    test('font family configuration exists', () {
      expect(AppThemeConfig.fontFamilyPrimary, 'Roboto');
      expect(AppThemeConfig.fontFamilySecondary, isNull);
    });

    test('has comprehensive font size configuration', () {
      expect(AppThemeConfig.fontSizeDisplayLarge, 57.0);
      expect(AppThemeConfig.fontSizeDisplayMedium, 45.0);
      expect(AppThemeConfig.fontSizeDisplaySmall, 36.0);
      expect(AppThemeConfig.fontSizeHeadlineLarge, 32.0);
      expect(AppThemeConfig.fontSizeHeadlineMedium, 28.0);
      expect(AppThemeConfig.fontSizeHeadlineSmall, 24.0);
      expect(AppThemeConfig.fontSizeTitleLarge, 22.0);
      expect(AppThemeConfig.fontSizeTitleMedium, 16.0);
      expect(AppThemeConfig.fontSizeTitleSmall, 14.0);
      expect(AppThemeConfig.fontSizeBodyLarge, 16.0);
      expect(AppThemeConfig.fontSizeBodyMedium, 14.0);
      expect(AppThemeConfig.fontSizeBodySmall, 12.0);
      expect(AppThemeConfig.fontSizeLabelLarge, 14.0);
      expect(AppThemeConfig.fontSizeLabelMedium, 12.0);
      expect(AppThemeConfig.fontSizeLabelSmall, 11.0);
    });
  });
}
