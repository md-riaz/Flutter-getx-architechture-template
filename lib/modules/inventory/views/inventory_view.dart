import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inventory_controller.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/responsive_builder.dart';
import '../../../core/config/navigation_config.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Inventory',
      navigationItems: NavigationConfig.mainNavigationItems,
      appBar: CustomAppBar(
        title: 'Inventory',
        centerTitle: false,
        extraActions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Item',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add item functionality coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter functionality coming soon!')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: ResponsiveBuilder.isMobile(context)
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add item functionality coming soon!')),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No inventory items',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ResponsiveBuilder(
          builder: (context, deviceType) {
            if (deviceType == DeviceType.mobile) {
              return _buildMobileList(context);
            } else {
              return _buildDesktopGrid(context);
            }
          },
        );
      }),
    );
  }

  Widget _buildMobileList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: controller.items.length,
      itemBuilder: (_, i) {
        final item = controller.items[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(item.name[0]),
            ),
            title: Text(item.name),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // More options
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive(mobile: 1, tablet: 2, desktop: 3),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: controller.items.length,
      itemBuilder: (_, i) {
        final item = controller.items[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  child: Text(
                    item.name[0],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Quantity: ${item.quantity}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // More options
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
