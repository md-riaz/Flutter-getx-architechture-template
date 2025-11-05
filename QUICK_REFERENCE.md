# Quick Reference Guide

## Flutter GetX Architecture - Quick Start

### Running the Application

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Verify structure
./verify_structure.sh
```

### Key Concepts

#### 1. Controllers (fenix: true)
All controllers extend `BaseController` and are registered with `fenix: true`:
```dart
Get.lazyPut<Controller>(
  () => Controller(),
  fenix: true,  // Auto-recovery after disposal
);
```

#### 2. Lifecycle Methods
Every controller prints debug messages:
```
[ControllerName] onInit called
[ControllerName] onReady called
[ControllerName] onClose called
```

#### 3. Random State Timer
Controllers update random state periodically:
```dart
Timer.periodic(Duration(seconds: 3), (timer) {
  randomState.value = Random().nextInt(100);
});
```

#### 4. Feature Registry Pattern
```dart
// On App Start
featureRegistry.registerFeature('home', HomeBinding());

// On Login
featureRegistry.createFeatureBindings();

// On Logout
featureRegistry.deleteFeatureBindings();
```

### Project Structure Map

```
lib/
├── main.dart                  # App entry point
├── base/                      # Base classes
│   └── base_controller.dart
├── binding/                   # Dependency injection
│   ├── initial_bindings.dart  # Permanent services
│   ├── auth_binding.dart      # Auth feature
│   └── home_binding.dart      # Home feature
├── features/                  # Feature modules
│   ├── auth/
│   │   ├── controllers/       # AuthController
│   │   ├── models/            # User
│   │   ├── repositories/      # AuthRepository
│   │   └── screens/           # LoginScreen
│   └── home/
│       ├── controllers/       # HomeController
│       └── screens/           # HomeScreen
├── services/                  # Global services
│   ├── auth_service.dart
│   └── feature_registry_service.dart
├── theme/                     # App theme
│   └── app_theme.dart
└── util/                      # Utilities
    └── app_routes.dart
```

### Authentication Flow

1. **User enters credentials** → Any email/password
2. **Click Login** → AuthService.login()
3. **Validation** → Always returns true
4. **Login** → Creates User in memory
5. **Feature Bindings** → HomeBinding created
6. **Navigate** → Home screen

### Logout Flow

1. **Click Logout** → AuthService.logout()
2. **Feature Bindings** → HomeBinding deleted
3. **Clear User** → Removed from memory
4. **Navigate** → Login screen

### Key Classes

#### BaseController
```dart
abstract class BaseController extends GetxController {
  @override void onInit() { /* debug print */ }
  @override void onReady() { /* debug print */ }
  @override void onClose() { /* debug print */ }
}
```

#### AuthRepository
```dart
class AuthRepository {
  User? _currentUser;  // In-memory storage
  
  Future<bool> validate(email, password) => true;
  Future<User> login(email, password);
  Future<void> logout();
}
```

#### FeatureRegistryService
```dart
class FeatureRegistryService extends GetxService {
  Map<String, Bindings> _registeredFeatures;
  
  void registerFeature(name, binding);
  void createFeatureBindings();    // On login
  void deleteFeatureBindings();    // On logout
}
```

### Testing

#### Run All Tests
```bash
flutter test
```

#### Test Coverage
- AuthRepository validation
- AuthRepository user storage
- AuthRepository logout
- FeatureRegistryService registration
- FeatureRegistryService clearing

### Debug Output Example

```
[InitialBindings] Setting up permanent services
[FeatureRegistryService] Registering feature: home
[AppRoutes] Feature registry initialized
[AuthBinding] Setting up auth dependencies
[AuthController] onInit called
[AuthController] onReady called
[AuthController] Random state updated: 42
[AuthService] Attempting login for: user@example.com
[AuthRepository] Validating credentials for: user@example.com
[AuthRepository] Logging in user: user@example.com
[FeatureRegistryService] Creating feature bindings
[HomeBinding] Setting up home dependencies
[AuthService] Login successful for: user@example.com
[HomeController] onInit called
[HomeController] onReady called
[HomeController] Random state updated: 73
```

### Common Tasks

#### Add New Feature
1. Create feature directory: `lib/features/my_feature/`
2. Add controllers, models, repositories, screens
3. Create binding: `lib/binding/my_feature_binding.dart`
4. Register in FeatureRegistry: `AppRoutes.initializeFeatureRegistry()`
5. Add route: `AppRoutes.routes`

#### Add New Service
1. Create service: `lib/services/my_service.dart`
2. Extend `GetxService`
3. Register as permanent in `InitialBindings`

#### Add Debug Logging
All controllers automatically log lifecycle events via `BaseController`.
Add custom logs:
```dart
print('[MyController] Custom message');
```

### Configuration

#### pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
```

#### analysis_options.yaml
```yaml
include: package:flutter_lints/flutter.yaml
```

### Tips

1. **Controllers**: Always extend `BaseController`
2. **Bindings**: Use `fenix: true` for feature controllers
3. **Services**: Use `permanent: true` for app-wide services
4. **Debug**: Check console for lifecycle prints
5. **State**: All state is local and in-memory
6. **No APIs**: Everything runs locally

### Support

For more details, see:
- `README.md` - Overview and getting started
- `IMPLEMENTATION.md` - Detailed implementation guide
- `ARCHITECTURE.md` - Architecture diagrams and flows
