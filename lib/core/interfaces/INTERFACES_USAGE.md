# Native Interfaces Usage Guide

This document explains the wrapper interfaces for native implementations and how to use them effectively.

## Overview

The interfaces in this directory provide abstraction layers for common native functionalities. This allows you to swap implementations without changing the concrete usage in your codebase.

### Available Interfaces

1. **IStorageService** - Local storage operations
2. **INetworkService** - HTTP/Network operations
3. **IDeviceInfoService** - Device and platform information
4. **IConnectivityService** - Network connectivity checking
5. **ILoggerService** - Logging operations

## Benefits

- **Testability**: Easy to mock interfaces for testing
- **Flexibility**: Swap implementations without changing business logic
- **Maintainability**: Clear contracts for service behavior
- **Decoupling**: Business logic doesn't depend on specific packages

## Usage Examples

### 1. Storage Service

```dart
// Get the storage service (registered in AppBindings)
final storage = Get.find<IStorageService>();

// Save data
await storage.setString('user_token', 'abc123');
await storage.setInt('login_count', 5);
await storage.setBool('remember_me', true);

// Retrieve data
final token = await storage.getString('user_token');
final count = await storage.getInt('login_count');
final remember = await storage.getBool('remember_me');

// Check existence
if (await storage.containsKey('user_token')) {
  print('Token exists');
}

// Remove data
await storage.remove('user_token');

// Clear all
await storage.clear();
```

### 2. Network Service

```dart
// Get the network service
final network = Get.find<INetworkService>();

// Configure base URL and headers
network.setBaseUrl('https://api.example.com');
network.setDefaultHeaders({'Authorization': 'Bearer token'});

// Make requests
final getResponse = await network.get('/users');
if (getResponse.isSuccess) {
  print('Data: ${getResponse.data}');
}

final postResponse = await network.post(
  '/users',
  body: {'name': 'John', 'email': 'john@example.com'},
);

final putResponse = await network.put(
  '/users/123',
  body: {'name': 'John Updated'},
);

await network.delete('/users/123');
```

### 3. Device Info Service

```dart
// Get the device info service
final deviceInfo = Get.find<IDeviceInfoService>();

// Get platform information
final os = await deviceInfo.getOperatingSystem();
final version = await deviceInfo.getOSVersion();
final model = await deviceInfo.getDeviceModel();

// Check platform
if (await deviceInfo.isAndroid()) {
  print('Running on Android');
} else if (await deviceInfo.isIOS()) {
  print('Running on iOS');
} else if (await deviceInfo.isWeb()) {
  print('Running on Web');
}

// Get screen info
final screenInfo = await deviceInfo.getScreenInfo();
print('Screen: ${screenInfo.width} x ${screenInfo.height}');
print('Pixel Ratio: ${screenInfo.pixelRatio}');
```

### 4. Connectivity Service

```dart
// Get the connectivity service
final connectivity = Get.find<IConnectivityService>();

// Check connection
if (await connectivity.hasConnection()) {
  print('Device is connected to internet');
}

// Get connection type
final type = await connectivity.getConnectionType();
switch (type) {
  case ConnectionType.wifi:
    print('Connected via WiFi');
    break;
  case ConnectionType.mobile:
    print('Connected via Mobile Data');
    break;
  case ConnectionType.none:
    print('No connection');
    break;
  default:
    print('Unknown connection');
}

// Listen to connectivity changes
connectivity.onConnectivityChanged.listen((type) {
  print('Connectivity changed to: $type');
});
```

### 5. Logger Service

```dart
// Get the logger service
final logger = Get.find<ILoggerService>();

// Set log level (only logs at or above this level will be shown)
logger.setLogLevel(LogLevel.info);

// Log messages
logger.debug('Debug message', data: {'key': 'value'});
logger.info('Info message');
logger.warning('Warning message');
logger.error('Error occurred', error: exception, stackTrace: stackTrace);
logger.fatal('Critical error', error: exception, stackTrace: stackTrace);

// Disable logging
logger.setEnabled(false);
```

## Swapping Implementations

### Example: Using SharedPreferences instead of Memory Storage

1. Add the package to `pubspec.yaml`:
```yaml
dependencies:
  shared_preferences: ^2.2.0
```

2. Create a new implementation:
```dart
// lib/core/implementations/shared_preferences_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/storage_interface.dart';

class SharedPreferencesStorageService implements IStorageService {
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
```

3. Update the binding:
```dart
// In app_bindings.dart, change:
Get.put<IStorageService>(MemoryStorageService(), permanent: true);

// To:
Get.put<IStorageService>(SharedPreferencesStorageService(), permanent: true);
```

4. All existing code using `IStorageService` will now use SharedPreferences!

### Example: Using Dio instead of custom network client

1. Add the package:
```yaml
dependencies:
  dio: ^5.4.0
```

2. Create implementation:
```dart
// lib/core/implementations/dio_network_service.dart
import 'package:dio/dio.dart';
import '../interfaces/network_interface.dart';

class DioNetworkService implements INetworkService {
  late final Dio _dio;

  DioNetworkService() {
    _dio = Dio();
  }

  @override
  Future<NetworkResponse> get(String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return NetworkResponse(
        statusCode: response.statusCode!,
        data: response.data,
        headers: _convertHeaders(response.headers.map),
      );
    } on DioException catch (e) {
      throw NetworkException(
        e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }

  // ... implement other methods
}
```

3. Update the binding:
```dart
Get.put<INetworkService>(DioNetworkService(), permanent: true);
```

## Testing with Interfaces

Interfaces make testing easy with mocks:

```dart
// test/mocks/mock_storage_service.dart
class MockStorageService extends Mock implements IStorageService {}

// In your test:
test('should save user token', () async {
  final mockStorage = MockStorageService();
  when(mockStorage.setString('token', 'abc123'))
      .thenAnswer((_) async => true);

  // Test your code that uses IStorageService
});
```

## Best Practices

1. **Always use interfaces in business logic**: Don't reference concrete implementations
   ```dart
   // Good
   final IStorageService storage = Get.find<IStorageService>();
   
   // Bad
   final MemoryStorageService storage = Get.find<MemoryStorageService>();
   ```

2. **Register interfaces in bindings**: Use `Get.put<Interface>(Implementation())`
   ```dart
   Get.put<IStorageService>(MemoryStorageService(), permanent: true);
   ```

3. **Create adapters when needed**: Wrap existing services to conform to interfaces

4. **Document implementation choices**: Comment why you chose a specific implementation

5. **Keep interfaces simple**: Add only methods that are commonly needed

## Current Implementations

| Interface | Default Implementation | Alternative Options |
|-----------|----------------------|---------------------|
| IStorageService | MemoryStorageService | SharedPreferences, Hive, FlutterSecureStorage |
| INetworkService | ApiNetworkService | Dio, http package, Chopper |
| IDeviceInfoService | PlatformDeviceInfoService | device_info_plus package |
| IConnectivityService | SimpleConnectivityService | connectivity_plus package |
| ILoggerService | ConsoleLoggerService | logger package, firebase_crashlytics |

## Adding New Interfaces

To add a new interface:

1. Create the interface file in `lib/core/interfaces/`
2. Define abstract methods for the functionality
3. Create at least one implementation in `lib/core/implementations/`
4. Register in `app_bindings.dart`
5. Write tests in `test/core/implementations/`
6. Update this documentation

## Conclusion

These interfaces provide a flexible foundation for your application's native functionality. By programming to interfaces rather than implementations, you maintain clean architecture and make your codebase more maintainable and testable.
