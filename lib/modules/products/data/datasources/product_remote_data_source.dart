import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'product_data_source.dart';

/// Remote data source implementation for products
/// This handles all API calls to JSONPlaceholder API
class ProductRemoteDataSource implements ProductDataSource {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  ProductRemoteDataSource([http.Client? client]) 
      : _client = client ?? http.Client();

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // Limit to first 20 items for better performance
        return jsonList.take(20).map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/posts/$id'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData);
      } else {
        throw Exception('Product not found with id: $id');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': product.name,
          'body': product.description,
          'userId': (product.price / 10).round(),
        }),
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData).copyWith(
          lastUpdated: DateTime.now(),
        );
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/posts/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': int.parse(product.id),
          'title': product.name,
          'body': product.description,
          'userId': (product.price / 10).round(),
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData).copyWith(
          lastUpdated: DateTime.now(),
        );
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/posts/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    // JSONPlaceholder doesn't have search, so we fetch all and filter
    try {
      final allProducts = await getProducts();
      final lowerQuery = query.toLowerCase();

      return allProducts.where((product) {
        return product.name.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
  
  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}
