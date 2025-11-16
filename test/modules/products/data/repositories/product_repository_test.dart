import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/modules/products/data/datasources/product_local_data_source.dart';
import 'package:getx_modular_template/modules/products/data/datasources/product_remote_data_source.dart';
import 'package:getx_modular_template/modules/products/data/models/product.dart';
import 'package:getx_modular_template/modules/products/data/repositories/product_repository.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('ProductRepository', () {
    late ProductRepository repository;
    late ProductRemoteDataSource remoteDataSource;
    late ProductLocalDataSource localDataSource;
    late http.Client mockClient;

    setUpAll(() async {
      // Initialize Hive for testing
      await Hive.initFlutter();
      Hive.registerAdapter(ProductAdapter());
    });

    setUp(() async {
      // Mock HTTP client for remote data source
      mockClient = MockClient((request) async {
        if (request.url.toString() == 'https://jsonplaceholder.typicode.com/posts') {
          return http.Response(
            json.encode([
              {'id': 1, 'title': 'Test Product 1', 'body': 'Description 1', 'userId': 1},
              {'id': 2, 'title': 'Test Product 2', 'body': 'Description 2', 'userId': 2},
            ]),
            200,
          );
        }
        if (request.url.toString().startsWith('https://jsonplaceholder.typicode.com/posts/')) {
          final id = request.url.pathSegments.last;
          return http.Response(
            json.encode({'id': int.parse(id), 'title': 'Test Product $id', 'body': 'Description $id', 'userId': 1}),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      remoteDataSource = ProductRemoteDataSource(mockClient);
      localDataSource = ProductLocalDataSource();
      await localDataSource.init();
      repository = ProductRepository(remoteDataSource, localDataSource);
    });

    tearDown(() async {
      await localDataSource.clearCache();
      await localDataSource.close();
    });

    group('getProducts', () {
      test('fetches from remote when cache is empty', () async {
        final products = await repository.getProducts();

        expect(products, isA<List<Product>>());
        expect(products.isNotEmpty, isTrue);
        expect(localDataSource.hasCache(), isTrue);
      });

      test('returns from cache when cache is valid', () async {
        // First call to populate cache
        await repository.getProducts();

        // Second call should use cache
        final products = await repository.getProducts();

        expect(products, isA<List<Product>>());
        expect(products.isNotEmpty, isTrue);
      });

      test('fetches from remote when forceRefresh is true', () async {
        // Populate cache
        await repository.getProducts();

        // Force refresh
        final products = await repository.getProducts(forceRefresh: true);

        expect(products, isA<List<Product>>());
        expect(products.isNotEmpty, isTrue);
      });

      test('updates cache after fetching from remote', () async {
        await repository.getProducts();

        expect(localDataSource.hasCache(), isTrue);
        expect(localDataSource.isCacheValid(), isTrue);
      });
    });

    group('getProductById', () {
      test('fetches from remote when not in cache', () async {
        final product = await repository.getProductById('1');

        expect(product, isA<Product>());
        expect(product.id, '1');
      });

      test('returns from cache when available', () async {
        // First call to cache the product
        await repository.getProductById('1');

        // Second call should use cache
        final product = await repository.getProductById('1');

        expect(product, isA<Product>());
        expect(product.id, '1');
      });

      test('fetches from remote when forceRefresh is true', () async {
        // Cache the product
        await repository.getProductById('1');

        // Force refresh
        final product = await repository.getProductById('1', forceRefresh: true);

        expect(product, isA<Product>());
        expect(product.id, '1');
      });

      test('throws exception for invalid id', () async {
        expect(
          () => repository.getProductById('999'),
          throwsException,
        );
      });
    });

    group('createProduct', () {
      test('creates product on remote and caches it', () async {
        final newProduct = Product(
          id: '6',
          name: 'New Product',
          description: 'New Description',
          price: 99.99,
          stock: 10,
        );

        final created = await repository.createProduct(newProduct);

        expect(created, isA<Product>());
        expect(created.id, '6');

        // Verify it's cached
        final cached = await localDataSource.getProductById('6');
        expect(cached.id, '6');
      });
    });

    group('updateProduct', () {
      test('updates product on remote and in cache', () async {
        // Create and cache a product
        final product = Product(
          id: '1',
          name: 'Original Name',
          description: 'Original Description',
          price: 99.99,
          stock: 10,
        );
        await localDataSource.cacheProduct(product);

        // Update it
        final updatedProduct = product.copyWith(
          name: 'Updated Name',
          price: 149.99,
        );

        final result = await repository.updateProduct(updatedProduct);

        expect(result.name, 'Updated Name');
        expect(result.price, 149.99);

        // Verify cache is updated
        final cached = await localDataSource.getProductById('1');
        expect(cached.name, 'Updated Name');
      });
    });

    group('deleteProduct', () {
      test('deletes product from remote and cache', () async {
        // Cache a product
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          stock: 10,
        );
        await localDataSource.cacheProduct(product);

        // Delete it
        await repository.deleteProduct('1');

        // Verify it's removed from cache
        expect(
          () => localDataSource.getProductById('1'),
          throwsException,
        );
      });
    });

    group('searchProducts', () {
      test('searches on remote when cache is invalid', () async {
        final results = await repository.searchProducts('laptop');

        expect(results, isA<List<Product>>());
        expect(results.isNotEmpty, isTrue);
      });

      test('searches in cache when cache is valid', () async {
        // Populate cache
        await repository.getProducts();

        // Search in cache
        final results = await repository.searchProducts('laptop');

        expect(results, isA<List<Product>>());
        expect(results.isNotEmpty, isTrue);
      });

      test('searches on remote when forceRemote is true', () async {
        // Populate cache
        await repository.getProducts();

        // Force remote search
        final results = await repository.searchProducts(
          'laptop',
          forceRemote: true,
        );

        expect(results, isA<List<Product>>());
        expect(results.isNotEmpty, isTrue);
      });
    });

    group('cache management', () {
      test('clearCache removes all cached data', () async {
        // Populate cache
        await repository.getProducts();
        expect(localDataSource.hasCache(), isTrue);

        // Clear cache
        await repository.clearCache();

        expect(localDataSource.hasCache(), isFalse);
      });

      test('isCacheValid returns false initially', () {
        expect(repository.isCacheValid(), isFalse);
      });

      test('isCacheValid returns true after caching', () async {
        await repository.getProducts();

        expect(repository.isCacheValid(), isTrue);
      });

      test('getCacheTimestamp returns null initially', () {
        expect(repository.getCacheTimestamp(), isNull);
      });

      test('getCacheTimestamp returns timestamp after caching', () async {
        await repository.getProducts();

        expect(repository.getCacheTimestamp(), isNotNull);
      });
    });
  });
}
