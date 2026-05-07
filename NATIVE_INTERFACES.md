# Native Interfaces Architecture

## Overview

This document describes the native interfaces architecture added to the GetX Modular Template. These interfaces provide abstraction layers for common native functionalities, enabling easy swapping of implementations without changing business logic.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                  Business Logic Layer                    │
│         (Controllers, Services, Repositories)            │
│                                                           │
│  Uses interfaces, not concrete implementations           │
└───────────────────────┬─────────────────────────────────┘
                        │
                        │ Depends on
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Interface Layer (Abstractions)              │
│                                                           │
│  IStorageService  │ INetworkService │ ILoggerService     │
│  IDeviceInfoService │ IConnectivityService               │
└───────────────────────┬─────────────────────────────────┘
                        │
                        │ Implemented by
                        ▼
┌─────────────────────────────────────────────────────────┐
│           Implementation Layer (Concrete)                │
│                                                           │
│  MemoryStorageService │ ApiNetworkService                │
│  ConsoleLoggerService │ PlatformDeviceInfoService        │
│  SimpleConnectivityService                               │
│                                                           │
│  ↕ Can be swapped with other implementations             │
│                                                           │
│  SharedPreferencesStorage │ DioNetworkService            │
│  FirebaseLogger │ DeviceInfoPlusService                  │
│  ConnectivityPlusService                                 │
└─────────────────────────────────────────────────────────┘
```

## Design Principles

### 1. Dependency Inversion Principle (DIP)
High-level modules (business logic) depend on abstractions (interfaces), not on concrete implementations.

```dart
// ✅ Good: Depends on interface
class UserService {
  final IStorageService storage;
  UserService(this.storage);
}

// ❌ Bad: Depends on concrete class
class UserService {
  final MemoryStorageService storage;
  UserService(this.storage);
}
```

### 2. Open/Closed Principle (OCP)
The system is open for extension (new implementations) but closed for modification (business logic doesn't change).

```dart
// Add new implementation without changing existing code
class HiveStorageService implements IStorageService {
  // Implementation details
}

// Update binding only - no changes to business logic
Get.put<IStorageService>(HiveStorageService());
```

### 3. Interface Segregation Principle (ISP)
Each interface is focused on a specific responsibility and doesn't force implementations to depend on methods they don't use.

## Interface Details

### 1. IStorageService
**Purpose:** Local data persistence

**Default Implementation:** `MemoryStorageService` (in-memory, non-persistent)

**Alternative Implementations:**
- `SharedPreferencesStorageService` - For simple key-value storage
- `HiveStorageService` - For structured data storage
- `SecureStorageService` - For sensitive data (tokens, passwords)

**Common Use Cases:**
- User preferences and settings
- Authentication tokens
- Cache data
- Feature flags

### 2. INetworkService
**Purpose:** HTTP/Network operations

**Default Implementation:** `ApiNetworkService` (wraps existing ApiClient)

**Alternative Implementations:**
- `DioNetworkService` - Advanced HTTP client with interceptors
- `HttpNetworkService` - Using dart:http package
- `ChopperNetworkService` - Type-safe REST client

**Common Use Cases:**
- API calls
- File uploads/downloads
- Real-time communication setup
- GraphQL queries

### 3. IDeviceInfoService
**Purpose:** Device and platform information

**Default Implementation:** `PlatformDeviceInfoService` (uses Flutter's Platform)

**Alternative Implementations:**
- `DeviceInfoPlusService` - Detailed device information
- `PackageInfoService` - App version and build info
- `PlatformDeviceIdService` - Unique device identifiers

**Common Use Cases:**
- Analytics and tracking
- Platform-specific features
- Device capability detection
- App version checks

### 4. IConnectivityService
**Purpose:** Network connectivity status

**Default Implementation:** `SimpleConnectivityService` (mock, always connected)

**Alternative Implementations:**
- `ConnectivityPlusService` - Real connectivity monitoring
- `NetworkInfoService` - Detailed network information

**Common Use Cases:**
- Offline mode detection
- Sync operations
- Download optimization (WiFi vs cellular)
- Error handling for network issues

### 5. ILoggerService
**Purpose:** Application logging

**Default Implementation:** `ConsoleLoggerService` (prints to console)

**Alternative Implementations:**
- `LoggerPackageService` - Pretty console logs
- `FirebaseCrashlyticsService` - Remote error tracking
- `SentryLoggerService` - Error monitoring
- `FileLoggerService` - Local file logging

**Common Use Cases:**
- Debugging during development
- Error tracking in production
- Performance monitoring
- User behavior analytics

## Integration with Existing Architecture

### Bindings Integration

The interfaces are registered in `AppBindings` (Global-level bindings):

```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Native interface implementations
    Get.put<IStorageService>(MemoryStorageService(), permanent: true);
    Get.put<ILoggerService>(ConsoleLoggerService(), permanent: true);
    Get.put<IDeviceInfoService>(PlatformDeviceInfoService(), permanent: true);
    Get.put<IConnectivityService>(SimpleConnectivityService(), permanent: true);
    
    // Initialize services that need it
    Get.find<IStorageService>().init();
    
    // Other bindings...
  }
}
```

### Usage in Services

Services should depend on interfaces:

```dart
class AuthService extends GetxService {
  final IStorageService _storage;
  final ILoggerService _logger;
  
