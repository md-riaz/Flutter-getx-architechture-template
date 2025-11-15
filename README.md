# GetX Modular Template

A starter template for building **feature-first, modular Flutter apps** using **GetX**.

## Features

- Feature-based folder structure (`modules/`)
- Core layer for bindings, routes, services (`core/`)
- Repository + DTO + Model pattern
- Reactive UI with GetX (`Obx`, `GetView`)
- Example feature: `inventory`
- Composable dashboard with feature detection
- **Responsive layout builder** (mobile, tablet, desktop)
- **Custom AppBar** with search, notifications, and profile menu
- **Bottom navigation bar** for mobile devices
- **Drawer navigation** for mobile devices
- **Navigation rail** for tablet/desktop devices
- **Comprehensive UI examples** demonstrating all components

## Getting Started

```bash
flutter pub get
flutter run
```

The app will start with a Dashboard that shows an Inventory Summary Card.
Tap "View Inventory" to navigate to the Inventory screen.

## Structure

- **core/** – global bindings, services, routes, theme
- **modules/inventory/** – example feature module
- **modules/dashboard/** – dynamic composable dashboard

You can add new modules by copying the structure of `inventory/` and wiring them into `AppPages` and the `DashboardController`.

## Repository Structure

```
getx_modular_template/
├── lib/
│   ├── core/
│   │   ├── bindings/
│   │   │   └── app_bindings.dart
│   │   ├── routes/
│   │   │   ├── app_pages.dart
│   │   │   └── app_routes.dart
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   └── api_client.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   │
│   ├── modules/
│   │   ├── dashboard/
│   │   │   ├── bindings/
│   │   │   │   └── dashboard_bindings.dart
│   │   │   ├── controllers/
│   │   │   │   └── dashboard_controller.dart
│   │   │   └── views/
│   │   │       └── dashboard_view.dart
│   │   │
│   │   ├── inventory/
│   │   │   ├── bindings/
│   │   │   │   └── inventory_bindings.dart
│   │   │   ├── controllers/
│   │   │   │   └── inventory_controller.dart
│   │   │   ├── data/
│   │   │   │   ├── dto/
│   │   │   │   │   └── inventory_request.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── inventory_item.dart
│   │   │   │   └── repositories/
│   │   │   │       └── inventory_repository.dart
│   │   │   ├── services/
│   │   │   │   └── inventory_service.dart
│   │   │   └── views/
│   │   │       ├── inventory_view.dart
│   │   │       └── widgets/
│   │   │           └── inventory_summary_card.dart
│   │   │
│   │   └── session/
│   │       └── session_manager_bindings.dart
│   │
│   └── main.dart
│
└── pubspec.yaml
```

## Architecture Patterns

### Core Layer
The `core/` directory contains application-wide configurations and services:

- **bindings/** - Global dependency injection setup
- **routes/** - Navigation configuration with GetX
- **services/** - Shared services (API client, authentication)
- **theme/** - Application theme configuration

### Modules
Each module is self-contained with all necessary layers:

- **bindings/** - Dependency injection for the module
- **controllers/** - Business logic and state management
- **data/** - Data layer with DTOs, models, and repositories
- **services/** - Module-specific services
- **views/** - UI screens and widgets

### Dependency Injection
Uses GetX dependency injection with tags for session management:

```dart
Get.lazyPut<InventoryRepository>(
  () => InventoryRepository(Get.find<ApiClient>()),
  tag: sessionTag,
);
```

### Reactive State Management
All UI updates use GetX reactive programming:

```dart
Obx(() {
  if (controller.isLoading.value) {
    return const CircularProgressIndicator();
  }
  // ... rest of the UI
})
```

## Adding New Modules

1. Create a new module directory under `modules/`
2. Implement the standard structure (bindings, controllers, data, services, views)
3. Register routes in `core/routes/app_pages.dart`
4. Add feature detection in `DashboardController`
5. Create a summary card widget for the dashboard

Example structure for a new `payments` module:

```
modules/payments/
├── bindings/
│   └── payments_bindings.dart
├── controllers/
│   └── payments_controller.dart
├── data/
│   ├── dto/
│   ├── models/
│   └── repositories/
├── services/
│   └── payments_service.dart
└── views/
    ├── payments_view.dart
    └── widgets/
        └── payments_summary_card.dart
```

## Platform Support

This template supports:
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Responsive Design

This template includes a comprehensive responsive design system that adapts to different screen sizes:

### Breakpoints
- **Mobile**: < 600px
- **Tablet**: 600px - 900px
- **Desktop**: > 900px

### Responsive Components

#### AppLayout
The `AppLayout` widget provides adaptive navigation:
- **Mobile**: Drawer + Bottom Navigation Bar
- **Tablet**: Navigation Rail (compact)
- **Desktop**: Navigation Rail (extended)

```dart
AppLayout(
  title: 'My Page',
  navigationItems: NavigationConfig.mainNavigationItems,
  body: YourContent(),
)
```

#### ResponsiveBuilder
Build different layouts for different screen sizes:

```dart
ResponsiveBuilder.custom(
  mobile: (context) => MobileLayout(),
  tablet: (context) => TabletLayout(),
  desktop: (context) => DesktopLayout(),
)
```

Or use the builder pattern:

```dart
ResponsiveBuilder(
  builder: (context, deviceType) {
    return Container(
      padding: EdgeInsets.all(
        deviceType == DeviceType.mobile ? 16.0 : 32.0,
      ),
      child: YourWidget(),
    );
  },
)
```

#### Responsive Values
Use the context extension for responsive values:

```dart
final padding = context.responsive(
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);
```

### Custom AppBar
The `CustomAppBar` includes common actions:
- Search button
- Notifications with badge
- Profile menu (Profile, Settings, Theme, Logout)

```dart
CustomAppBar(
  title: 'My Page',
  extraActions: [
    IconButton(
      icon: Icon(Icons.add),
      onPressed: () {},
    ),
  ],
)
```

### Navigation Configuration
Centralized navigation items in `NavigationConfig`:

```dart
class NavigationConfig {
  static final List<NavigationItem> mainNavigationItems = [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: Routes.dashboard,
    ),
    // Add more items...
  ];
}
```

## UI Components Examples

Visit the **Examples** page in the app to see:
- Responsive grid layouts
- Adaptive layouts for different devices
- Card components
- Navigation demonstrations

## Notes

- No external APIs - uses mock data for demonstration
- All dependencies are registered with proper lifecycle management
- Feature modules can be dynamically loaded based on user permissions
- Clean separation of concerns following SOLID principles
- Responsive design works across all platforms (mobile, tablet, desktop, web)
- Navigation automatically adapts based on screen size