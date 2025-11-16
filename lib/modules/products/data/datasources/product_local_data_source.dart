import 'package:hive/hive.dart';
import '../models/product.dart';
import 'product_data_source.dart';

/// Local data source implementation for products using Hive
/// This handles caching and local storage of product data
class ProductLocalDataSource implements ProductDataSource {
  static const String _boxName = 'products';
  static const String _timestampKey = 'cache_timestamp';
  
  Box<Product>? _box;
  Box<String>? _metaBox;

  /// Cache expiry duration (5 minutes for example)
  static const Duration cacheExpiry = Duration(minutes: 5);

  /// Initialize Hive boxes
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<Product>(_boxName);
    }
    if (_metaBox == null || !_metaBox!.isOpen) {
      _metaBox = await Hive.openBox<String>('${_boxName}_meta');
    }
  }

  /// Ensure boxes are initialized
  Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    await _ensureInitialized();
    return _box!.values.toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    await _ensureInitialized();
    final product = _box!.get(id);
    if (product == null) {
      throw Exception('Product not found in cache: $id');
    }
    return product;
  }

  @override
  Future<Product> createProduct(Product product) async {
    await _ensureInitialized();
    await _box!.put(product.id, product);
    await _updateCacheTimestamp();
    return product;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    await _ensureInitialized();
    await _box!.put(product.id, product);
    await _updateCacheTimestamp();
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _ensureInitialized();
    await _box!.delete(id);
    await _updateCacheTimestamp();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await _ensureInitialized();
    final lowerQuery = query.toLowerCase();
    return _box!.values.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Cache all products from a list
  Future<void> cacheProducts(List<Product> products) async {
    await _ensureInitialized();
    await _box!.clear();
    for (final product in products) {
      await _box!.put(product.id, product);
    }
    await _updateCacheTimestamp();
  }

  /// Cache a single product
  Future<void> cacheProduct(Product product) async {
    await _ensureInitialized();
    await _box!.put(product.id, product);
    await _updateCacheTimestamp();
  }

  /// Check if cache is valid (not expired)
  bool isCacheValid() {
    final timestampStr = _metaBox?.get(_timestampKey);
    if (timestampStr == null || _box == null || _box!.isEmpty) {
      return false;
    }

    final cacheTimestamp = DateTime.parse(timestampStr);
    final now = DateTime.now();
    final difference = now.difference(cacheTimestamp);

    return difference < cacheExpiry;
  }

  /// Check if cache has data
  bool hasCache() {
    return _box != null && _box!.isNotEmpty;
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _ensureInitialized();
    await _box!.clear();
    await _metaBox!.delete(_timestampKey);
  }

  /// Get cache timestamp
  DateTime? getCacheTimestamp() {
    final timestampStr = _metaBox?.get(_timestampKey);
    if (timestampStr == null) return null;
    return DateTime.parse(timestampStr);
  }

  /// Update cache timestamp
  Future<void> _updateCacheTimestamp() async {
    await _ensureInitialized();
    await _metaBox!.put(_timestampKey, DateTime.now().toIso8601String());
  }
  
  /// Close Hive boxes
  Future<void> close() async {
    await _box?.close();
    await _metaBox?.close();
  }
}
