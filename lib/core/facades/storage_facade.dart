import '../service_locator/service_locator.dart';
import '../interfaces/storage_interface.dart';

/// Storage Facade - Laravel-style static access to storage service
/// Usage: Storage.set('key', 'value'); Storage.get('key');
class Storage {
  Storage._(); // Private constructor to prevent instantiation

  static IStorageService get _service => locator<IStorageService>();

  /// Save a string value
  static Future<bool> set(String key, String value) {
    return _service.setString(key, value);
  }

  /// Get a string value
  static Future<String?> get(String key) {
    return _service.getString(key);
  }

  /// Save an integer value
  static Future<bool> setInt(String key, int value) {
    return _service.setInt(key, value);
  }

  /// Get an integer value
  static Future<int?> getInt(String key) {
    return _service.getInt(key);
  }

  /// Save a boolean value
  static Future<bool> setBool(String key, bool value) {
    return _service.setBool(key, value);
  }

  /// Get a boolean value
  static Future<bool?> getBool(String key) {
    return _service.getBool(key);
  }

  /// Save a double value
  static Future<bool> setDouble(String key, double value) {
    return _service.setDouble(key, value);
  }

  /// Get a double value
  static Future<double?> getDouble(String key) {
    return _service.getDouble(key);
  }

  /// Save a list of strings
  static Future<bool> setList(String key, List<String> value) {
    return _service.setStringList(key, value);
  }

  /// Get a list of strings
  static Future<List<String>?> getList(String key) {
    return _service.getStringList(key);
  }

  /// Remove a value
  static Future<bool> remove(String key) {
    return _service.remove(key);
  }

  /// Clear all values
  static Future<bool> clear() {
    return _service.clear();
  }

  /// Check if a key exists
  static Future<bool> has(String key) {
    return _service.containsKey(key);
  }

  /// Get all keys
  static Future<Set<String>> keys() {
    return _service.getKeys();
  }
}
