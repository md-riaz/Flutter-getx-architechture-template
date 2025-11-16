# Laravel-Style Service Layer

## Overview

This architecture provides a Laravel-inspired service layer with clean, elegant APIs. It combines:

- **Service Locator** (get_it) for dependency injection
- **Interfaces** for abstraction and testability
- **Facades** for clean, static access (Laravel-style)
- **Implementations** that can be swapped without code changes

## Architecture

```
┌─────────────────────────────────────────────┐
│         Your Code (Controllers, etc)         │
│                                              │
│  Uses Facades: Storage.set(), Log.info()    │
└───────────────────┬──────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│          Facade Layer (Static API)           │
│                                              │
│  Storage → IStorageService                   │
│  Log → ILoggerService                        │
│  Files → IFileService                        │
└───────────────────┬──────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│      Service Locator (get_it)                │
│                                              │
│  Manages instances and dependencies          │
└───────────────────┬──────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│      Implementations (Concrete Classes)      │
│                                              │
│  MemoryStorageService                        │
│  FilePickerService                           │
│  ConsoleLoggerService                        │
└──────────────────────────────────────────────┘
```

## Quick Start

### 1. Setup Service Locator

Initialize the service locator in your `main.dart` before running the app:

```dart
import 'package:flutter/material.dart';
import 'core/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator
  await setupServiceLocator();
  
  runApp(MyApp());
}
```

### 2. Use Facades (Laravel-Style)

#### Storage Facade

```dart
import 'package:your_app/core/facades/facades.dart';

// Save data
await Storage.set('user_token', 'abc123');
await Storage.setInt('login_count', 5);
await Storage.setBool('remember_me', true);

// Retrieve data
final token = await Storage.get('user_token');
final count = await Storage.getInt('login_count');
final remember = await Storage.getBool('remember_me');

// Check existence
if (await Storage.has('user_token')) {
  print('Token exists');
}

// Remove data
await Storage.remove('user_token');

// Clear all
await Storage.clear();
```

#### Log Facade

```dart
import 'package:your_app/core/facades/facades.dart';

// Log messages
Log.debug('Debug message', data: {'key': 'value'});
Log.info('User logged in', data: {'userId': user.id});
Log.warning('Low memory warning');
Log.error('Failed to save', error: exception, stackTrace: stackTrace);
Log.fatal('Critical error', error: exception);

// Configure logging
Log.setLevel(LogLevel.info); // Only log info and above
Log.setEnabled(false); // Disable logging
```

#### File Facade

```dart
import 'package:your_app/core/facades/facades.dart';

// Pick a single file
final filePath = await Files.pick();
if (filePath != null) {
  print('Selected: $filePath');
}

// Pick multiple files
final files = await Files.pickMultiple(
  allowedExtensions: ['pdf', 'doc', 'docx'],
);

// Pick an image
final imagePath = await Files.pickImage();

// Pick multiple images
final images = await Files.pickImages();

// Pick a video
final videoPath = await Files.pickVideo();

// Save a file
final bytes = utf8.encode('Hello, World!');
final saved = await Files.save(
  fileName: 'output.txt',
  bytes: bytes,
  dialogTitle: 'Save File',
);

// File operations
final size = await Files.size(filePath);
final name = Files.name(filePath);
final ext = Files.extension(filePath);
final exists = await Files.exists(filePath);

// Read file
final content = await Files.readString(filePath);
final bytes = await Files.readBytes(filePath);

// Delete file
await Files.delete(filePath);
```

## Comparison: Before vs After

### Before (Traditional Approach)

```dart
class MyController extends GetxController {
  final IStorageService storage = Get.find<IStorageService>();
  final ILoggerService logger = Get.find<ILoggerService>();
  final IFileService fileService = Get.find<IFileService>();
  
  Future<void> saveUserData() async {
    logger.info('Saving user data');
    await storage.setString('username', 'John');
    final filePath = await fileService.pickFile();
    // ...
  }
}
```

### After (Laravel-Style with Facades)

```dart
import 'package:your_app/core/facades/facades.dart';

class MyController extends GetxController {
  Future<void> saveUserData() async {
    Log.info('Saving user data');
    await Storage.set('username', 'John');
    final filePath = await Files.pick();
    // ...
  }
}
```

