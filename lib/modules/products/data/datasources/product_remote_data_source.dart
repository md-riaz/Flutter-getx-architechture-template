import 'package:dio/dio.dart';
import '../models/product.dart';
import 'product_data_source.dart';

/// Remote data source implementation for products
/// This handles all API calls to JSONPlaceholder API using Dio
/// Dio provides network interceptors for auth token injection and other middleware
class ProductRemoteDataSource implements ProductDataSource {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final Dio _dio;

  ProductRemoteDataSource([Dio? dio]) 
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

  /// Configure interceptors for auth token injection and logging
  void configureInterceptors({
    String? authToken,
    bool enableLogging = false,
  }) {
    _dio.interceptors.clear();
    
    // Add auth interceptor if token is provided
    if (authToken != null) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] = 'Bearer $authToken';
            return handler.next(options);
          },
        ),
      );
    }
    
    // Add logging interceptor if enabled
    if (enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/posts');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        // Limit to first 20 items for better performance
        return jsonList.take(20).map((json) => Product.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load products: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load products: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get('/posts/$id');

      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Product not found with id: $id',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: {
          'title': product.name,
          'body': product.description,
          'userId': (product.price / 10).round(),
        },
      );

      if (response.statusCode == 201) {
        return Product.fromJson(response.data).copyWith(
          lastUpdated: DateTime.now(),
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create product: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to create product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final response = await _dio.put(
        '/posts/${product.id}',
        data: {
          'id': int.parse(product.id),
          'title': product.name,
          'body': product.description,
          'userId': (product.price / 10).round(),
        },
      );

      if (response.statusCode == 200) {
        return Product.fromJson(response.data).copyWith(
          lastUpdated: DateTime.now(),
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to update product: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to update product: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response = await _dio.delete('/posts/$id');

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to delete product: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete product: ${e.message}');
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
  
  /// Close Dio instance
  void dispose() {
    _dio.close();
  }
}
