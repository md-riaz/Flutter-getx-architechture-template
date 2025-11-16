import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/modules/products/data/datasources/product_remote_data_source.dart';
import 'package:getx_modular_template/modules/products/data/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('ProductRemoteDataSource', () {
    late ProductRemoteDataSource dataSource;

    test('getProducts returns list of products from API', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts') {
          return http.Response(
            json.encode([
              {'id': 1, 'title': 'Test Product 1', 'body': 'Description 1', 'userId': 1},
              {'id': 2, 'title': 'Test Product 2', 'body': 'Description 2', 'userId': 2},
            ]),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);
      final products = await dataSource.getProducts();

      expect(products, isA<List<Product>>());
      expect(products.length, 2);
      expect(products.first.name, 'Test Product 1');
      expect(products.first.description, 'Description 1');
    });

    test('getProducts throws exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      dataSource = ProductRemoteDataSource(mockClient);

      expect(
        () => dataSource.getProducts(),
        throwsException,
      );
    });

    test('getProductById returns correct product', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts/1') {
          return http.Response(
            json.encode({'id': 1, 'title': 'Test Product', 'body': 'Description', 'userId': 1}),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);
      final product = await dataSource.getProductById('1');

      expect(product, isA<Product>());
      expect(product.id, '1');
      expect(product.name, 'Test Product');
    });

    test('getProductById throws exception for invalid id', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);

      expect(
        () => dataSource.getProductById('999'),
        throwsException,
      );
    });

    test('createProduct returns product with timestamp', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts' &&
            request.method == 'POST') {
          return http.Response(
            json.encode({'id': 101, 'title': 'Test Product', 'body': 'Test Description', 'userId': 10}),
            201,
          );
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);
      
      final newProduct = Product(
        id: '101',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        stock: 10,
      );

      final createdProduct = await dataSource.createProduct(newProduct);

      expect(createdProduct.id, '101');
      expect(createdProduct.name, 'Test Product');
      expect(createdProduct.lastUpdated, isNotNull);
    });

    test('updateProduct returns updated product with new timestamp', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts/1' &&
            request.method == 'PUT') {
          return http.Response(
            json.encode({'id': 1, 'title': 'Updated Product', 'body': 'Updated Description', 'userId': 20}),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);
      
      final product = Product(
        id: '1',
        name: 'Updated Product',
        description: 'Updated Description',
        price: 199.99,
        stock: 20,
      );

      final updatedProduct = await dataSource.updateProduct(product);

      expect(updatedProduct.id, '1');
      expect(updatedProduct.name, 'Updated Product');
      expect(updatedProduct.lastUpdated, isNotNull);
    });

    test('deleteProduct completes successfully', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts/1' &&
            request.method == 'DELETE') {
          return http.Response('', 200);
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);

      await expectLater(
        dataSource.deleteProduct('1'),
        completes,
      );
    });

    test('searchProducts returns matching products', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts') {
          return http.Response(
            json.encode([
              {'id': 1, 'title': 'Laptop Pro', 'body': 'Professional laptop', 'userId': 1},
              {'id': 2, 'title': 'Mouse', 'body': 'Wireless mouse', 'userId': 2},
            ]),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);
      final results = await dataSource.searchProducts('laptop');

      expect(results, isA<List<Product>>());
      expect(results.isNotEmpty, isTrue);
      expect(results.first.name.toLowerCase(), contains('laptop'));
    });

    test('searchProducts returns empty list for no matches', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts') {
          return http.Response(
            json.encode([
              {'id': 1, 'title': 'Laptop Pro', 'body': 'Professional laptop', 'userId': 1},
            ]),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);
      final results = await dataSource.searchProducts('nonexistent');

      expect(results, isA<List<Product>>());
      expect(results.isEmpty, isTrue);
    });

    test('searchProducts is case insensitive', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts') {
          return http.Response(
            json.encode([
              {'id': 1, 'title': 'Laptop Pro', 'body': 'Professional laptop', 'userId': 1},
            ]),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);
      final results = await dataSource.searchProducts('LAPTOP');

      expect(results.isNotEmpty, isTrue);
      expect(results.first.name.toLowerCase(), contains('laptop'));
    });

    test('searchProducts searches in description too', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts') {
          return http.Response(
            json.encode([
              {'id': 1, 'title': 'Mouse', 'body': 'Wireless mouse device', 'userId': 1},
            ]),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      dataSource = ProductRemoteDataSource(mockClient);
      final results = await dataSource.searchProducts('wireless');

      expect(results.isNotEmpty, isTrue);
      expect(
        results.any((p) => p.description.toLowerCase().contains('wireless')),
        isTrue,
      );
    });
  });
}
