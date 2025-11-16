# GetX Modular Template

A starter template for building **feature-first, modular Flutter apps** using **GetX**.

## Features

- **Authentication & Authorization**
  - Splash screen with automatic session validation
  - Login/Logout functionality with session management
  - Repository pattern for auth operations
  - Route protection with middleware
  - 3-level bindings architecture (Global → Session → Route)
- **Architecture**
  - Feature-based folder structure (`modules/`)
  - Core layer for bindings, routes, services (`core/`)
  - Repository + DTO + Model pattern
  - Reactive UI with GetX (`Obx`, `GetView`)
  - **Native interfaces** for swappable implementations (storage, network, device info, connectivity, logging, files)
  - **Laravel-style facades** with service locator (get_it) for clean, static access
- **UI & Navigation**
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

### First Launch

The app starts with a **Splash Screen** that validates any existing session:
- If no session exists → **Login Screen**
- If valid session exists → **Dashboard**

### Demo Login

On the Login screen, enter any email and password to login:
- **Email:** Any valid email format
- **Password:** Any password

After login, you'll see:
- **Dashboard** with personalized greeting
- **Inventory** feature (based on user permissions)
- **Examples** page with UI components

### Navigation

- **Mobile:** Bottom navigation bar + Drawer
- **Tablet/Desktop:** Navigation rail
- **AppBar:** Search, notifications, and profile menu with logout

### Logout

Click the profile icon → Select "Logout" → Confirm

The app will:
1. Clear the current user session
2. Dispose all session-level dependencies
3. Navigate back to the Login screen

**📖 Documentation:**
- [AUTH_ARCHITECTURE.md](AUTH_ARCHITECTURE.md) - Authentication & 3-level bindings architecture
- [FEATURES.md](FEATURES.md) - Complete features overview and quick reference
- [USAGE_GUIDE.md](USAGE_GUIDE.md) - Detailed usage guide with code examples
- [RESPONSIVE_DESIGN.md](RESPONSIVE_DESIGN.md) - Responsive design patterns and best practices
- [THEME_CONFIGURATION.md](THEME_CONFIGURATION.md) - Theme customization and branding guide
- [NATIVE_INTERFACES.md](NATIVE_INTERFACES.md) - Native interfaces architecture and design
- [INTERFACES_USAGE.md](lib/core/interfaces/INTERFACES_USAGE.md) - Native interfaces usage guide and examples
- [LARAVEL_STYLE_SERVICES.md](LARAVEL_STYLE_SERVICES.md) - **NEW!** Laravel-style facades and service locator

## Structure

