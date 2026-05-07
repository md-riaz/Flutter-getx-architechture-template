/// Interface for local storage operations
/// This allows swapping between different storage implementations
/// (SharedPreferences, Hive, Secure Storage, etc.) without changing usage
abstract class IStorageService {
  /// Initialize the storage service
  Future<void> init();

  /// Save a string value
  Future<bool> setString(String key, String value);

  /// Get a string value
  Future<String?> getString(String key);

  /// Save an integer value
  Future<bool> setInt(String key, int value);

  /// Get an integer value
  Future<int?> getInt(String key);

  /// Save a boolean value
  Future<bool> setBool(String key, bool value);

  /// Get a boolean value
  Future<bool?> getBool(String key);

  /// Save a double value
  Future<bool> setDouble(String key, double value);

  /// Get a double value
  Future<double?> getDouble(String key);

  /// Save a list of strings
  Future<bool> setStringList(String key, List<String> value);

  /// Get a list of strings
  Future<List<String>?> getStringList(String key);

  /// Remove a value
  Future<bool> remove(String key);

  /// Clear all values
  Future<bool> clear();

  /// Check if a key exists
  Future<bool> containsKey(String key);

  /// Get all keys
  Future<Set<String>> getKeys();
}