**Benefits:**
- ✅ Cleaner, more readable code
- ✅ No dependency injection boilerplate
- ✅ Laravel-like developer experience
- ✅ Still fully testable (can mock the service locator)

## Available Facades

### 1. Storage Facade

**Static Class:** `Storage`

**Methods:**
- `Storage.set(key, value)` - Save string
- `Storage.get(key)` - Get string
- `Storage.setInt(key, value)` - Save int
- `Storage.getInt(key)` - Get int
- `Storage.setBool(key, value)` - Save bool
- `Storage.getBool(key)` - Get bool
- `Storage.setDouble(key, value)` - Save double
- `Storage.getDouble(key)` - Get double
- `Storage.setList(key, value)` - Save list
- `Storage.getList(key)` - Get list
- `Storage.remove(key)` - Remove value
- `Storage.clear()` - Clear all
- `Storage.has(key)` - Check existence
- `Storage.keys()` - Get all keys

### 2. Log Facade

**Static Class:** `Log`

**Methods:**
- `Log.debug(message, {data})` - Debug message
- `Log.info(message, {data})` - Info message
- `Log.warning(message, {data})` - Warning message
- `Log.error(message, {error, stackTrace, data})` - Error message
- `Log.fatal(message, {error, stackTrace, data})` - Fatal message
- `Log.setLevel(level)` - Set log level
- `Log.setEnabled(enabled)` - Enable/disable

### 3. Files Facade

**Static Class:** `Files`

**Methods:**
- `Files.pick({allowedExtensions})` - Pick single file
- `Files.pickMultiple({allowedExtensions})` - Pick multiple files
- `Files.pickImage({fromCamera})` - Pick image
- `Files.pickImages()` - Pick multiple images
- `Files.pickVideo({fromCamera})` - Pick video
- `Files.pickDirectory()` - Pick directory
- `Files.save({fileName, bytes, dialogTitle})` - Save file
- `Files.size(filePath)` - Get file size
- `Files.name(filePath)` - Get file name
- `Files.extension(filePath)` - Get extension
- `Files.exists(filePath)` - Check existence
- `Files.readBytes(filePath)` - Read as bytes
- `Files.readString(filePath)` - Read as string
- `Files.delete(filePath)` - Delete file

## Real-World Examples

### Example 1: User Profile with Avatar

```dart
import 'package:your_app/core/facades/facades.dart';

class ProfileController extends GetxController {
  Future<void> updateProfile(User user) async {
    Log.info('Updating profile', data: {'userId': user.id});
    
    try {
      // Save user data
      await Storage.set('user_id', user.id);
      await Storage.set('username', user.name);
      await Storage.set('email', user.email);
      
      Log.info('Profile updated successfully');
    } catch (e, stackTrace) {
      Log.error('Failed to update profile', error: e, stackTrace: stackTrace);
    }
  }
  
  Future<void> uploadAvatar() async {
    Log.info('Selecting avatar image');
    
    final imagePath = await Files.pickImage();
    if (imagePath == null) {
      Log.info('Avatar selection cancelled');
      return;
    }
    
    Log.info('Avatar selected', data: {'path': imagePath});
    
    // Get file info
    final size = await Files.size(imagePath);
    Log.debug('Avatar size: $size bytes');
    
    if (size > 5 * 1024 * 1024) { // 5MB limit
      Log.warning('Avatar too large', data: {'size': size});
      return;
    }
    
    // Read and upload
    final bytes = await Files.readBytes(imagePath);
    // Upload to server...
    
    Log.info('Avatar uploaded successfully');
  }
}
```

### Example 2: Document Manager

```dart
import 'package:your_app/core/facades/facades.dart';

class DocumentController extends GetxController {
  Future<void> importDocuments() async {
    Log.info('Importing documents');
    
    final files = await Files.pickMultiple(
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );
    
    if (files.isEmpty) {
      Log.info('No documents selected');
      return;
    }
    
    Log.info('Selected ${files.length} documents');
    
    for (final filePath in files) {
      await _processDocument(filePath);
    }
  }
  
  Future<void> _processDocument(String filePath) async {
    final name = Files.name(filePath);
    final ext = Files.extension(filePath);
    final size = await Files.size(filePath);
    
    Log.debug('Processing document', data: {
      'name': name,
      'extension': ext,
      'size': size,
    });
    
    // Process document...
    
    // Save metadata
    await Storage.set('doc_${name}_path', filePath);
    await Storage.setInt('doc_${name}_size', size);
    
    Log.info('Document processed', data: {'name': name});
  }
  
  Future<void> exportReport() async {
    Log.info('Generating report');
    
    final reportContent = 'Report content...';
    final bytes = utf8.encode(reportContent);
    
    final saved = await Files.save(
      fileName: 'report_${DateTime.now().millisecondsSinceEpoch}.txt',
      bytes: bytes,
      dialogTitle: 'Save Report',
    );
    
    if (saved) {
      Log.info('Report exported successfully');
    } else {
      Log.warning('Report export cancelled or failed');
    }
  }
}
```

