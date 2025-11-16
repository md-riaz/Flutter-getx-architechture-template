# Facade Examples - Real-World Usage

This document shows practical examples of using the Laravel-style facades in real Flutter applications.

## Setup

Initialize the service locator in your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator with all services
  await setupServiceLocator();
  
  runApp(MyApp());
}
```

## Example 1: User Authentication Flow

```dart
import 'package:get/get.dart';
import 'package:your_app/core/facades/facades.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }
  
  /// Check if user is already logged in
  Future<void> checkLoginStatus() async {
    Log.debug('Checking login status');
    
    final token = await Storage.get('auth_token');
    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      Log.info('User already logged in');
    } else {
      Log.debug('No active session found');
    }
  }
  
  /// Login with email and password
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    Log.info('Login attempt', data: {'email': email});
    
    try {
      // Call your API
      final response = await yourApiClient.login(email, password);
      
      if (response.success) {
        // Save auth data
        await Storage.set('auth_token', response.token);
        await Storage.set('user_email', email);
        await Storage.setBool('remember_me', true);
        
        isLoggedIn.value = true;
        Log.info('Login successful', data: {'email': email});
        
        Get.offAllNamed('/dashboard');
      } else {
        Log.warning('Login failed', data: {'reason': response.error});
        Get.snackbar('Error', 'Invalid credentials');
      }
    } catch (e, stackTrace) {
      Log.error('Login error', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Logout
  Future<void> logout() async {
    Log.info('Logout initiated');
    
    // Clear storage
    await Storage.remove('auth_token');
    await Storage.remove('user_email');
    await Storage.remove('remember_me');
    
    isLoggedIn.value = false;
    Log.info('Logout complete');
    
    Get.offAllNamed('/login');
  }
}
```

## Example 2: Document Upload with Progress

```dart
import 'package:get/get.dart';
import 'package:your_app/core/facades/facades.dart';

class DocumentUploadController extends GetxController {
  final uploadProgress = 0.0.obs;
  final isUploading = false.obs;
  
  /// Pick and upload a document
  Future<void> pickAndUploadDocument() async {
    Log.info('Starting document upload flow');
    
    // Pick file
    final filePath = await Files.pick(
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    
    if (filePath == null) {
      Log.info('File selection cancelled');
      return;
    }
    
    // Get file info
    final fileName = Files.name(filePath);
    final fileSize = await Files.size(filePath);
    final fileExt = Files.extension(filePath);
    
    Log.info('File selected', data: {
      'name': fileName,
      'size': fileSize,
      'extension': fileExt,
    });
    
    // Validate file size (10MB limit)
    if (fileSize > 10 * 1024 * 1024) {
      Log.warning('File too large', data: {'size': fileSize});
      Get.snackbar('Error', 'File must be less than 10MB');
      return;
    }
    
    // Read file
    final bytes = await Files.readBytes(filePath);
    Log.debug('File read successfully', data: {'bytes': bytes.length});
    
    // Upload
    isUploading.value = true;
    try {
      await _uploadToServer(fileName, bytes);
      
      // Save to recent uploads
      final recentFiles = await Storage.getList('recent_uploads') ?? [];
      recentFiles.insert(0, fileName);
      await Storage.setList('recent_uploads', recentFiles.take(10).toList());
      
      Log.info('Document uploaded successfully', data: {'name': fileName});
      Get.snackbar('Success', 'Document uploaded');
    } catch (e, stackTrace) {
      Log.error('Upload failed', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Upload failed: $e');
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }
  
  Future<void> _uploadToServer(String fileName, List<int> bytes) async {
    // Simulate upload with progress
    for (var i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      uploadProgress.value = i / 100;
      Log.debug('Upload progress', data: {'percent': i});
    }
  }
}
```

## Example 3: Settings Manager

```dart
import 'package:get/get.dart';
import 'package:your_app/core/facades/facades.dart';

class SettingsController extends GetxController {
  // Observable settings
  final isDarkMode = false.obs;
  final notificationsEnabled = true.obs;
  final fontSize = 14.0.obs;
  final language = 'en'.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }
  
  /// Load all settings from storage
  Future<void> loadSettings() async {
    Log.info('Loading user settings');
    
    try {
      isDarkMode.value = await Storage.getBool('dark_mode') ?? false;
      notificationsEnabled.value = await Storage.getBool('notifications') ?? true;
      fontSize.value = await Storage.getDouble('font_size') ?? 14.0;
      language.value = await Storage.get('language') ?? 'en';
      
      Log.debug('Settings loaded', data: {
        'darkMode': isDarkMode.value,
        'notifications': notificationsEnabled.value,
        'fontSize': fontSize.value,
        'language': language.value,
      });
    } catch (e, stackTrace) {
      Log.error('Failed to load settings', error: e, stackTrace: stackTrace);
    }
  }
  
  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    isDarkMode.value = !isDarkMode.value;
    await Storage.setBool('dark_mode', isDarkMode.value);
    Log.info('Dark mode toggled', data: {'enabled': isDarkMode.value});
    
    // Apply theme change
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
  
  /// Toggle notifications
  Future<void> toggleNotifications() async {
    notificationsEnabled.value = !notificationsEnabled.value;
    await Storage.setBool('notifications', notificationsEnabled.value);
    Log.info('Notifications toggled', data: {'enabled': notificationsEnabled.value});
  }
  
  /// Update font size
  Future<void> updateFontSize(double size) async {
    fontSize.value = size;
    await Storage.setDouble('font_size', size);
    Log.info('Font size updated', data: {'size': size});
  }
  
  /// Change language
  Future<void> changeLanguage(String lang) async {
    language.value = lang;
    await Storage.set('language', lang);
    Log.info('Language changed', data: {'language': lang});
    
    // Update app locale
    Get.updateLocale(Locale(lang));
  }
  
  /// Export settings to file
  Future<void> exportSettings() async {
    Log.info('Exporting settings');
    
    final settings = {
      'dark_mode': isDarkMode.value,
      'notifications': notificationsEnabled.value,
      'font_size': fontSize.value,
      'language': language.value,
    };
    
    final json = jsonEncode(settings);
    final bytes = utf8.encode(json);
    
    final saved = await Files.save(
      fileName: 'settings_backup.json',
      bytes: bytes,
      dialogTitle: 'Export Settings',
    );
    
    if (saved) {
      Log.info('Settings exported successfully');
      Get.snackbar('Success', 'Settings exported');
    } else {
      Log.warning('Settings export cancelled');
    }
  }
  
  /// Import settings from file
  Future<void> importSettings() async {
    Log.info('Importing settings');
    
    final filePath = await Files.pick(allowedExtensions: ['json']);
    if (filePath == null) {
      Log.info('Import cancelled');
      return;
    }
    
    try {
      final json = await Files.readString(filePath);
      final settings = jsonDecode(json);
      
      // Apply imported settings
      isDarkMode.value = settings['dark_mode'] ?? false;
      notificationsEnabled.value = settings['notifications'] ?? true;
      fontSize.value = settings['font_size'] ?? 14.0;
      language.value = settings['language'] ?? 'en';
      
      // Save to storage
      await Storage.setBool('dark_mode', isDarkMode.value);
      await Storage.setBool('notifications', notificationsEnabled.value);
      await Storage.setDouble('font_size', fontSize.value);
      await Storage.set('language', language.value);
      
      Log.info('Settings imported successfully');
      Get.snackbar('Success', 'Settings imported');
    } catch (e, stackTrace) {
      Log.error('Import failed', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Invalid settings file');
    }
  }
  
  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    Log.warning('Resetting settings to defaults');
    
    await Storage.remove('dark_mode');
    await Storage.remove('notifications');
    await Storage.remove('font_size');
    await Storage.remove('language');
    
    await loadSettings(); // Reload defaults
    
    Log.info('Settings reset complete');
    Get.snackbar('Success', 'Settings reset to defaults');
  }
}
```

## Example 4: Image Gallery Manager

```dart
import 'package:get/get.dart';
import 'package:your_app/core/facades/facades.dart';

class GalleryController extends GetxController {
  final images = <String>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadSavedImages();
  }
  
  /// Load saved image paths
  Future<void> loadSavedImages() async {
    Log.info('Loading saved images');
    
    final savedPaths = await Storage.getList('gallery_images') ?? [];
    
    // Filter out non-existent files
    final validPaths = <String>[];
    for (final path in savedPaths) {
      if (await Files.exists(path)) {
        validPaths.add(path);
      } else {
        Log.warning('Image no longer exists', data: {'path': path});
      }
    }
    
    images.value = validPaths;
    Log.info('Loaded ${images.length} images');
  }
  
  /// Add images from gallery
  Future<void> addImages() async {
    Log.info('Selecting images');
    
    final selectedPaths = await Files.pickImages();
    if (selectedPaths.isEmpty) {
      Log.info('No images selected');
      return;
    }
    
    Log.info('Selected ${selectedPaths.length} images');
    
    // Add to list
    images.addAll(selectedPaths);
    
    // Save paths
    await Storage.setList('gallery_images', images);
    
    Log.info('Images added to gallery', data: {'count': selectedPaths.length});
    Get.snackbar('Success', '${selectedPaths.length} images added');
  }
  
  /// Remove image
  Future<void> removeImage(String path) async {
    Log.info('Removing image', data: {'path': path});
    
    images.remove(path);
    await Storage.setList('gallery_images', images);
    
    Log.info('Image removed from gallery');
  }
  
  /// Get image info
  Future<Map<String, dynamic>> getImageInfo(String path) async {
    final name = Files.name(path);
    final size = await Files.size(path);
    final ext = Files.extension(path);
    
    Log.debug('Image info', data: {
      'name': name,
      'size': size,
      'extension': ext,
    });
    
    return {
      'name': name,
      'size': size,
      'extension': ext,
      'sizeFormatted': _formatBytes(size),
    };
  }
  
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  
  /// Clear all images
  Future<void> clearGallery() async {
    Log.warning('Clearing gallery');
    
    images.clear();
    await Storage.remove('gallery_images');
    
    Log.info('Gallery cleared');
    Get.snackbar('Success', 'Gallery cleared');
  }
}
```

## Tips for Using Facades

### 1. Error Handling

Always wrap facade calls in try-catch for production:

```dart
try {
  await Storage.set('key', 'value');
  Log.info('Value saved');
} catch (e, stackTrace) {
  Log.error('Failed to save', error: e, stackTrace: stackTrace);
  // Handle error
}
```

### 2. Null Checks

File operations can return null:

```dart
final filePath = await Files.pick();
if (filePath != null) {
  // Process file
} else {
  Log.info('User cancelled');
}
```

### 3. Logging Levels

Use appropriate log levels:

```dart
Log.debug('Detailed info for debugging');
Log.info('General information');
Log.warning('Something unusual happened');
Log.error('An error occurred', error: exception);
Log.fatal('Critical error requiring attention');
```

### 4. Storage Keys

Use constants for storage keys:

```dart
class StorageKeys {
  static const authToken = 'auth_token';
  static const userEmail = 'user_email';
  static const darkMode = 'dark_mode';
}

// Usage
await Storage.set(StorageKeys.authToken, token);
final token = await Storage.get(StorageKeys.authToken);
```

## Conclusion

These examples show how facades make code cleaner and more maintainable. No dependency injection boilerplate, just clean, Laravel-style code! 🚀
