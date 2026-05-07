# Integration Example - Products Module

This document shows how to integrate the products module with controllers, bindings, and views in a GetX application.

## Step 1: Create Bindings

Create `lib/modules/products/bindings/products_bindings.dart`:

```dart
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../controllers/products_controller.dart';
import '../data/datasources/product_local_data_source.dart';
import '../data/datasources/product_remote_data_source.dart';
import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';

class ProductsBindings extends Bindings {
  @override
  void dependencies() async {
    // Register Hive adapter (if not already registered in main.dart)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
    
    // Initialize and register local data source
    final localDataSource = ProductLocalDataSource();
    await localDataSource.init();
    Get.put<ProductLocalDataSource>(
      localDataSource,
      tag: 'session', // Session-level, will be disposed on logout
    );
    
    // Register remote data source (uses Dio with JSONPlaceholder API)
    final remoteDataSource = ProductRemoteDataSource();
    
    // Configure auth interceptor (if user is logged in)
    final authToken = Get.find<AuthService>().token; // Get token from auth service
    if (authToken != null) {
      remoteDataSource.configureInterceptors(
        authToken: authToken,
        enableLogging: true, // Enable for development
      );
    }
    
    Get.put<ProductRemoteDataSource>(
      remoteDataSource,
      tag: 'session',
    );
    
    // Register repository
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(
        Get.find<ProductRemoteDataSource>(),
        Get.find<ProductLocalDataSource>(),
      ),
      tag: 'session',
    );
    
    // Register controller
    Get.lazyPut<ProductsController>(
      () => ProductsController(Get.find<ProductRepository>()),
    );
  }
}
```

**Note:** Make sure to initialize Hive in your `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  
  runApp(MyApp());
}
```

## Step 2: Create Controller

Create `lib/modules/products/controllers/products_controller.dart`:

```dart
import 'package:get/get.dart';
import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';

class ProductsController extends GetxController {
  final ProductRepository repository;

  ProductsController(this.repository);

  // Observable state
  final products = <Product>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedProduct = Rx<Product?>(null);

  // Cache info
  final cacheTimestamp = Rx<DateTime?>(null);
  final isCacheValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    updateCacheInfo();
  }

  /// Load products from repository (uses cache if valid)
  Future<void> loadProducts({bool forceRefresh = false}) async {
    isLoading.value = true;
    try {
      products.value = await repository.getProducts(
        forceRefresh: forceRefresh,
      );
      updateCacheInfo();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Force refresh from remote
  Future<void> refresh() async {
    await loadProducts(forceRefresh: true);
    Get.snackbar(
      'Success',
      'Products refreshed from server',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Load a single product
  Future<void> loadProduct(String id, {bool forceRefresh = false}) async {
    try {
      selectedProduct.value = await repository.getProductById(
        id,
        forceRefresh: forceRefresh,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Search products
  Future<void> searchProducts(String query) async {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      await loadProducts();
      return;
    }

    isLoading.value = true;
    try {
      products.value = await repository.searchProducts(query);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Search failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new product
  Future<void> createProduct(Product product) async {
    try {
      final created = await repository.createProduct(product);
      products.add(created);
      updateCacheInfo();
      
      Get.snackbar(
        'Success',
        'Product created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Update a product
  Future<void> updateProduct(Product product) async {
    try {
      final updated = await repository.updateProduct(product);
      
      // Update in list
      final index = products.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        products[index] = updated;
      }
      
      updateCacheInfo();
      
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      await repository.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      updateCacheInfo();
      
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Clear local cache
  Future<void> clearCache() async {
    try {
      await repository.clearCache();
      updateCacheInfo();
      
      Get.snackbar(
        'Success',
        'Cache cleared',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cache: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Update cache info
  void updateCacheInfo() {
    isCacheValid.value = repository.isCacheValid();
    cacheTimestamp.value = repository.getCacheTimestamp();
  }
}
```

## Step 3: Create View

Create `lib/modules/products/views/products_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
            tooltip: 'Refresh from server',
          ),
          // Cache info button
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showCacheInfo,
            tooltip: 'Cache info',
          ),
          // Clear cache button
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: controller.clearCache,
            tooltip: 'Clear cache',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: controller.searchProducts,
            ),
          ),
          
          // Cache status
          Obx(() {
            if (controller.isCacheValid.value) {
              final timestamp = controller.cacheTimestamp.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.green.shade50,
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Using cached data (updated ${_formatTime(timestamp)})',
                      style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          
          // Products list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.products.isEmpty) {
                return const Center(
                  child: Text('No products found'),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView.builder(
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(product.name[0]),
                      ),
                      title: Text(product.name),
                      subtitle: Text(product.description),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Stock: ${product.stock}',
                            style: TextStyle(
                              color: product.stock > 10 
                                  ? Colors.green 
                                  : Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showProductDetails(product),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add product',
      ),
    );
  }

  void _showCacheInfo() {
    Get.dialog(
      AlertDialog(
        title: const Text('Cache Information'),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cache Valid: ${controller.isCacheValid.value ? "Yes" : "No"}'),
            const SizedBox(height: 8),
            Text('Last Updated: ${_formatTime(controller.cacheTimestamp.value)}'),
            const SizedBox(height: 8),
            Text('Products Cached: ${controller.products.length}'),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(product) {
    // Implementation for showing product details
  }

  void _showAddProductDialog() {
    // Implementation for adding a new product
  }

  String _formatTime(DateTime? time) {
    if (time == null) return 'Never';
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
```

