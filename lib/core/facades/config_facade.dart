class Config {
  Config._();

  static final Map<String, dynamic> _values = {};

  static void set(String key, dynamic value) {
    _values[key] = value;
  }

  static T? get<T>(String key) {
    final value = _values[key];
    if (value is T) return value;
    return null;
  }

  static bool has(String key) => _values.containsKey(key);

  static void remove(String key) => _values.remove(key);

  static void clear() => _values.clear();
}
