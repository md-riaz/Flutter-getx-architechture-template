import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../controllers/products_controller.dart';
import '../data/models/product.dart';

/// Products view with infinite scroll pagination
/// 
/// This view demonstrates the use of PagedListView from infinite_scroll_pagination
/// package for efficient list scrolling with automatic loading of more items.
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
            tooltip: 'Refresh list',
          ),
          // Cache info button
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showCacheInfo,
            tooltip: 'Cache info',
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
          
          // Infinite scroll paginated list
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refresh,
              child: PagedListView<int, Product>(
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Product>(
                  itemBuilder: (context, product, index) => ProductListItem(
                    product: product,
                    onTap: () => _showProductDetails(product),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                    error: controller.pagingController.error,
                    onTryAgain: controller.pagingController.refresh,
                  ),
                  noItemsFoundIndicatorBuilder: (context) => const EmptyListIndicator(),
                  firstPageProgressIndicatorBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (context) => const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
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
            const Text('Note: Paginated lists always fetch from remote'),
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

  void _showProductDetails(Product product) {
    Get.dialog(
      AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${product.id}'),
            const SizedBox(height: 8),
            Text('Description: ${product.description}'),
            const SizedBox(height: 8),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Stock: ${product.stock}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    // Implementation for adding a new product
    Get.snackbar(
      'Add Product',
      'This would open a form to add a new product',
      snackPosition: SnackPosition.BOTTOM,
    );
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

/// Product list item widget
class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductListItem({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              color: product.stock > 10 ? Colors.green : Colors.orange,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// Error indicator widget
class ErrorIndicator extends StatelessWidget {
  final Object? error;
  final VoidCallback onTryAgain;

  const ErrorIndicator({
    Key? key,
    required this.error,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTryAgain,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

/// Empty list indicator widget
class EmptyListIndicator extends StatelessWidget {
  const EmptyListIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('No products found'),
        ],
      ),
    );
  }
}