  AuthService({
    required IStorageService storage,
    required ILoggerService logger,
  }) : _storage = storage,
       _logger = logger;
       
  Future<void> saveToken(String token) async {
    _logger.info('Saving auth token');
    await _storage.setString('auth_token', token);
  }
}
```

### Usage in Repositories

Repositories can use interfaces for network and logging:

```dart
class UserRepository {
  final INetworkService _network;
  final ILoggerService _logger;
  
  UserRepository({
    required INetworkService network,
    required ILoggerService logger,
  }) : _network = network,
       _logger = logger;
       
  Future<User> fetchUser(String id) async {
    _logger.debug('Fetching user: $id');
    final response = await _network.get('/users/$id');
    return User.fromJson(response.data);
  }
}
```

### Usage in Controllers

Controllers can access interfaces through GetX:

```dart
class SettingsController extends GetxController {
  final storage = Get.find<IStorageService>();
  final logger = Get.find<ILoggerService>();
  
  Future<void> saveSettings(Settings settings) async {
    logger.info('Saving settings');
    await storage.setString('theme', settings.theme);
    await storage.setBool('notifications', settings.notifications);
  }
}
```

## Testing with Interfaces

### Unit Testing

Interfaces make unit testing straightforward:

```dart
class MockStorageService extends Mock implements IStorageService {}

void main() {
  test('should save user token', () async {
    // Arrange
    final mockStorage = MockStorageService();
    final service = AuthService(storage: mockStorage, logger: MockLoggerService());
    
    when(mockStorage.setString('token', 'abc123'))
        .thenAnswer((_) async => true);
    
    // Act
    await service.saveToken('abc123');
    
    // Assert
    verify(mockStorage.setString('token', 'abc123')).called(1);
  });
}
```

### Integration Testing

For integration tests, you can use real implementations:

```dart
void main() {
  testWidgets('integration test', (tester) async {
    // Use real in-memory storage for integration tests
    Get.put<IStorageService>(MemoryStorageService());
    
    // Run your tests
  });
}
```

## Migration Guide

### Migrating Existing Code

If you have existing code that directly uses concrete implementations:

**Before:**
```dart
class MyService {
  final ApiClient _apiClient;
  
  MyService(this._apiClient);
  
  Future<void> fetchData() async {
    final data = await _apiClient.getInventoryItems({});
    // Process data
  }
}
```

**After:**
```dart
class MyService {
  final INetworkService _network;
  
  MyService(this._network);
  
  Future<void> fetchData() async {
    final response = await _network.get('/inventory');
    // Process response.data
  }
}
```

## Best Practices

### DO:
✅ Use interfaces in all business logic  
✅ Register interfaces in bindings with `Get.put<Interface>(Implementation())`  
✅ Keep interfaces focused and cohesive  
✅ Document why you chose a specific implementation  
✅ Initialize services that require setup (e.g., storage)

### DON'T:
❌ Reference concrete implementations in business logic  
❌ Add unnecessary methods to interfaces  
❌ Mix concerns in a single interface  
❌ Forget to initialize services that need it  
❌ Use concrete types when injecting dependencies

## Performance Considerations

### Initialization
Some implementations require initialization:
```dart
final storage = Get.find<IStorageService>();
await storage.init(); // Always call init before use
```

### Caching
Consider caching frequently accessed data:
```dart
String? _cachedToken;

Future<String?> getToken() async {
  _cachedToken ??= await storage.getString('token');
  return _cachedToken;
}
```

### Async Operations
All interface methods are async to support various implementations:
```dart
// Even if current implementation is synchronous,
// interface is async for future flexibility
Future<bool> setBool(String key, bool value);
```

## Future Enhancements

Potential additions to the interface system:

1. **ICacheService** - Caching with TTL and eviction policies
2. **IAnalyticsService** - Analytics and tracking
3. **INotificationService** - Push notifications and local notifications
4. **IAuthService** - Authentication providers (Firebase, OAuth, etc.)
5. **IBiometricService** - Biometric authentication
6. **IDeepLinkService** - Deep linking and dynamic links
7. **IPaymentService** - Payment processing
8. **IShareService** - Content sharing

## Conclusion

The native interfaces architecture provides:

- **Flexibility:** Easily swap implementations
- **Testability:** Simple mocking for unit tests
- **Maintainability:** Clear contracts and separation of concerns
- **Scalability:** Add new features without breaking existing code
- **Best Practices:** Follows SOLID principles

This architecture ensures your codebase remains clean, testable, and adaptable to changing requirements.
