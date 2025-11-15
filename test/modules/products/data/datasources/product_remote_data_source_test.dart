import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/services/api_client.dart';
import 'package:getx_modular_template/modules/products/data/datasources/product_remote_data_source.dart';
import 'package:getx_modular_template/modules/products/data/models/product.dart';

void main() {
  group('ProductRemoteDataSource', () {
    late ProductRemoteDataSource dataSource;
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient();
      dataSource = ProductRemoteDataSource(apiClient);
    });

    test('getProducts returns list of products', () async {
      final products = await dataSource.getProducts();

      expect(products, isA<List<Product>>());
      expect(products.isNotEmpty, isTrue);
      expect(products.length, 5);
      expect(products.first.name, 'Laptop Pro 15');
    });

    test('getProductById returns correct product', () async {
      final product = await dataSource.getProductById('1');

      expect(product, isA<Product>());
      expect(product.id, '1');
      expect(product.name, 'Laptop Pro 15');
    });

    test('getProductById throws exception for invalid id', () async {
      expect(
        () => dataSource.getProductById('999'),
        throwsException,
      );
    });

    test('createProduct returns product with timestamp', () async {
      final newProduct = Product(
        id: '6',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        stock: 10,
      );

      final createdProduct = await dataSource.createProduct(newProduct);

      expect(createdProduct.id, '6');
      expect(createdProduct.name, 'Test Product');
      expect(createdProduct.lastUpdated, isNotNull);
    });

    test('updateProduct returns updated product with new timestamp', () async {
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
      await expectLater(
        dataSource.deleteProduct('1'),
        completes,
      );
    });

    test('searchProducts returns matching products', () async {
      final results = await dataSource.searchProducts('laptop');

      expect(results, isA<List<Product>>());
      expect(results.isNotEmpty, isTrue);
      expect(results.first.name.toLowerCase(), contains('laptop'));
    });

    test('searchProducts returns empty list for no matches', () async {
      final results = await dataSource.searchProducts('nonexistent');

      expect(results, isA<List<Product>>());
      expect(results.isEmpty, isTrue);
    });

    test('searchProducts is case insensitive', () async {
      final results = await dataSource.searchProducts('LAPTOP');

      expect(results.isNotEmpty, isTrue);
      expect(results.first.name.toLowerCase(), contains('laptop'));
    });

    test('searchProducts searches in description too', () async {
      final results = await dataSource.searchProducts('wireless');

      expect(results.isNotEmpty, isTrue);
      expect(
        results.any((p) => p.description.toLowerCase().contains('wireless')),
        isTrue,
      );
    });
  });
}
