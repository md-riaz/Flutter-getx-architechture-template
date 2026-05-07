# Quick Start Guide - Native Interfaces

## 🚀 Getting Started in 5 Minutes

### 1. Understanding the Architecture

```
Your Code (Controllers, Services)
        ↓
    Interfaces (IStorageService, INetworkService, etc.)
        ↓
  Implementations (MemoryStorage, ApiNetwork, etc.)
```

**Key Concept:** Your code depends on interfaces, not implementations. This means you can swap out the implementation at any time without changing your code!

### 2. Using Storage

```dart
import 'package:get/get.dart';

class MyController extends GetxController {
  final storage = Get.find<IStorageService>();
  
  // Save data
  Future<void> saveUsername(String username) async {
    await storage.setString('username', username);
  }
  
  // Load data
  Future<String?> getUsername() async {
    return await storage.getString('username');
  }
}
```

### 3. Using Network

```dart
class MyRepository {
  final network = Get.find<INetworkService>();
  
  Future<List<User>> fetchUsers() async {
    final response = await network.get('/api/users');
    
    if (response.isSuccess) {
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    }
    
    throw Exception('Failed to fetch users');
  }
}
```

### 4. Using Logger

```dart
class MyService extends GetxService {
  final logger = Get.find<ILoggerService>();
  
  Future<void> processData() async {
    logger.info('Starting data processing');
    
    try {
      // Process data
      logger.debug('Data processed successfully');
    } catch (e, stackTrace) {
      logger.error('Processing failed', error: e, stackTrace: stackTrace);
    }
  }
}
```

### 5. Using Device Info

```dart
class PlatformService extends GetxService {
  final deviceInfo = Get.find<IDeviceInfoService>();
  
  Future<bool> shouldShowMobileUI() async {
    return await deviceInfo.isMobile();
  }
  
  Future<String> getPlatformInfo() async {
    final os = await deviceInfo.getOperatingSystem();
    final version = await deviceInfo.getOSVersion();
    return '$os $version';
  }
}
```

### 6. Using Connectivity

```dart
class SyncService extends GetxService {
  final connectivity = Get.find<IConnectivityService>();
  
  Future<void> syncIfConnected() async {
    if (await connectivity.hasConnection()) {
      // Perform sync
      print('Syncing data...');
    } else {
      print('No connection, skipping sync');
    }
  }
  
  void listenToConnectivityChanges() {
    connectivity.onConnectivityChanged.listen((type) {
      print('Connection changed to: $type');
    });
  }
}
```

## 🔄 Swapping Implementations

### Current Setup (Default)
```dart
// In app_bindings.dart
Get.put<IStorageService>(MemoryStorageService(), permanent: true);
```

### Upgrade to SharedPreferences
```dart
// 1. Add to pubspec.yaml
dependencies:
  shared_preferences: ^2.2.0

// 2. Create implementation
class SharedPrefsStorageService implements IStorageService {
  SharedPreferences? _prefs;
  
  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  @override
  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }
  
  @override
  Future<String?> getString(String key) async {
    return _prefs!.getString(key);
  }
  
  // ... implement other methods
}

// 3. Update binding
Get.put<IStorageService>(SharedPrefsStorageService(), permanent: true);
```

**That's it!** All your existing code continues to work without any changes! 🎉

## 🧪 Testing Made Easy

```dart
// Create a mock
class MockStorageService extends Mock implements IStorageService {}

// Use in tests
test('should save username', () async {
  final mockStorage = MockStorageService();
  final controller = MyController(storage: mockStorage);
  
  when(mockStorage.setString('username', 'John'))
      .thenAnswer((_) async => true);
  
  await controller.saveUsername('John');
  
  verify(mockStorage.setString('username', 'John')).called(1);
});
```

## 📚 Common Patterns

### Pattern 1: Dependency Injection
```dart
class MyService extends GetxService {
  final IStorageService storage;
  final ILoggerService logger;
  
  MyService({
    required this.storage,
    required this.logger,
  });
}

// In bindings
Get.lazyPut(() => MyService(
  storage: Get.find<IStorageService>(),
  logger: Get.find<ILoggerService>(),
));
```

### Pattern 2: Direct Access
```dart
class MyController extends GetxController {
  final storage = Get.find<IStorageService>();
  final logger = Get.find<ILoggerService>();
  
  // Use them directly
}
```

### Pattern 3: Conditional Features
```dart
class FeatureService extends GetxService {
  final deviceInfo = Get.find<IDeviceInfoService>();
  final connectivity = Get.find<IConnectivityService>();
  
  Future<bool> canUseFeature(String feature) async {
    if (feature == 'hd_video') {
      // Only on WiFi for mobile devices
      final isMobile = await deviceInfo.isMobile();
      final isWiFi = await connectivity.isWiFi();
      return !isMobile || isWiFi;
    }
    return true;
  }
}
```

## 🎯 Best Practices

### ✅ DO
- Use interfaces everywhere in your code
- Initialize storage before using it
- Log important operations
- Check connectivity before network operations
- Use dependency injection in services

### ❌ DON'T
- Don't use concrete implementations directly
- Don't forget to call `init()` on storage
- Don't hardcode implementation names
- Don't mix interface types

## 🔍 Troubleshooting

### Issue: Storage not initialized
```dart
// ❌ Bad
final storage = Get.find<IStorageService>();
await storage.setString('key', 'value'); // May throw StateError

// ✅ Good
final storage = Get.find<IStorageService>();
await storage.init(); // Initialize first
await storage.setString('key', 'value'); // Now it works
```

### Issue: Interface not registered
```dart
// Error: Instance not found
final storage = Get.find<IStorageService>();

// Solution: Make sure it's registered in AppBindings
Get.put<IStorageService>(MemoryStorageService(), permanent: true);
```

## 📖 Next Steps

1. Read [INTERFACES_USAGE.md](INTERFACES_USAGE.md) for detailed documentation
2. Check [example_service.dart](example_service.dart) for complete examples
3. See [NATIVE_INTERFACES.md](../../NATIVE_INTERFACES.md) for architecture details

## 💡 Tips

- Start with the default implementations
- Upgrade to production implementations when needed
- Create custom implementations for specific needs
- Mock interfaces for testing
- Use logging everywhere for better debugging

Happy coding! 🚀
