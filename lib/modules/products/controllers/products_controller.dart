import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';

/// Products controller with infinite scroll pagination support
/// 
/// This controller demonstrates the use of infinite_scroll_pagination package
/// with the repository pattern for efficient list scrolling.
class ProductsController extends GetxController {
  final ProductRepository repository;

  ProductsController(this.repository);

  // Pagination controller for infinite scrolling
  final PagingController<int, Product> pagingController = 
      PagingController(firstPageKey: 1);

  // Observable state
  final products = <Product>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedProduct = Rx<Product?>(null);

  // Cache info
  final cacheTimestamp = Rx<DateTime?>(null);
  final isCacheValid = false.obs;

  // Pagination settings
  static const int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    // Add listener for pagination
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    updateCacheInfo();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  /// Fetch a page of products for infinite scrolling
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await repository.getProductsPaginated(
        pageKey: pageKey,
        pageSize: pageSize,
      );

      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  /// Load products from repository (non-paginated, uses cache)
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

  /// Refresh the paginated list
  Future<void> refresh() async {
    pagingController.refresh();
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
