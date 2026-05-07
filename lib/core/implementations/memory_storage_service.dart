import '../interfaces/storage_interface.dart';

/// In-memory implementation of IStorageService
/// This is a simple implementation for testing or when persistence is not needed
/// Can be replaced with SharedPreferences, Hive, or other storage solutions
class MemoryStorageService implements IStorageService {
  final Map<String, dynamic> _storage = {};
  bool _initialized = false;

  @override
  Future<void> init() async {
    _initialized = true;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('MemoryStorageService not initialized. Call init() first.');
    }
  }

  @override
  Future<bool> setString(String key, String value) async {
    _ensureInitialized();
    _storage[key] = value;
    return true;
  }

  @override
  Future<String?> getString(String key) async {
    _ensureInitialized();
    return _storage[key] as String?;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _ensureInitialized();
    _storage[key] = value;
    return true;
  }

  @override
  Future<int?> getInt(String key) async {
    _ensureInitialized();
    return _storage[key] as int?;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _ensureInitialized();
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool?> getBool(String key) async {
    _ensureInitialized();
    return _storage[key] as bool?;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _ensureInitialized();
    _storage[key] = value;
    return true;
  }

  @override
  Future<double?> getDouble(String key) async {
    _ensureInitialized();
    return _storage[key] as double?;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _ensureInitialized();
    _storage[key] = List<String>.from(value);
    return true;
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    _ensureInitialized();
    final value = _storage[key];
    if (value == null) return null;
    return List<String>.from(value as List);
  }

  @override
  Future<bool> remove(String key) async {
    _ensureInitialized();
    _storage.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _ensureInitialized();
    _storage.clear();
    return true;
  }

  @override
  Future<bool> containsKey(String key) async {
    _ensureInitialized();
    return _storage.containsKey(key);
  }

  @override
  Future<Set<String>> getKeys() async {
    _ensureInitialized();
    return _storage.keys.toSet();
  }
}
