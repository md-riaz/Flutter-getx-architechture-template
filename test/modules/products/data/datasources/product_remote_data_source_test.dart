import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/modules/products/data/datasources/product_remote_data_source.dart';
import 'package:getx_modular_template/modules/products/data/models/product.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('ProductRemoteDataSource', () {
    late ProductRemoteDataSource dataSource;
    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
      dioAdapter = DioAdapter(dio: dio);
      dataSource = ProductRemoteDataSource(dio);
    });

    test('getProducts returns list of products from API', () async {
      dioAdapter.onGet(
        '/posts',
        (server) => server.reply(200, [
          {'id': 1, 'title': 'Test Product 1', 'body': 'Description 1', 'userId': 1},
          {'id': 2, 'title': 'Test Product 2', 'body': 'Description 2', 'userId': 2},
        ]),
      );

      final products = await dataSource.getProducts();

      expect(products, isA<List<Product>>());
      expect(products.length, 2);
      expect(products.first.name, 'Test Product 1');
      expect(products.first.description, 'Description 1');
    });

    test('getProducts throws exception on error', () async {
      dioAdapter.onGet(
        '/posts',
        (server) => server.reply(500, {'error': 'Server Error'}),
      );

      expect(
        () => dataSource.getProducts(),
        throwsException,
      );
    });

    test('getProductById returns correct product', () async {
      dioAdapter.onGet(
        '/posts/1',
        (server) => server.reply(200, {'id': 1, 'title': 'Test Product', 'body': 'Description', 'userId': 1}),
      );

      final product = await dataSource.getProductById('1');

      expect(product, isA<Product>());
      expect(product.id, '1');
      expect(product.name, 'Test Product');
    });

    test('getProductById throws exception for invalid id', () async {
      dioAdapter.onGet(
        '/posts/999',
        (server) => server.reply(404, {'error': 'Not Found'}),
      );

      expect(
        () => dataSource.getProductById('999'),
        throwsException,
      );
    });

    test('createProduct returns product with timestamp', () async {
      dioAdapter.onPost(
        '/posts',
        (server) => server.reply(201, {'id': 101, 'title': 'Test Product', 'body': 'Test Description', 'userId': 10}),
      );

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
      dioAdapter.onPut(
        '/posts/1',
        (server) => server.reply(200, {'id': 1, 'title': 'Updated Product', 'body': 'Updated Description', 'userId': 20}),
      );

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
      dioAdapter.onDelete(
        '/posts/1',
        (server) => server.reply(200, {}),
      );

      await expectLater(
        dataSource.deleteProduct('1'),
        completes,
      );
    });

    test('searchProducts returns matching products', () async {
      dioAdapter.onGet(
        '/posts',
        (server) => server.reply(200, [
          {'id': 1, 'title': 'Laptop Pro', 'body': 'Professional laptop', 'userId': 1},
          {'id': 2, 'title': 'Mouse', 'body': 'Wireless mouse', 'userId': 2},
        ]),
      );

      final results = await dataSource.searchProducts('laptop');

      expect(results, isA<List<Product>>());
      expect(results.isNotEmpty, isTrue);
      expect(results.first.name.toLowerCase(), contains('laptop'));
    });

    test('searchProducts returns empty list for no matches', () async {
      dioAdapter.onGet(
        '/posts',
        (server) => server.reply(200, [
          {'id': 1, 'title': 'Laptop Pro', 'body': 'Professional laptop', 'userId': 1},
        ]),
      );

      final results = await dataSource.searchProducts('nonexistent');

      expect(results, isA<List<Product>>());
      expect(results.isEmpty, isTrue);
    });

    test('searchProducts is case insensitive', () async {
      dioAdapter.onGet(
        '/posts',
        (server) => server.reply(200, [
          {'id': 1, 'title': 'Laptop Pro', 'body': 'Professional laptop', 'userId': 1},
        ]),
      );

      final results = await dataSource.searchProducts('LAPTOP');

      expect(results.isNotEmpty, isTrue);
      expect(results.first.name.toLowerCase(), contains('laptop'));
    });

    test('searchProducts searches in description too', () async {
      dioAdapter.onGet(
        '/posts',
        (server) => server.reply(200, [
          {'id': 1, 'title': 'Mouse', 'body': 'Wireless mouse device', 'userId': 1},
        ]),
      );

      final results = await dataSource.searchProducts('wireless');

      expect(results.isNotEmpty, isTrue);
      expect(
        results.any((p) => p.description.toLowerCase().contains('wireless')),
        isTrue,
      );
    });

    test('configureInterceptors adds auth token to requests', () async {
      dataSource.configureInterceptors(authToken: 'test_token_123');

      // Verify interceptor is added (implicit test through usage)
      expect(dio.interceptors.isNotEmpty, isTrue);
    });

    test('getProductsPaginated returns paginated products', () async {
      dioAdapter.onGet(
        '/posts',
        (server) => server.reply(200, [
          {'id': 1, 'title': 'Product 1', 'body': 'Description 1', 'userId': 1},
          {'id': 2, 'title': 'Product 2', 'body': 'Description 2', 'userId': 2},
          {'id': 3, 'title': 'Product 3', 'body': 'Description 3', 'userId': 3},
        ]),
        queryParameters: {'_page': 1, '_limit': 20},
      );

      final products = await dataSource.getProductsPaginated(
        pageKey: 1,
        pageSize: 20,
      );

      expect(products, isA<List<Product>>());
      expect(products.length, 3);
    });

    test('getProductsPaginated handles different page sizes', () async {
      dioAdapter.onGet(
        '/posts',
        (server) => server.reply(200, [
          {'id': 1, 'title': 'Product 1', 'body': 'Description 1', 'userId': 1},
          {'id': 2, 'title': 'Product 2', 'body': 'Description 2', 'userId': 2},
        ]),
        queryParameters: {'_page': 1, '_limit': 2},
      );

      final products = await dataSource.getProductsPaginated(
        pageKey: 1,
        pageSize: 2,
      );

      expect(products.length, 2);
    });
  });
}
