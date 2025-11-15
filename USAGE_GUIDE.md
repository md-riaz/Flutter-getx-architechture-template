# Usage Guide - GetX Modular Template

## Quick Start

This template provides a complete set of UI components and responsive layouts to jumpstart your Flutter application.

## Core Components

### 1. AppLayout - Main Layout Wrapper

The `AppLayout` widget provides automatic responsive navigation for your app.

**Features:**
- Mobile: Drawer + Bottom Navigation Bar
- Tablet: Compact Navigation Rail
- Desktop: Extended Navigation Rail

**Basic Usage:**
```dart
import 'package:your_app/core/widgets/app_layout.dart';
import 'package:your_app/core/config/navigation_config.dart';

class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'My Page',
      navigationItems: NavigationConfig.mainNavigationItems,
      body: YourContent(),
    );
  }
}
```

**With Custom AppBar:**
```dart
AppLayout(
  appBar: CustomAppBar(
    title: 'My Custom Page',
    extraActions: [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {/* Add action */},
      ),
    ],
  ),
  navigationItems: NavigationConfig.mainNavigationItems,
  body: YourContent(),
)
```

### 2. CustomAppBar - Enhanced AppBar

The `CustomAppBar` comes with built-in common actions.

**Features:**
- Search button
- Notifications with badge
- Profile menu (Profile, Settings, Theme, Logout)
- Custom extra actions

**Usage:**
```dart
CustomAppBar(
  title: 'Dashboard',
  centerTitle: false,
  extraActions: [
    IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {/* Refresh */},
    ),
  ],
)
```

### 3. ResponsiveBuilder - Adaptive Layouts

Build different UIs for different screen sizes.

**Method 1: Custom Builder**
```dart
ResponsiveBuilder.custom(
  mobile: (context) => MobileLayout(),
  tablet: (context) => TabletLayout(),
  desktop: (context) => DesktopLayout(),
)
```

**Method 2: Builder Pattern**
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

**Method 3: Device Type Checks**
```dart
if (ResponsiveBuilder.isMobile(context)) {
  // Mobile specific code
} else if (ResponsiveBuilder.isTablet(context)) {
  // Tablet specific code
} else {
  // Desktop specific code
}
```

### 4. Responsive Values

Use the context extension for responsive values.

**Usage:**
```dart
// Responsive padding
final padding = context.responsive(
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);

// Responsive grid columns
final columns = context.responsive(
  mobile: 1,
  tablet: 2,
  desktop: 3,
);

// In GridView
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: context.responsive(
      mobile: 1,
      tablet: 2,
      desktop: 4,
    ),
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemBuilder: (context, index) => YourWidget(),
)
```

## Adding New Navigation Items

Edit `lib/core/config/navigation_config.dart`:

```dart
class NavigationConfig {
  static final List<NavigationItem> mainNavigationItems = [
    const NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: Routes.dashboard,
    ),
    const NavigationItem(
      label: 'Your New Page',
      icon: Icons.your_icon_outlined,
      selectedIcon: Icons.your_icon,
      route: Routes.yourNewPage,
    ),
  ];
}
```

## Breakpoints

The template uses the following breakpoints:

- **Mobile**: < 600px
- **Tablet**: 600px - 900px  
- **Desktop**: > 900px

## Creating a New Module

Follow these steps to add a new feature module:

1. **Create Module Structure:**
```bash
lib/modules/your_feature/
├── bindings/
│   └── your_feature_bindings.dart
├── controllers/
│   └── your_feature_controller.dart
├── data/
│   ├── dto/
│   ├── models/
│   └── repositories/
├── services/
│   └── your_feature_service.dart
└── views/
    ├── your_feature_view.dart
    └── widgets/
```

2. **Create the View:**
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/your_feature_controller.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/config/navigation_config.dart';

class YourFeatureView extends GetView<YourFeatureController> {
  const YourFeatureView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Your Feature',
      navigationItems: NavigationConfig.mainNavigationItems,
      body: YourContent(),
    );
  }
}
```

3. **Add Route:**
```dart
// lib/core/routes/app_routes.dart
abstract class Routes {
  static const yourFeature = '/your-feature';
}

// lib/core/routes/app_pages.dart
GetPage(
  name: Routes.yourFeature,
  page: () => const YourFeatureView(),
  binding: YourFeatureBindings(),
),
```

4. **Add to Navigation:**
```dart
// lib/core/config/navigation_config.dart
const NavigationItem(
  label: 'Your Feature',
  icon: Icons.your_icon_outlined,
  selectedIcon: Icons.your_icon,
  route: Routes.yourFeature,
),
```

## Examples

Check the **Examples** module (`lib/modules/examples/`) for comprehensive demonstrations of all components:

- Responsive grid layouts
- Adaptive layouts
- Card components
- Device type detection
- And more!

Run the app and navigate to the Examples page to see everything in action.

## Tips

1. **Always use AppLayout** for consistent navigation across your app
2. **Use ResponsiveBuilder** for layouts that need to adapt to screen size
3. **Use context.responsive()** for individual responsive values
4. **Keep navigation config centralized** in `NavigationConfig`
5. **Follow the module structure** for consistency and maintainability

## Need Help?

- Check the `examples` module for working code
- Review the README.md for architecture details
- All components are well-documented with inline comments