- **core/** – global bindings, services, routes, theme, middleware, auth infrastructure
- **modules/splash/** – splash screen with session validation
- **modules/login/** – login screen with authentication
- **modules/dashboard/** – dynamic composable dashboard
- **modules/inventory/** – example feature module with repository pattern

You can add new modules by copying the structure of `inventory/` and wiring them into `AppPages`, `SessionBindings` and the `DashboardController`.

## Repository Structure

```
getx_modular_template/
├── lib/
│   ├── core/
│   │   ├── bindings/
│   │   │   ├── app_bindings.dart               # Global-level bindings
│   │   │   └── session_bindings.dart           # Session-level bindings
│   │   ├── config/
│   │   │   └── navigation_config.dart          # Centralized navigation
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart             # User & permissions models
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart        # Auth API operations
│   │   ├── middleware/
│   │   │   └── auth_middleware.dart            # Route protection
│   │   ├── routes/
│   │   │   ├── app_pages.dart
│   │   │   └── app_routes.dart
│   │   ├── interfaces/
│   │   │   ├── storage_interface.dart           # Storage abstraction
│   │   │   ├── network_interface.dart           # Network abstraction
│   │   │   ├── device_info_interface.dart       # Device info abstraction
│   │   │   ├── connectivity_interface.dart      # Connectivity abstraction
│   │   │   ├── logger_interface.dart            # Logger abstraction
│   │   │   └── interfaces.dart                  # Barrel export
│   │   ├── implementations/
│   │   │   ├── memory_storage_service.dart      # In-memory storage impl
│   │   │   ├── api_network_service.dart         # Network impl
│   │   │   ├── platform_device_info_service.dart # Device info impl
│   │   │   ├── simple_connectivity_service.dart # Connectivity impl
│   │   │   ├── console_logger_service.dart      # Logger impl
│   │   │   └── implementations.dart             # Barrel export
│   │   ├── services/
│   │   │   ├── api_client.dart
│   │   │   ├── auth_service.dart               # Auth state management
│   │   │   └── session_manager.dart            # Session lifecycle
│   │   ├── theme/
│   │   │   ├── app_colors.dart                 # Centralized color definitions
│   │   │   ├── app_theme.dart                  # Light & Dark themes
│   │   │   ├── app_theme_config.dart           # Theme configuration
│   │   │   └── theme.dart                      # Barrel export
│   │   └── widgets/
│   │       ├── app_layout.dart                 # Responsive layout wrapper
│   │       ├── custom_app_bar.dart             # Enhanced AppBar with logout
│   │       ├── responsive_builder.dart         # Responsive builder
│   │       └── widgets.dart                    # Barrel export
│   │
│   ├── modules/
│   │   ├── splash/                             # Splash screen
│   │   │   ├── bindings/
│   │   │   │   └── splash_bindings.dart
│   │   │   ├── controllers/
│   │   │   │   └── splash_controller.dart
│   │   │   └── views/
│   │   │       └── splash_view.dart
│   │   │
│   │   ├── login/                              # Login screen
│   │   │   ├── bindings/
│   │   │   │   └── login_bindings.dart
│   │   │   ├── controllers/
│   │   │   │   └── login_controller.dart
│   │   │   └── views/
│   │   │       └── login_view.dart
│   │   │
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
│   │   └── examples/                           # UI components examples
│   │       ├── bindings/
│   │       │   └── examples_bindings.dart
│   │       ├── controllers/
│   │       │   └── examples_controller.dart
│   │       └── views/
│   │           └── examples_view.dart
│   │
│   └── main.dart
│
├── test/
│   ├── core/
│   │   ├── data/repositories/
│   │   │   └── auth_repository_test.dart
│   │   └── services/
│   │       ├── auth_service_test.dart
│   │       └── session_manager_test.dart
│   └── app_test.dart
│
├── AUTH_ARCHITECTURE.md                        # Auth & bindings architecture
├── USAGE_GUIDE.md                              # Comprehensive usage guide
└── pubspec.yaml
```

## Architecture Patterns

### 3-Level Bindings Architecture

This template implements a sophisticated 3-level dependency injection system:

#### Level 1: Global Bindings
**Lifecycle:** App startup → App shutdown

```dart
class AppBindings extends Bindings {
  void dependencies() {
    Get.put(ApiClient(), permanent: true);
    Get.put(SessionManager(), permanent: true);
    Get.put(AuthRepository(...), permanent: true);
    Get.put(AuthService(...), permanent: true);
  }
}
```

#### Level 2: Session Bindings
**Lifecycle:** After login → After logout

```dart
class SessionBindings extends Bindings {
  final User user;
  
  SessionBindings({required this.user});
  
  void dependencies() {
    if (user.permissions.inventoryAccess) {
      InventoryBindings().dependencies();
    }
    Get.put(DashboardController(), tag: 'session');
  }
}
```

#### Level 3: Route Bindings
**Lifecycle:** Route enter → Route exit

```dart
class LoginBindings extends Bindings {
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
```

### Core Layer
The `core/` directory contains application-wide configurations and services:

- **bindings/** - Global and session-level dependency injection
- **data/** - Core data models and repositories (User, AuthRepository)
- **interfaces/** - Abstract interfaces for native functionality (swappable implementations)
- **implementations/** - Concrete implementations of interfaces (easily replaceable)
- **middleware/** - Route guards and middleware (AuthMiddleware)
- **routes/** - Navigation configuration with GetX
- **services/** - Shared services (API client, authentication, session management)
- **theme/** - Application theme configuration with customizable colors, typography, and styling (see [THEME_CONFIGURATION.md](THEME_CONFIGURATION.md))

### Modules
Each module is self-contained with all necessary layers:

- **bindings/** - Dependency injection for the module
- **controllers/** - Business logic and state management
- **data/** - Data layer with DTOs, models, and repositories
- **services/** - Module-specific services
- **views/** - UI screens and widgets

### Session Management
Session-level dependencies are tagged and cleaned up on logout:

```dart
// Register with session tag
Get.lazyPut<InventoryRepository>(
  () => InventoryRepository(Get.find<ApiClient>()),
  tag: 'session',
);

// Cleanup on logout (post-frame callback)
WidgetsBinding.instance.addPostFrameCallback((_) {
  Get.deleteAll(tag: 'session', force: true);
});
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

### Authentication Flow
```
Splash → Validate Session → Login (if needed) → Initialize Session → Dashboard
```

For complete details, see [AUTH_ARCHITECTURE.md](AUTH_ARCHITECTURE.md).

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

## Native Interfaces

This template includes abstraction layers for common native functionalities, making it easy to swap implementations without changing business logic:

### Available Interfaces

- **IStorageService** - Local storage (SharedPreferences, Hive, Secure Storage)
- **INetworkService** - HTTP operations (Dio, http package, Chopper)
- **IDeviceInfoService** - Device information (device_info_plus, platform)
- **IConnectivityService** - Network connectivity (connectivity_plus)
- **ILoggerService** - Logging (logger package, firebase_crashlytics)

### Benefits

- ✅ **Easy Testing** - Mock interfaces for unit tests
- ✅ **Swappable Implementations** - Change storage/network providers without refactoring
- ✅ **Clean Architecture** - Business logic decoupled from implementation details
- ✅ **Future-Proof** - Add new providers without breaking existing code

### Quick Example

```dart
// Use storage in your service
final storage = Get.find<IStorageService>();
await storage.setString('user_token', token);
final token = await storage.getString('user_token');

// Use network in your repository  
final network = Get.find<INetworkService>();
final response = await network.post('/api/users', body: userData);

// Use logger anywhere
final logger = Get.find<ILoggerService>();
logger.info('Operation completed', data: {'userId': 123});
```

### Swapping Implementations

To change from in-memory storage to SharedPreferences:

1. Add package: `shared_preferences: ^2.2.0`
2. Create implementation: `SharedPreferencesStorageService`
3. Update binding: `Get.put<IStorageService>(SharedPreferencesStorageService())`
4. All existing code works without changes! 🎉

See [INTERFACES_USAGE.md](lib/core/interfaces/INTERFACES_USAGE.md) for detailed documentation and examples.

## Laravel-Style Service Layer 🚀 NEW!

For developers who love Laravel's elegant API, this template now includes **Facades** and a **Service Locator** pattern!

### Clean, Static Access (Like Laravel)

```dart
import 'package:your_app/core/facades/facades.dart';

// Storage - No dependency injection needed!
await Storage.set('user_token', token);
final token = await Storage.get('user_token');

// Logging - Simple and clean
Log.info('User logged in', data: {'userId': user.id});
Log.error('Login failed', error: exception);

// File Picking - Just like Laravel's Storage
final filePath = await Files.pick();
final images = await Files.pickImages();
await Files.save(fileName: 'report.pdf', bytes: pdfBytes);
```

### Setup (One-time)

```dart
// In main.dart
import 'core/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator(); // Initialize once
  runApp(MyApp());
}
```

### Benefits

- 🎯 **Laravel-like DX** - Clean, readable, no boilerplate
- 🔌 **Service Locator** - Automatic dependency injection with get_it
- 🎭 **Facades** - Static access to services (Storage, Log, Files)
- 🧪 **Still Testable** - Mock the service locator in tests
- 🔄 **Swap Anytime** - Change implementations without code changes

### Available Facades

- `Storage` - Storage.set(), Storage.get(), Storage.clear()
- `Log` - Log.info(), Log.error(), Log.debug()
- `Files` - Files.pick(), Files.save(), Files.delete()

See [LARAVEL_STYLE_SERVICES.md](LARAVEL_STYLE_SERVICES.md) for complete guide with real-world examples!

## Notes

- No external APIs - uses mock data for demonstration
- All dependencies are registered with proper lifecycle management
- Feature modules can be dynamically loaded based on user permissions
- Clean separation of concerns following SOLID principles
- Responsive design works across all platforms (mobile, tablet, desktop, web)
- Navigation automatically adapts based on screen size