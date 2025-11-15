# Responsive Design Guide

This document explains how the responsive design system works in this Flutter GetX template.

## Overview

The template automatically adapts to different screen sizes, providing an optimal user experience across mobile phones, tablets, and desktop computers.

## Breakpoints

The responsive system uses three breakpoints:

| Device | Width Range | Description |
|--------|-------------|-------------|
| **Mobile** | < 600px | Smartphones in portrait and landscape mode |
| **Tablet** | 600px - 900px | Tablets and small desktop windows |
| **Desktop** | > 900px | Desktop computers and large tablets |

## Layout Adaptations

### Navigation

The navigation system automatically adapts based on screen size:

#### Mobile (< 600px)
- **AppBar** at the top with hamburger menu
- **Drawer** slides from left side with app branding
- **Bottom Navigation Bar** for quick access to main sections
- Compact spacing and single-column layouts

#### Tablet (600px - 900px)
- **AppBar** at the top
- **Compact Navigation Rail** on the left side
- No bottom navigation bar
- Two-column layouts for content
- Medium spacing

#### Desktop (> 900px)
- **AppBar** at the top with full actions
- **Extended Navigation Rail** on the left side with labels
- Multi-column layouts (3-4 columns)
- Large spacing for better readability
- Side-by-side content arrangement

## Component Behavior

### AppLayout

The `AppLayout` widget is the main responsive wrapper:

```dart
AppLayout(
  title: 'My Page',
  navigationItems: NavigationConfig.mainNavigationItems,
  body: YourContent(),
)
```

**Automatic Features:**
- Switches between drawer, bottom nav, and navigation rail
- Manages navigation state
- Handles route transitions
- Provides consistent AppBar

### ResponsiveBuilder

Build different UIs for different screen sizes:

```dart
ResponsiveBuilder(
  builder: (context, deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return MobileLayout();
      case DeviceType.tablet:
        return TabletLayout();
      case DeviceType.desktop:
        return DesktopLayout();
    }
  },
)
```

### Responsive Values

Use responsive values for spacing, sizing, and columns:

```dart
// Padding
padding: EdgeInsets.all(
  context.responsive(
    mobile: 16.0,
    tablet: 24.0,
    desktop: 32.0,
  ),
)

// Grid columns
crossAxisCount: context.responsive(
  mobile: 1,
  tablet: 2,
  desktop: 3,
)
```

## Design Patterns

### Content Layout

**Mobile:**
- Single column
- Full-width cards
- Stack content vertically
- Minimal padding (16px)

**Tablet:**
- Two columns
- Balanced card sizes
- Mix of vertical and horizontal layouts
- Medium padding (24px)

**Desktop:**
- Three or more columns
- Grid-based layouts
- Side-by-side content
- Generous padding (32px)

### Typography

The template uses Material Design 3 typography that scales appropriately:
- Headlines remain readable on small screens
- Body text maintains optimal line length
- Buttons have touch-friendly sizes on mobile

### Interactive Elements

**Mobile:**
- Larger touch targets (48x48 minimum)
- Floating Action Button for primary actions
- Bottom sheets for options
- Pull-to-refresh support

**Tablet/Desktop:**
- Standard button sizes
- Hover states on interactive elements
- Context menus
- Keyboard shortcuts support

## Examples in the App

The **Examples** page demonstrates all responsive features:

1. **Device Detection Card**
   - Shows current device type
   - Updates when resizing window
   - Displays appropriate icon

2. **Responsive Grid**
   - 1 column on mobile
   - 2 columns on tablet
   - 4 columns on desktop
   - Equal spacing

3. **Adaptive Layout Cards**
   - Different layouts for each device
   - Visual indication of current mode
   - Shows spacing differences

4. **Component Showcase**
   - Cards that adapt their width
   - Responsive wrap layout
   - Maintains aspect ratios

## Best Practices

### DO ✅

- Always use `AppLayout` for consistent navigation
- Use `ResponsiveBuilder` for layout changes
- Use `context.responsive()` for values
- Test on multiple screen sizes
- Consider touch targets on mobile (minimum 48x48)
- Use appropriate spacing for each device type
- Keep content readable at all sizes

### DON'T ❌

- Don't hardcode fixed widths
- Don't assume screen orientation
- Don't use tiny touch targets on mobile
- Don't ignore tablet sizes
- Don't create mobile-only or desktop-only experiences
- Don't forget to test responsive behavior

## Testing Responsive Design

### Browser DevTools
1. Open your Flutter web app
2. Press F12 to open DevTools
3. Click the device toolbar icon
4. Select different device presets
5. Or manually resize the window

### Flutter DevTools
1. Run your Flutter app
2. Open Flutter DevTools
3. Use the Layout Explorer
4. Check different screen sizes

### Physical Testing
- Test on actual devices when possible
- Check both portrait and landscape
- Verify touch interactions
- Test on different OS versions

## Customization

### Changing Breakpoints

Edit `lib/core/widgets/responsive_builder.dart`:

```dart
class Breakpoints {
  static const double mobile = 600;   // Change these values
  static const double tablet = 900;
  static const double desktop = 1200;
}
```

### Adding New Breakpoints

You can extend the `DeviceType` enum:

```dart
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,  // Add new types
}
```

Then update the `getDeviceType` method accordingly.

### Custom Responsive Widgets

Create your own responsive widgets:

```dart
class MyResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBuilder.isMobile(context);
    
    return Container(
      padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
      child: isMobile ? MobileView() : DesktopView(),
    );
  }
}
```

## Platform-Specific Considerations

### Web
- Resize browser window to test
- Consider keyboard navigation
- Mouse hover states
- URL-based navigation

### Mobile (iOS/Android)
- Test both portrait and landscape
- Consider safe areas (notches, home indicators)
- Touch gestures
- Platform-specific navigation patterns

### Desktop (Windows/macOS/Linux)
- Window resizing
- Keyboard shortcuts
- Mouse interactions
- Native menu bars

## Resources

- [Material Design 3 Guidelines](https://m3.material.io/)
- [Flutter Responsive Design](https://flutter.dev/docs/development/ui/layout/responsive)
- [GetX Documentation](https://pub.dev/packages/get)

## Summary

This responsive design system ensures your app:
- ✅ Works seamlessly on all screen sizes
- ✅ Provides appropriate navigation for each device
- ✅ Maintains consistent branding and UX
- ✅ Follows Material Design 3 principles
- ✅ Is easy to customize and extend

Visit the **Examples** page in the app to see all these concepts in action!
