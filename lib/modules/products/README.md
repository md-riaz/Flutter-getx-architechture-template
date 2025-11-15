# Products Module - Repository Pattern Example

This module demonstrates the **Repository Pattern** with separate **Local** and **Remote Data Sources**, which is a common architecture pattern in Flutter applications.

## Architecture Overview

```
┌─────────────────┐
│   UI / Views    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Controllers    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────────┐
│          Product Repository                 │
│  (Orchestrates between data sources)        │
└─────────┬───────────────────────────────────┘
          │
    ┌─────┴─────┐
    │           │
    ▼           ▼
┌───────┐   ┌─────────┐
│ Local │   │ Remote  │
│ Data  │   │  Data   │
│Source │   │ Source  │
└───────┘   └─────────┘
    │           │
    ▼           ▼
┌───────┐   ┌─────────┐
│ Cache │   │   API   │
└───────┘   └─────────┘
```

## Components

### 1. Data Sources

#### ProductDataSource (Interface)
- Abstract interface defining the contract for data operations
- Both local and remote data sources implement this interface
- Ensures consistency across data source implementations

#### ProductRemoteDataSource
- Handles all API calls to the backend server
- Simulates network latency
- Returns fresh data from the server
- In a real app, this would use `http`, `dio`, or similar packages

**Example operations:**
- `getProducts()` - Fetch all products from API
- `getProductById(id)` - Fetch a single product
- `createProduct(product)` - Create new product on server
- `updateProduct(product)` - Update existing product
- `deleteProduct(id)` - Delete product from server
- `searchProducts(query)` - Search products on server

#### ProductLocalDataSource
- Handles local caching and persistence
- Uses in-memory cache for this example
- In a real app, you would use:
  - **SharedPreferences** - For simple key-value storage
  - **Hive** - For fast NoSQL database
  - **SQLite** - For relational database
  - **Isar** - For high-performance database

**Features:**
- Cache validation with expiry time (5 minutes)
- Fast local access (50ms vs 800ms remote)
- Same interface as remote data source
- Cache management methods

### 2. Repository

#### ProductRepository
The repository is the **single source of truth** for the rest of the application. It provides:

- **Smart Caching Strategy**: Automatically decides whether to use cache or fetch from remote
- **Unified API**: Controllers only interact with the repository, not individual data sources
- **Cache Invalidation**: Handles cache expiry and refresh logic
- **Error Recovery**: Falls back to remote if cache fails

## Caching Strategy

### Reading Data (getProducts)

```dart
Future<List<Product>> getProducts({bool forceRefresh = false}) async {
  // 1. Force refresh: Always fetch from remote
  if (forceRefresh) {
    return _fetchFromRemoteAndCache();
  }

  // 2. Valid cache: Return from cache (fast!)
  if (_localDataSource.isCacheValid()) {
    return await _localDataSource.getProducts();
  }

  // 3. Invalid/No cache: Fetch from remote and cache
  return _fetchFromRemoteAndCache();
}
```

### Writing Data (createProduct, updateProduct, deleteProduct)

```dart
// Always write to remote first, then update cache
Future<Product> createProduct(Product product) async {
  // 1. Create on remote (source of truth)
  final createdProduct = await _remoteDataSource.createProduct(product);

  // 2. Update local cache
  await _localDataSource.cacheProduct(createdProduct);

  return createdProduct;
}
```

## Usage Examples

### Basic Usage

```dart
// Create repository with both data sources
final repository = ProductRepository(
  ProductRemoteDataSource(apiClient),
  ProductLocalDataSource(),
);

// Fetch products (uses cache if valid)
final products = await repository.getProducts();

// Force refresh from remote
final freshProducts = await repository.getProducts(forceRefresh: true);

// Get single product
final product = await repository.getProductById('1');

// Create new product
final newProduct = Product(
  id: '6',
  name: 'New Product',
  description: 'Description',
  price: 99.99,
  stock: 10,
);
final created = await repository.createProduct(newProduct);

// Update product
final updated = created.copyWith(price: 149.99);
await repository.updateProduct(updated);

// Delete product
await repository.deleteProduct('1');

// Search products
final results = await repository.searchProducts('laptop');
```

### With GetX Controller

```dart
class ProductsController extends GetxController {
  final ProductRepository repository;
  
  final products = <Product>[].obs;
  final isLoading = false.obs;
  
  ProductsController(this.repository);
  
  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }
  
  Future<void> loadProducts({bool forceRefresh = false}) async {
    isLoading.value = true;
    try {
      products.value = await repository.getProducts(
        forceRefresh: forceRefresh,
      );
    } catch (e) {
      // Handle error
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refresh() async {
    await loadProducts(forceRefresh: true);
  }
}
```

