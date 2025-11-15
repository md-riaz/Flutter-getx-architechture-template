# Authentication & Bindings Architecture

This document describes the authentication layer and 3-level bindings management system implemented in this Flutter GetX template.

## Table of Contents
- [Overview](#overview)
- [3-Level Bindings Architecture](#3-level-bindings-architecture)
- [Authentication Flow](#authentication-flow)
- [Session Management](#session-management)
- [Usage Examples](#usage-examples)
- [Testing](#testing)

## Overview

The template implements a comprehensive authentication system with:
- ✅ Splash screen with automatic session validation
- ✅ Login/Logout functionality
- ✅ Repository pattern for auth operations
- ✅ 3-level dependency injection (Global, Session, Route)
- ✅ Automatic cleanup on logout
- ✅ Route protection with middleware

## 3-Level Bindings Architecture

### Level 1: Global Bindings (AppBindings)

**Purpose:** Application-wide services that persist throughout the app lifecycle.

**Registered in:** `lib/core/bindings/app_bindings.dart`

**Lifecycle:** App startup → App shutdown

**Services:**
```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core services (permanent, global-level)
    Get.put(ApiClient(), permanent: true);
    Get.put(SessionManager(), permanent: true);
    
    // Auth infrastructure (permanent, global-level)
    Get.put(AuthRepository(Get.find<ApiClient>()), permanent: true);
    Get.put(AuthService(...), permanent: true);
  }
}
```

**Key Services:**
- `ApiClient` - HTTP client for API calls
- `SessionManager` - Manages session-level bindings lifecycle
- `AuthRepository` - Handles authentication API calls
- `AuthService` - Manages authentication state

### Level 2: Session Bindings (SessionBindings)

**Purpose:** User-specific services initialized after login and disposed on logout.

**Registered in:** `lib/core/bindings/session_bindings.dart`

**Lifecycle:** After login → After logout

**Pattern:**
```dart
class SessionBindings extends Bindings {
  final User user;

  SessionBindings({required this.user});

  @override
  void dependencies() {
    // Initialize feature bindings based on user permissions
    if (user.permissions.inventoryAccess) {
      InventoryBindings().dependencies();
    }

    // Register dashboard controller with session tag
    Get.put(DashboardController(), tag: 'session');
  }
}
```

**Key Points:**
- Takes `User` object with permissions
- Initializes feature modules based on permissions
- All dependencies tagged with `'session'`
- Disposed via `SessionManager.clearSession()` on logout

### Level 3: Route Bindings

**Purpose:** Route-specific controllers and dependencies.

**Lifecycle:** Route enter → Route exit

**Examples:**
```dart
// Splash screen
class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

// Login screen
class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
```

**Key Points:**
- Automatically disposed by GetX when route is popped
- Use `Get.lazyPut` for route-level controllers
- No need for manual cleanup

## Authentication Flow

### 1. App Startup (Splash Screen)

```
App Launch
    ↓
Splash Screen (SplashController)
    ↓
Validate Session
    ↓
    ├─→ Valid Session → Dashboard
    └─→ Invalid Session → Login
```

**Implementation:**
```dart
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final hasValidSession = await _authService.validateSession();

    if (hasValidSession) {
      Get.offAllNamed(Routes.dashboard);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }
}
```

### 2. Login Flow

```
Login Screen
    ↓
Enter Credentials
    ↓
AuthService.login()
    ↓
AuthRepository.login()
    ↓
Success
    ↓
Initialize SessionBindings(user: user)
    ↓
Navigate to Dashboard
```

**Implementation:**
```dart
class LoginController extends GetxController {
  Future<void> login() async {
    final success = await _authService.login(email, password);

    if (success) {
      // Initialize session-level bindings with user permissions
      final user = _authService.currentUser;
      if (user != null) {
        SessionBindings(user: user).dependencies();
      }
      
      Get.offAllNamed(Routes.dashboard);
    }
  }
}
```

### 3. Logout Flow

```
User Clicks Logout
    ↓
AuthService.logout()
    ↓
Clear User State (immediate)
    ↓
Navigate to Login (immediate)
    ↓
Post-Frame Callback
    ↓
SessionManager.clearSession()
    ↓
Delete all 'session' tagged dependencies
```

**Implementation:**
```dart
void logout() {
  print("AuthService: Logout initiated.");

  // Schedule the deletion to happen after the current frame.
  // This ensures navigation has started and prevents accessing deleted controllers.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    print("AuthService: Frame complete. Deleting all session dependencies.");
    _sessionManager.clearSession();
  });

  // Clear user state immediately
  _currentUser.value = null;

  // Navigate away immediately
  Get.offAllNamed(Routes.login);
}
```

**Why Post-Frame Callback?**
- Prevents accessing deleted controllers during navigation
- Navigation starts before cleanup
- Current frame completes safely
- Controllers disposed after view is removed

## Session Management

### SessionManager Service

**Purpose:** Manages lifecycle of session-level bindings.

**Key Methods:**
```dart
class SessionManager extends GetxService {
  static const String sessionTag = 'session';

  void clearSession() {
    // Delete all dependencies registered with session tag
    Get.deleteAll(tag: sessionTag, force: true);
  }

  bool get hasActiveSession {
    try {
      Get.find(tag: sessionTag);
      return true;
    } catch (e) {
      return false;
    }
  }

  String get currentSessionTag => sessionTag;
}
```

### Route Protection

Routes are protected with `AuthMiddleware`:

```dart
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    
    if (!authService.isLoggedIn) {
      return const RouteSettings(name: Routes.login);
    }
    
    return null;
  }
}
```

**Applied to routes:**
```dart
GetPage(
  name: Routes.dashboard,
  page: () => const DashboardView(),
  binding: DashboardBindings(),
  middlewares: [AuthMiddleware()],
),
```

## Usage Examples

### Adding a New Feature Module

1. **Create the feature bindings:**

```dart
class PaymentsBindings extends Bindings {
  static const String sessionTag = 'session';

  @override
  void dependencies() {
    Get.lazyPut<PaymentsRepository>(
      () => PaymentsRepository(Get.find<ApiClient>()),
      tag: sessionTag,
    );
    Get.lazyPut<PaymentsService>(
      () => PaymentsService(Get.find<PaymentsRepository>(tag: sessionTag)),
      tag: sessionTag,
    );
    Get.lazyPut<PaymentsController>(
      () => PaymentsController(Get.find<PaymentsService>(tag: sessionTag)),
      tag: sessionTag,
    );
  }
}
```

2. **Add permission to User model:**

```dart
class UserPermissions {
  final bool inventoryAccess;
  final bool paymentsAccess; // Add new permission

  UserPermissions({
    required this.inventoryAccess,
    required this.paymentsAccess,
  });
}
```

3. **Register in SessionBindings:**

```dart
class SessionBindings extends Bindings {
  @override
  void dependencies() {
    if (user.permissions.inventoryAccess) {
      InventoryBindings().dependencies();
    }
    
    if (user.permissions.paymentsAccess) {
      PaymentsBindings().dependencies(); // Add here
    }

    Get.put(DashboardController(), tag: 'session');
  }
}
```

### Accessing Session-Tagged Controllers

**From a route-level widget:**
```dart
class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the session-tagged controller
    final controller = Get.find<DashboardController>(tag: 'session');
    
    return Scaffold(...);
  }
}
```

**From a feature module:**
```dart
class InventoryView extends GetView<InventoryController> {
  @override
  String? get tag => 'session'; // Specify the tag
  
  @override
  Widget build(BuildContext context) {
    // controller is automatically resolved with 'session' tag
    return Scaffold(...);
  }
}
```

## Testing

### Unit Tests for Auth Services

```dart
test('login succeeds with valid credentials', () async {
  final success = await authService.login('test@example.com', 'password');

  expect(success, isTrue);
  expect(authService.isLoggedIn, isTrue);
  expect(authService.currentUser, isNotNull);
});

test('logout clears user immediately', () async {
  await authService.login('test@example.com', 'password');
  
  authService.logout();

  expect(authService.isLoggedIn, isFalse);
  expect(authService.currentUser, isNull);
});
```

### Integration Tests

Test complete auth flow:

```dart
testWidgets('complete login/logout flow', (WidgetTester tester) async {
  await tester.pumpWidget(ModularGetXApp());
  
  // Should show splash screen
  expect(find.text('Initializing...'), findsOneWidget);
  
  await tester.pumpAndSettle();
  
  // Should navigate to login
  expect(find.text('Welcome Back'), findsOneWidget);
  
  // Enter credentials and login
  await tester.enterText(find.byType(TextField).first, 'test@example.com');
  await tester.enterText(find.byType(TextField).last, 'password');
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
  
  // Should navigate to dashboard
  expect(find.text('Welcome back'), findsOneWidget);
  
  // Logout
  await tester.tap(find.byIcon(Icons.person));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Logout')); // Confirm
  await tester.pumpAndSettle();
  
  // Should navigate back to login
  expect(find.text('Welcome Back'), findsOneWidget);
});
```

## Best Practices

1. **Always use session tag for session-level dependencies**
   ```dart
   Get.lazyPut<MyService>(() => MyService(), tag: 'session');
   ```

2. **Initialize SessionBindings after successful login**
   ```dart
   SessionBindings(user: user).dependencies();
   ```

3. **Use post-frame callback for cleanup during navigation**
   ```dart
   WidgetsBinding.instance.addPostFrameCallback((_) {
     Get.deleteAll(tag: 'session', force: true);
   });
   ```

4. **Protect routes with AuthMiddleware**
   ```dart
   middlewares: [AuthMiddleware()]
   ```

5. **Check permissions before initializing features**
   ```dart
   if (user.permissions.featureAccess) {
     FeatureBindings().dependencies();
   }
   ```

## Troubleshooting

### Issue: "Controller not found" after logout

**Cause:** Trying to access a session-tagged controller after it's been deleted.

**Solution:** Ensure navigation happens before accessing controllers, or use post-frame callback for cleanup.

### Issue: Memory leaks with session dependencies

**Cause:** Session dependencies not being disposed on logout.

**Solution:** Ensure all session dependencies use the `'session'` tag and `SessionManager.clearSession()` is called.

### Issue: Features not available after login

**Cause:** SessionBindings not initialized or user permissions not set correctly.

**Solution:** Verify `SessionBindings(user: user).dependencies()` is called after login and user has correct permissions.

## Conclusion

This architecture provides:
- ✅ Clean separation of concerns (Global → Session → Route)
- ✅ Automatic lifecycle management
- ✅ Permission-based feature loading
- ✅ Safe cleanup during navigation
- ✅ Easy to test and maintain
- ✅ Scalable for large applications

For more examples, see the implementation in:
- `lib/core/bindings/`
- `lib/core/services/`
- `lib/modules/splash/`, `lib/modules/login/`
- `test/core/services/`
