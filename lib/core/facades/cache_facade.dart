import 'storage_facade.dart';

class Cache {
  Cache._();

  static Future<bool> put(String key, String value) {
    return Storage.set(key, value);
  }

  static Future<String?> get(String key) {
    return Storage.get(key);
  }

  static Future<bool> forget(String key) {
    return Storage.remove(key);
  }

  static Future<bool> clear() {
    return Storage.clear();
  }

  static Future<bool> has(String key) {
    return Storage.has(key);
  }
}
