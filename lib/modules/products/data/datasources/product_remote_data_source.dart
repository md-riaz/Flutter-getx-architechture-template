import '../../../../core/services/api_client.dart';
import '../models/product.dart';
import 'product_data_source.dart';

/// Remote data source implementation for products
/// This handles all API calls to the backend server
class ProductRemoteDataSource implements ProductDataSource {
  final ApiClient _apiClient;

  ProductRemoteDataSource(this._apiClient);

  @override
  Future<List<Product>> getProducts() async {
    // Simulate API call with delay
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, this would call:
    // final response = await _apiClient.get('/products');
    // return (response['data'] as List).map((e) => Product.fromJson(e)).toList();

    // Mock data for demonstration
    return [
      Product(
        id: '1',
        name: 'Laptop Pro 15',
        description: 'High-performance laptop for professionals',
        price: 1299.99,
        stock: 15,
        imageUrl: 'https://example.com/laptop.jpg',
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '2',
        name: 'Wireless Mouse',
        description: 'Ergonomic wireless mouse with long battery life',
        price: 29.99,
        stock: 50,
        imageUrl: 'https://example.com/mouse.jpg',
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '3',
        name: 'Mechanical Keyboard',
        description: 'RGB mechanical keyboard with blue switches',
        price: 89.99,
        stock: 30,
        imageUrl: 'https://example.com/keyboard.jpg',
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '4',
        name: '4K Monitor',
        description: '27-inch 4K UHD monitor with HDR support',
        price: 449.99,
        stock: 12,
        imageUrl: 'https://example.com/monitor.jpg',
        lastUpdated: DateTime.now(),
      ),
      Product(
        id: '5',
        name: 'USB-C Hub',
        description: 'Multi-port USB-C hub with HDMI and ethernet',
        price: 59.99,
        stock: 40,
        imageUrl: 'https://example.com/hub.jpg',
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  @override
  Future<Product> getProductById(String id) async {
    // Simulate API call with delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, this would call:
    // final response = await _apiClient.get('/products/$id');
    // return Product.fromJson(response['data']);

    // Mock data for demonstration
    final products = await getProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      throw Exception('Product not found with id: $id');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    // Simulate API call with delay
    await Future.delayed(const Duration(milliseconds: 600));

    // In a real app, this would call:
    // final response = await _apiClient.post('/products', product.toJson());
    // return Product.fromJson(response['data']);

    // Return the product with updated timestamp
    return product.copyWith(
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<Product> updateProduct(Product product) async {
    // Simulate API call with delay
    await Future.delayed(const Duration(milliseconds: 600));

    // In a real app, this would call:
    // final response = await _apiClient.put('/products/${product.id}', product.toJson());
    // return Product.fromJson(response['data']);

    // Return the product with updated timestamp
    return product.copyWith(
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Simulate API call with delay
    await Future.delayed(const Duration(milliseconds: 400));

    // In a real app, this would call:
    // await _apiClient.delete('/products/$id');
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    // Simulate API call with delay
    await Future.delayed(const Duration(milliseconds: 700));

    // In a real app, this would call:
    // final response = await _apiClient.get('/products/search?q=$query');
    // return (response['data'] as List).map((e) => Product.fromJson(e)).toList();

    // Mock search implementation
    final allProducts = await getProducts();
    final lowerQuery = query.toLowerCase();

    return allProducts.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
