import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/modules/products/data/datasources/product_local_data_source.dart';
import 'package:getx_modular_template/modules/products/data/models/product.dart';

void main() {
  group('ProductLocalDataSource', () {
    late ProductLocalDataSource dataSource;

    setUp(() {
      dataSource = ProductLocalDataSource();
    });

    tearDown(() async {
      await dataSource.clearCache();
    });

    test('initial cache is empty', () async {
      final products = await dataSource.getProducts();

      expect(products.isEmpty, isTrue);
      expect(dataSource.hasCache(), isFalse);
    });

    test('cacheProduct adds product to cache', () async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        stock: 10,
      );

      await dataSource.cacheProduct(product);

      final cached = await dataSource.getProductById('1');
      expect(cached.id, product.id);
      expect(cached.name, product.name);
    });

    test('cacheProducts adds multiple products to cache', () async {
      final products = [
        Product(
          id: '1',
          name: 'Product 1',
          description: 'Description 1',
          price: 99.99,
          stock: 10,
        ),
        Product(
          id: '2',
          name: 'Product 2',
          description: 'Description 2',
          price: 199.99,
          stock: 20,
        ),
      ];

      await dataSource.cacheProducts(products);

      final cachedProducts = await dataSource.getProducts();
      expect(cachedProducts.length, 2);
    });

    test('getProductById throws exception for non-existent product', () async {
      expect(
        () => dataSource.getProductById('999'),
        throwsException,
      );
    });

    test('updateProduct updates cached product', () async {
      final product = Product(
        id: '1',
        name: 'Original Name',
        description: 'Original Description',
        price: 99.99,
        stock: 10,
      );

      await dataSource.cacheProduct(product);

      final updatedProduct = product.copyWith(
        name: 'Updated Name',
        price: 149.99,
      );

      await dataSource.updateProduct(updatedProduct);

      final cached = await dataSource.getProductById('1');
      expect(cached.name, 'Updated Name');
      expect(cached.price, 149.99);
    });

    test('deleteProduct removes product from cache', () async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        stock: 10,
      );

      await dataSource.cacheProduct(product);
      await dataSource.deleteProduct('1');

      expect(
        () => dataSource.getProductById('1'),
        throwsException,
      );
    });

    test('searchProducts returns matching products', () async {
      final products = [
        Product(
          id: '1',
          name: 'Laptop Pro',
          description: 'Professional laptop',
          price: 999.99,
          stock: 10,
        ),
        Product(
          id: '2',
          name: 'Mouse',
          description: 'Wireless mouse',
          price: 29.99,
          stock: 50,
        ),
      ];

      await dataSource.cacheProducts(products);

      final results = await dataSource.searchProducts('laptop');
      expect(results.length, 1);
      expect(results.first.name, 'Laptop Pro');
    });

    test('searchProducts is case insensitive', () async {
      final product = Product(
        id: '1',
        name: 'Laptop Pro',
        description: 'Professional laptop',
        price: 999.99,
        stock: 10,
      );

      await dataSource.cacheProduct(product);

      final results = await dataSource.searchProducts('LAPTOP');
      expect(results.length, 1);
    });

    test('isCacheValid returns false for empty cache', () {
      expect(dataSource.isCacheValid(), isFalse);
    });

    test('isCacheValid returns true after caching', () async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        stock: 10,
      );

      await dataSource.cacheProduct(product);

      expect(dataSource.isCacheValid(), isTrue);
    });

    test('hasCache returns true after caching', () async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        stock: 10,
      );

      await dataSource.cacheProduct(product);

      expect(dataSource.hasCache(), isTrue);
    });

    test('clearCache removes all cached data', () async {
      final products = [
        Product(
          id: '1',
          name: 'Product 1',
          description: 'Description 1',
          price: 99.99,
          stock: 10,
        ),
        Product(
          id: '2',
          name: 'Product 2',
          description: 'Description 2',
          price: 199.99,
          stock: 20,
        ),
      ];

      await dataSource.cacheProducts(products);
      await dataSource.clearCache();

      final cachedProducts = await dataSource.getProducts();
      expect(cachedProducts.isEmpty, isTrue);
      expect(dataSource.hasCache(), isFalse);
    });

    test('getCacheTimestamp returns null initially', () {
      expect(dataSource.getCacheTimestamp(), isNull);
    });

    test('getCacheTimestamp returns timestamp after caching', () async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        stock: 10,
      );

      await dataSource.cacheProduct(product);

      expect(dataSource.getCacheTimestamp(), isNotNull);
    });

    test('cacheProducts clears existing cache', () async {
      final initialProducts = [
        Product(
          id: '1',
          name: 'Product 1',
          description: 'Description 1',
          price: 99.99,
          stock: 10,
        ),
      ];

      await dataSource.cacheProducts(initialProducts);

      final newProducts = [
        Product(
          id: '2',
          name: 'Product 2',
          description: 'Description 2',
          price: 199.99,
          stock: 20,
        ),
      ];

      await dataSource.cacheProducts(newProducts);

      final cached = await dataSource.getProducts();
      expect(cached.length, 1);
      expect(cached.first.id, '2');
    });
  });
}
