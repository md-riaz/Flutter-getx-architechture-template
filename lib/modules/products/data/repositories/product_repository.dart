import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product.dart';

/// Product repository implementing the Repository Pattern
/// 
/// This repository orchestrates between local and remote data sources:
/// - Uses local cache for faster access when available
/// - Falls back to remote API when cache is invalid or unavailable
/// - Automatically updates cache when fetching from remote
/// - Provides a single, clean API for the rest of the application
/// 
/// Example usage:
/// ```dart
/// final repository = ProductRepository(remoteDataSource, localDataSource);
/// 
/// // This will check cache first, then fall back to remote if needed
/// final products = await repository.getProducts();
/// 
/// // Force refresh from remote
/// final freshProducts = await repository.getProducts(forceRefresh: true);
/// ```
class ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepository(this._remoteDataSource, this._localDataSource);

  /// Get all products
  /// 
  /// Strategy:
  /// 1. If forceRefresh is true, fetch from remote and update cache
  /// 2. If cache is valid, return from cache
  /// 3. Otherwise, fetch from remote and update cache
  /// 
  /// [forceRefresh] - Force fetching from remote even if cache is valid
  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    // If force refresh, always fetch from remote
    if (forceRefresh) {
      return _fetchFromRemoteAndCache();
    }

    // Check if cache is valid
    if (_localDataSource.isCacheValid()) {
      try {
        // Return from cache
        return await _localDataSource.getProducts();
      } catch (e) {
        // If cache read fails, fetch from remote
        return _fetchFromRemoteAndCache();
      }
    }

    // Cache is invalid or doesn't exist, fetch from remote
    return _fetchFromRemoteAndCache();
  }

  /// Get products with pagination support
  /// 
  /// Strategy:
  /// Always fetches from remote for pagination to ensure fresh data
  /// and proper page boundaries. Cache is not used for paginated requests
  /// to avoid inconsistencies with page boundaries.
  /// 
  /// [pageKey] - The page number to fetch (1-based)
  /// [pageSize] - Number of items per page
  Future<List<Product>> getProductsPaginated({
    required int pageKey,
    int pageSize = 20,
  }) async {
    return await _remoteDataSource.getProductsPaginated(
      pageKey: pageKey,
      pageSize: pageSize,
    );
  }

  /// Get a single product by ID
  /// 
  /// Strategy:
  /// 1. If forceRefresh is true, fetch from remote and update cache
  /// 2. Try to get from cache first
  /// 3. If not in cache, fetch from remote and cache it
  /// 
  /// [id] - Product ID
  /// [forceRefresh] - Force fetching from remote even if in cache
  Future<Product> getProductById(String id, {bool forceRefresh = false}) async {
    // If force refresh, fetch from remote
    if (forceRefresh) {
      final product = await _remoteDataSource.getProductById(id);
      await _localDataSource.cacheProduct(product);
      return product;
    }

    // Try to get from cache first
    try {
      return await _localDataSource.getProductById(id);
    } catch (e) {
      // Not in cache, fetch from remote
      final product = await _remoteDataSource.getProductById(id);
      await _localDataSource.cacheProduct(product);
      return product;
    }
  }

  /// Create a new product
  /// 
  /// Strategy:
  /// 1. Create on remote server
  /// 2. Add to local cache
  /// 3. Return the created product
  Future<Product> createProduct(Product product) async {
    // Create on remote
    final createdProduct = await _remoteDataSource.createProduct(product);

    // Cache the new product
    await _localDataSource.cacheProduct(createdProduct);

    return createdProduct;
  }

  /// Update an existing product
  /// 
  /// Strategy:
  /// 1. Update on remote server
  /// 2. Update in local cache
  /// 3. Return the updated product
  Future<Product> updateProduct(Product product) async {
    // Update on remote
    final updatedProduct = await _remoteDataSource.updateProduct(product);

    // Update cache
    await _localDataSource.updateProduct(updatedProduct);

    return updatedProduct;
  }

  /// Delete a product
  /// 
  /// Strategy:
  /// 1. Delete from remote server
  /// 2. Remove from local cache
  Future<void> deleteProduct(String id) async {
    // Delete from remote
    await _remoteDataSource.deleteProduct(id);

    // Remove from cache
    await _localDataSource.deleteProduct(id);
  }

  /// Search products by query
  /// 
  /// Strategy:
  /// 1. If cache is valid, search in cache (faster)
  /// 2. Otherwise, search on remote and update cache
  /// 
  /// [query] - Search query string
  /// [forceRemote] - Force searching on remote even if cache is valid
  Future<List<Product>> searchProducts(
    String query, {
    bool forceRemote = false,
  }) async {
    // If force remote or cache is invalid, search on remote
    if (forceRemote || !_localDataSource.isCacheValid()) {
      return await _remoteDataSource.searchProducts(query);
    }

    // Search in cache
    return await _localDataSource.searchProducts(query);
  }

  /// Clear local cache
  /// Useful when user logs out or wants to free up storage
  Future<void> clearCache() async {
    await _localDataSource.clearCache();
  }

  /// Check if local cache exists and is valid
  bool isCacheValid() {
    return _localDataSource.isCacheValid();
  }

  /// Get cache timestamp
  DateTime? getCacheTimestamp() {
    return _localDataSource.getCacheTimestamp();
  }

  /// Helper method to fetch from remote and update cache
  Future<List<Product>> _fetchFromRemoteAndCache() async {
    final products = await _remoteDataSource.getProducts();
    await _localDataSource.cacheProducts(products);
    return products;
  }
}