## Step 4: Register Routes

Add to `lib/core/routes/app_routes.dart`:

```dart
class Routes {
  // ... existing routes
  static const products = '/products';
}
```

Add to `lib/core/routes/app_pages.dart`:

```dart
import '../../modules/products/bindings/products_bindings.dart';
import '../../modules/products/views/products_view.dart';

class AppPages {
  static final pages = [
    // ... existing pages
    GetPage(
      name: Routes.products,
      page: () => const ProductsView(),
      binding: ProductsBindings(),
    ),
  ];
}
```

## Step 5: Navigate to Products

From anywhere in your app:

```dart
// Navigate to products page
Get.toNamed(Routes.products);

// Or with Get.to
Get.to(() => const ProductsView(), binding: ProductsBindings());
```

## Key Points

### 1. Lifecycle Management
- Data sources and repository use `tag: 'session'` to be disposed on logout
- Controller is disposed automatically when route is left
- Cache persists until explicitly cleared or app restart

### 2. Error Handling
- All operations wrapped in try-catch
- User-friendly error messages via snackbars
- Graceful fallbacks when cache/network fails

### 3. Performance
- LazyPut ensures dependencies are created only when needed
- Cache provides instant loading for subsequent visits
- Pull-to-refresh for manual updates

### 4. User Experience
- Loading states for all async operations
- Cache status indicator
- Search with debouncing (can be added)
- Optimistic updates (can be added)

## Testing the Controller

Create `test/modules/products/controllers/products_controller_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_modular_template/core/services/api_client.dart';
import 'package:getx_modular_template/modules/products/controllers/products_controller.dart';
import 'package:getx_modular_template/modules/products/data/datasources/product_local_data_source.dart';
import 'package:getx_modular_template/modules/products/data/datasources/product_remote_data_source.dart';
import 'package:getx_modular_template/modules/products/data/repositories/product_repository.dart';

void main() {
  late ProductsController controller;
  late ProductRepository repository;

  setUp(() {
    final apiClient = ApiClient();
    final remoteDataSource = ProductRemoteDataSource(apiClient);
    final localDataSource = ProductLocalDataSource();
    repository = ProductRepository(remoteDataSource, localDataSource);
    
    Get.testMode = true;
    controller = ProductsController(repository);
  });

  tearDown(() async {
    await repository.clearCache();
    Get.reset();
  });

  test('loads products on init', () async {
    controller.onInit();
    await Future.delayed(const Duration(seconds: 1));
    
    expect(controller.products.isNotEmpty, true);
    expect(controller.isLoading.value, false);
  });

  test('refresh forces remote fetch', () async {
    await controller.loadProducts();
    final firstLoad = controller.products.length;
    
    await controller.refresh();
    final secondLoad = controller.products.length;
    
    expect(secondLoad, firstLoad);
  });

  test('search filters products', () async {
    await controller.loadProducts();
    
    await controller.searchProducts('laptop');
    
    expect(controller.products.length, lessThan(5));
    expect(
      controller.products.every((p) => 
        p.name.toLowerCase().contains('laptop') ||
        p.description.toLowerCase().contains('laptop')
      ),
      true,
    );
  });
}
```

## Advanced Features

### 1. Pagination

```dart
// In controller
final currentPage = 1.obs;
final hasMorePages = true.obs;

Future<void> loadMoreProducts() async {
  if (!hasMorePages.value || isLoading.value) return;
  
  isLoading.value = true;
  try {
    final newProducts = await repository.getProducts(
      page: currentPage.value + 1,
    );
    
    if (newProducts.isEmpty) {
      hasMorePages.value = false;
    } else {
      products.addAll(newProducts);
      currentPage.value++;
    }
  } catch (e) {
    // Handle error
  } finally {
    isLoading.value = false;
  }
}
```

### 2. Optimistic Updates

```dart
Future<void> updateProduct(Product product) async {
  // Update UI immediately
  final index = products.indexWhere((p) => p.id == product.id);
  final oldProduct = products[index];
  products[index] = product;
  
  try {
    // Update on server
    await repository.updateProduct(product);
  } catch (e) {
    // Revert on error
    products[index] = oldProduct;
    Get.snackbar('Error', 'Failed to update product');
  }
}
```

### 3. Search Debouncing

```dart
import 'dart:async';

Timer? _debounce;

void searchProducts(String query) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  
  _debounce = Timer(const Duration(milliseconds: 500), () async {
    // Perform search
  });
}
```

## Summary

This integration example shows:
- ✅ Complete bindings setup with lifecycle management
- ✅ Controller with all CRUD operations
- ✅ Reactive UI with Obx
- ✅ Error handling and user feedback
- ✅ Cache management and status display
- ✅ Search functionality
- ✅ Pull-to-refresh
- ✅ Unit tests for controller

Use this as a reference when implementing similar features in your app!