### Example 3: Settings Manager

```dart
import 'package:your_app/core/facades/facades.dart';

class SettingsController extends GetxController {
  // Load settings
  Future<Settings> loadSettings() async {
    Log.info('Loading settings');
    
    final theme = await Storage.get('theme') ?? 'light';
    final notifications = await Storage.getBool('notifications') ?? true;
    final fontSize = await Storage.getInt('font_size') ?? 14;
    final language = await Storage.get('language') ?? 'en';
    
    Log.debug('Settings loaded', data: {
      'theme': theme,
      'notifications': notifications,
      'fontSize': fontSize,
      'language': language,
    });
    
    return Settings(
      theme: theme,
      notifications: notifications,
      fontSize: fontSize,
      language: language,
    );
  }
  
  // Save settings
  Future<void> saveSettings(Settings settings) async {
    Log.info('Saving settings');
    
    await Storage.set('theme', settings.theme);
    await Storage.setBool('notifications', settings.notifications);
    await Storage.setInt('font_size', settings.fontSize);
    await Storage.set('language', settings.language);
    
    Log.info('Settings saved successfully');
  }
  
  // Reset to defaults
  Future<void> resetSettings() async {
    Log.warning('Resetting settings to defaults');
    
    await Storage.remove('theme');
    await Storage.remove('notifications');
    await Storage.remove('font_size');
    await Storage.remove('language');
    
    Log.info('Settings reset complete');
  }
}
```

## Testing with Facades

### Mock the Service Locator

```dart
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

class MockStorageService extends Mock implements IStorageService {}
class MockLoggerService extends Mock implements ILoggerService {}
class MockFileService extends Mock implements IFileService {}

void main() {
  setUp(() {
    // Reset and setup mock services
    GetIt.instance.reset();
    
    GetIt.instance.registerLazySingleton<IStorageService>(
      () => MockStorageService(),
    );
    GetIt.instance.registerLazySingleton<ILoggerService>(
      () => MockLoggerService(),
    );
    GetIt.instance.registerLazySingleton<IFileService>(
      () => MockFileService(),
    );
  });
  
  test('should save user data', () async {
    final mockStorage = GetIt.instance<IStorageService>() as MockStorageService;
    
    when(mockStorage.setString('username', 'John'))
        .thenAnswer((_) async => true);
    
    // Test code using Storage facade
    await Storage.set('username', 'John');
    
    verify(mockStorage.setString('username', 'John')).called(1);
  });
}
```

## Swapping Implementations

The power of this architecture is that you can swap implementations without changing any code that uses the facades.

### Example: Upgrade from Memory to SharedPreferences

```dart
// In service_locator.dart
// Change this:
locator.registerLazySingleton<IStorageService>(
  () => MemoryStorageService(),
);

// To this:
locator.registerLazySingleton<IStorageService>(
  () => SharedPreferencesStorageService(),
);
```

All code using `Storage.set()` and `Storage.get()` continues to work without any changes!

## Best Practices

### DO:
✅ Use facades for clean, readable code  
✅ Initialize service locator at app startup  
✅ Log important operations  
✅ Handle errors gracefully  
✅ Mock services in tests

### DON'T:
❌ Initialize service locator multiple times  
❌ Access services before initialization  
❌ Mix facade and direct service access  
❌ Forget to handle null returns from file picker

## Conclusion

This Laravel-style service layer provides:

- **Elegant API** - Clean, static access like Laravel facades
- **Flexibility** - Easy to swap implementations
- **Testability** - Simple mocking with service locator
- **Productivity** - Write less boilerplate, more business logic
- **Maintainability** - Clear separation of concerns

Enjoy the Laravel experience in Flutter! 🚀
