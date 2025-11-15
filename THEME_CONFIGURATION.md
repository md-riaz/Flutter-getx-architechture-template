# Theme Configuration Guide

This document explains how to configure and customize the app's theme to match your brand identity.

## Overview

The theme system is built with three main components:

1. **AppColors** - Centralized color definitions
2. **AppThemeConfig** - Typography, spacing, and component configurations
3. **AppTheme** - Material 3 theme implementation

## Quick Start

### Customizing Brand Colors

To change your app's primary colors, edit `lib/core/theme/app_colors.dart`:

```dart
class AppColors {
  // Change these to match your brand
  static const Color primary = Color(0xFF6366F1);    // Your primary brand color
  static const Color secondary = Color(0xFF8B5CF6);  // Your secondary color
  static const Color accent = Color(0xFFEC4899);     // Your accent color
  
  // ... other colors
}
```

### Customizing Typography and Spacing

To adjust typography, spacing, or border radius, edit `lib/core/theme/app_theme_config.dart`:

```dart
class AppThemeConfig {
  // Font configuration
  static const String fontFamilyPrimary = 'Roboto'; // Change to your font
  
  // Spacing
  static const double spaceM = 16.0;  // Adjust as needed
  
  // Border radius
  static const double radiusM = 8.0;  // Adjust roundness
  
  // ... other configurations
}
```

## Color System

### Brand Colors

```dart
AppColors.primary    // Main brand color (buttons, app bars)
AppColors.secondary  // Complementary color (FABs, highlights)
AppColors.accent     // Emphasis color (CTAs, important actions)
```

### Semantic Colors

```dart
AppColors.success    // Green - Success states
AppColors.warning    // Amber - Warnings
AppColors.error      // Red - Errors
AppColors.info       // Blue - Information
```

### Theme Colors

Light theme:
```dart
AppColors.lightBackground      // Page background
AppColors.lightSurface         // Card/sheet background
AppColors.lightTextPrimary     // Primary text
AppColors.lightTextSecondary   // Secondary text
AppColors.lightDivider         // Dividers
```

Dark theme:
```dart
AppColors.darkBackground       // Page background
AppColors.darkSurface          // Card/sheet background
AppColors.darkTextPrimary      // Primary text
AppColors.darkTextSecondary    // Secondary text
AppColors.darkDivider          // Dividers
```

### Gradients

```dart
AppColors.primaryGradient  // Primary to secondary gradient
AppColors.accentGradient   // Accent to secondary gradient
```

## Using Colors in Your Code

### Option 1: Use Theme Colors (Recommended)

This automatically adapts to light/dark theme:

```dart
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
  ),
)
```

### Option 2: Use AppColors Directly

For specific brand colors:

```dart
Container(
  color: AppColors.primary,
  child: Icon(Icons.star, color: AppColors.accent),
)
```

## Typography Configuration

### Font Families

```dart
AppThemeConfig.fontFamilyPrimary    // Main font (default: Roboto)
AppThemeConfig.fontFamilySecondary  // Optional secondary font
```

### Font Sizes

Available size constants:

```dart
// Display sizes (largest)
AppThemeConfig.fontSizeDisplayLarge   // 57px
AppThemeConfig.fontSizeDisplayMedium  // 45px
AppThemeConfig.fontSizeDisplaySmall   // 36px

// Headline sizes
AppThemeConfig.fontSizeHeadlineLarge   // 32px
AppThemeConfig.fontSizeHeadlineMedium  // 28px
AppThemeConfig.fontSizeHeadlineSmall   // 24px

// Title sizes
AppThemeConfig.fontSizeTitleLarge   // 22px
AppThemeConfig.fontSizeTitleMedium  // 16px
AppThemeConfig.fontSizeTitleSmall   // 14px

// Body sizes
AppThemeConfig.fontSizeBodyLarge   // 16px
AppThemeConfig.fontSizeBodyMedium  // 14px
AppThemeConfig.fontSizeBodySmall   // 12px

// Label sizes (smallest)
AppThemeConfig.fontSizeLabelLarge   // 14px
AppThemeConfig.fontSizeLabelMedium  // 12px
AppThemeConfig.fontSizeLabelSmall   // 11px
```

### Using Typography

```dart
Text(
  'Headline',
  style: Theme.of(context).textTheme.headlineSmall,
)

Text(
  'Body text',
  style: Theme.of(context).textTheme.bodyMedium,
)
```

## Spacing System

Use consistent spacing throughout your app:

```dart
AppThemeConfig.spaceXS    // 4px
AppThemeConfig.spaceS     // 8px
AppThemeConfig.spaceM     // 16px
AppThemeConfig.spaceL     // 24px
AppThemeConfig.spaceXL    // 32px
AppThemeConfig.spaceXXL   // 48px
```

Example:

```dart
Padding(
  padding: EdgeInsets.all(AppThemeConfig.spaceM),
  child: Column(
    spacing: AppThemeConfig.spaceS,
    children: [...],
  ),
)
```

## Border Radius

Consistent rounded corners:

