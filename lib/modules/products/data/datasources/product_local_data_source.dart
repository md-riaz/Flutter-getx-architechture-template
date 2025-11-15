import '../models/product.dart';
import 'product_data_source.dart';

/// Local data source implementation for products
/// This handles caching and local storage of product data
/// In a real app, this would use SharedPreferences, Hive, SQLite, etc.
/// For this example, we use an in-memory cache
class ProductLocalDataSource implements ProductDataSource {
  // In-memory cache for demonstration
  // In a real app, you would use SharedPreferences, Hive, SQLite, etc.
  final Map<String, Product> _cache = {};
  DateTime? _cacheTimestamp;

  /// Cache expiry duration (5 minutes for example)
  static const Duration cacheExpiry = Duration(minutes: 5);

  @override
  Future<List<Product>> getProducts() async {
    // Simulate local storage access delay (much faster than remote)
    await Future.delayed(const Duration(milliseconds: 50));

    return _cache.values.toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    // Simulate local storage access delay
    await Future.delayed(const Duration(milliseconds: 30));

    final product = _cache[id];
    if (product == null) {
      throw Exception('Product not found in cache: $id');
    }

    return product;
  }

  @override
  Future<Product> createProduct(Product product) async {
    // Simulate local storage write delay
    await Future.delayed(const Duration(milliseconds: 40));

    _cache[product.id] = product;
    _updateCacheTimestamp();

    return product;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    // Simulate local storage write delay
    await Future.delayed(const Duration(milliseconds: 40));

    _cache[product.id] = product;
    _updateCacheTimestamp();

    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Simulate local storage delete delay
    await Future.delayed(const Duration(milliseconds: 30));

    _cache.remove(id);
    _updateCacheTimestamp();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    // Simulate local storage search delay
    await Future.delayed(const Duration(milliseconds: 50));

    final lowerQuery = query.toLowerCase();
    return _cache.values.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Cache all products from a list
  Future<void> cacheProducts(List<Product> products) async {
    await Future.delayed(const Duration(milliseconds: 60));

    _cache.clear();
    for (final product in products) {
      _cache[product.id] = product;
    }
    _updateCacheTimestamp();
  }

  /// Cache a single product
  Future<void> cacheProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 40));

    _cache[product.id] = product;
    _updateCacheTimestamp();
  }

  /// Check if cache is valid (not expired)
  bool isCacheValid() {
    if (_cacheTimestamp == null || _cache.isEmpty) {
      return false;
    }

    final now = DateTime.now();
    final difference = now.difference(_cacheTimestamp!);

    return difference < cacheExpiry;
  }

  /// Check if cache has data
  bool hasCache() {
    return _cache.isNotEmpty;
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await Future.delayed(const Duration(milliseconds: 30));

    _cache.clear();
    _cacheTimestamp = null;
  }

  /// Get cache timestamp
  DateTime? getCacheTimestamp() {
    return _cacheTimestamp;
  }

  /// Update cache timestamp
  void _updateCacheTimestamp() {
    _cacheTimestamp = DateTime.now();
  }
}