## Benefits of This Pattern

### 1. Separation of Concerns
- UI logic (Views/Controllers) separated from data logic (Repository/Data Sources)
- Remote and local data handling are independent
- Easy to modify one without affecting others

### 2. Testability
- Each component can be tested independently
- Mock data sources for testing repository
- Mock repository for testing controllers
- See the test files in `test/modules/products/`

### 3. Performance
- Local cache provides instant responses (50ms)
- Reduces network calls and server load
- Better user experience with faster loading

### 4. Offline Support
- Can return cached data when offline
- Queue writes for when connection returns
- Graceful degradation of functionality

### 5. Flexibility
- Easy to switch storage mechanisms (Hive, SQLite, etc.)
- Easy to change API implementation
- Can add multiple remote sources (e.g., backup servers)

### 6. Maintainability
- Clear, single responsibility for each class
- Easy to understand data flow
- Simple to add new features

## Cache Management

### Cache Expiry
- Default: 5 minutes (`ProductLocalDataSource.cacheExpiry`)
- Automatically invalidates old cache
- Can be configured per use case

### Manual Cache Control

```dart
// Check if cache is valid
if (repository.isCacheValid()) {
  print('Cache is fresh!');
}

// Get cache timestamp
final timestamp = repository.getCacheTimestamp();
print('Cache updated at: $timestamp');

// Clear cache (e.g., on logout)
await repository.clearCache();
```

## Integration with GetX

### Bindings

```dart
class ProductsBindings extends Bindings {
  @override
  void dependencies() {
    // Register data sources
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSource(Get.find<ApiClient>()),
    );
    
    Get.lazyPut<ProductLocalDataSource>(
      () => ProductLocalDataSource(),
    );
    
    // Register repository
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(
        Get.find<ProductRemoteDataSource>(),
        Get.find<ProductLocalDataSource>(),
      ),
    );
    
    // Register controller
    Get.lazyPut<ProductsController>(
      () => ProductsController(Get.find<ProductRepository>()),
    );
  }
}
```

## Testing

Comprehensive tests are provided for all components:

- `test/modules/products/data/datasources/product_remote_data_source_test.dart`
- `test/modules/products/data/datasources/product_local_data_source_test.dart`
- `test/modules/products/data/repositories/product_repository_test.dart`

Run tests with:
```bash
flutter test test/modules/products/
```

## Extending This Pattern

### Add Real API Integration

Replace mock implementation in `ProductRemoteDataSource`:

```dart
@override
Future<List<Product>> getProducts() async {
  final response = await _apiClient.get('/products');
  return (response['data'] as List)
      .map((json) => Product.fromJson(json))
      .toList();
}
```

### Add Persistent Storage

Replace in-memory cache in `ProductLocalDataSource`:

```dart
// Using Hive
class ProductLocalDataSource implements ProductDataSource {
  final Box<Product> _box;
  
  ProductLocalDataSource(this._box);
  
  @override
  Future<List<Product>> getProducts() async {
    return _box.values.toList();
  }
  
  // ... other methods
}
```

### Add Pagination

```dart
Future<List<Product>> getProducts({
  int page = 1,
  int pageSize = 20,
  bool forceRefresh = false,
}) async {
  // Implementation with pagination support
}
```

### Add Filtering

```dart
Future<List<Product>> getProducts({
  double? minPrice,
  double? maxPrice,
  bool? inStock,
  bool forceRefresh = false,
}) async {
  // Implementation with filter support
}
```

## Best Practices

1. **Always validate cache** before using it
2. **Handle errors gracefully** with fallbacks
3. **Update cache** after successful remote operations
4. **Clear cache** on logout or data corruption
5. **Use timestamps** to track cache freshness
6. **Implement retry logic** for failed network calls
7. **Add loading states** for better UX
8. **Log data source usage** for debugging

## Real-World Considerations

### Security
- Never cache sensitive data (passwords, tokens) in plain text
- Use Flutter Secure Storage for sensitive information
- Encrypt cache data if needed

### Storage
- Monitor cache size
- Implement cache size limits
- Clean up old/unused cache regularly

### Network
- Handle different network states (online/offline)
- Implement request queuing for offline writes
- Use exponential backoff for retries

### Performance
- Use pagination for large datasets
- Implement lazy loading
- Cache only necessary data
- Consider compression for large objects

## Summary

This products module demonstrates a production-ready repository pattern with:
- ✅ Clean separation of concerns
- ✅ Smart caching strategy
- ✅ Comprehensive error handling
- ✅ Full test coverage
- ✅ Easy to extend and maintain
- ✅ Follows Flutter best practices
- ✅ Ready for real API integration

Use this as a template for implementing similar patterns in your features!
