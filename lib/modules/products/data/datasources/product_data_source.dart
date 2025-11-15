import '../models/product.dart';

/// Abstract interface for product data sources
/// This defines the contract that both local and remote data sources must implement
abstract class ProductDataSource {
  /// Fetch all products
  Future<List<Product>> getProducts();

  /// Fetch a single product by ID
  Future<Product> getProductById(String id);

  /// Create a new product
  Future<Product> createProduct(Product product);

  /// Update an existing product
  Future<Product> updateProduct(Product product);

  /// Delete a product by ID
  Future<void> deleteProduct(String id);

  /// Search products by name or description
  Future<List<Product>> searchProducts(String query);
}