```dart
AppThemeConfig.radiusS         // 4px - Subtle rounding
AppThemeConfig.radiusM         // 8px - Standard rounding
AppThemeConfig.radiusL         // 12px - Prominent rounding
AppThemeConfig.radiusXL        // 16px - Extra rounding
AppThemeConfig.radiusCircular  // 9999px - Fully circular
```

Example:

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.radiusM),
    color: AppColors.primary,
  ),
)
```

## Component Styling

### Cards

```dart
AppThemeConfig.cardElevation      // Default: 2dp
AppThemeConfig.cardBorderRadius   // Default: 12px
AppThemeConfig.cardShape          // Pre-configured shape
```

### Buttons

```dart
AppThemeConfig.buttonHeight        // Default: 48px
AppThemeConfig.buttonBorderRadius  // Default: 8px
AppThemeConfig.buttonShape         // Pre-configured shape
```

### Input Fields

```dart
AppThemeConfig.inputBorderRadius   // Default: 8px
AppThemeConfig.inputContentPadding // Default: 16px horizontal & vertical
AppThemeConfig.inputBorder         // Pre-configured border
```

### Icons

```dart
AppThemeConfig.iconSizeS   // 16px
AppThemeConfig.iconSizeM   // 24px
AppThemeConfig.iconSizeL   // 32px
AppThemeConfig.iconSizeXL  // 48px
```

## Elevation System

Consistent shadow depths:

```dart
AppThemeConfig.elevationNone    // 0dp - Flat
AppThemeConfig.elevationLow     // 1dp - Subtle
AppThemeConfig.elevationMedium  // 2dp - Standard
AppThemeConfig.elevationHigh    // 4dp - Raised
AppThemeConfig.elevationXHigh   // 8dp - Floating
```

## Animation Durations

```dart
AppThemeConfig.animationFast    // 150ms
AppThemeConfig.animationNormal  // 300ms
AppThemeConfig.animationSlow    // 500ms
```

Example:

```dart
AnimatedContainer(
  duration: AppThemeConfig.animationNormal,
  color: isActive ? AppColors.primary : AppColors.lightSurface,
)
```

## Responsive Breakpoints

```dart
AppThemeConfig.breakpointMobile   // < 600px
AppThemeConfig.breakpointTablet   // < 900px
AppThemeConfig.breakpointDesktop  // >= 900px
```

Use with the existing `ResponsiveBuilder`:

```dart
ResponsiveBuilder(
  builder: (context, deviceType) {
    return Container(
      padding: EdgeInsets.all(
        deviceType == DeviceType.mobile 
          ? AppThemeConfig.spaceM 
          : AppThemeConfig.spaceXL,
      ),
      child: YourWidget(),
    );
  },
)
```

## Complete Example

Here's a complete example using the theme system:

```dart
import 'package:flutter/material.dart';
import 'package:getx_modular_template/core/theme/theme.dart';

class BrandedCard extends StatelessWidget {
  final String title;
  final String description;
  
  const BrandedCard({
    required this.title,
    required this.description,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppThemeConfig.cardElevation,
      shape: AppThemeConfig.cardShape,
      child: Padding(
        padding: EdgeInsets.all(AppThemeConfig.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with custom color
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppThemeConfig.spaceS),
            
            // Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppThemeConfig.spaceM),
            
            // Action button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: AppThemeConfig.buttonShape,
              ),
              child: const Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Best Practices

1. **Always use Theme.of(context)** for colors that should adapt to light/dark mode
2. **Use AppColors** for specific brand colors that don't change
3. **Use AppThemeConfig constants** for consistent spacing, sizing, and styling
4. **Import from barrel file** for convenience:
   ```dart
   import 'package:getx_modular_template/core/theme/theme.dart';
   ```
5. **Test both themes** - Always verify your UI in both light and dark modes
6. **Keep it consistent** - Use the same spacing/sizing values throughout the app

## Customization Checklist

When branding your app, update these in order:

- [ ] Brand colors in `AppColors` (primary, secondary, accent)
- [ ] Font family in `AppThemeConfig` (if using custom fonts)
- [ ] Border radius in `AppThemeConfig` (for your preferred roundness)
- [ ] Component-specific settings (card elevation, button height, etc.)
- [ ] Test in both light and dark themes
- [ ] Verify on different screen sizes (mobile, tablet, desktop)

## Adding Custom Fonts

1. Add font files to `assets/fonts/` directory
2. Update `pubspec.yaml`:
   ```yaml
   flutter:
     fonts:
       - family: YourCustomFont
         fonts:
           - asset: assets/fonts/YourFont-Regular.ttf
           - asset: assets/fonts/YourFont-Bold.ttf
             weight: 700
   ```
3. Update `AppThemeConfig`:
   ```dart
   static const String fontFamilyPrimary = 'YourCustomFont';
   ```

## Further Customization

For advanced customization beyond what's provided:

1. Add new colors to `AppColors`
2. Add new configuration constants to `AppThemeConfig`
3. Extend theme properties in `AppTheme.light` and `AppTheme.dark`
4. Keep the structure consistent for maintainability

## Support

For questions or issues with theme configuration, please refer to:
- [Flutter Material 3 Documentation](https://m3.material.io/)
- [Flutter ThemeData Documentation](https://api.flutter.dev/flutter/material/ThemeData-class.html)
