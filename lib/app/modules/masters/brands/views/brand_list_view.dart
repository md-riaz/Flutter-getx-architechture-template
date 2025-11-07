import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/state/ui_state.dart';
import '../../../../core/theme/tokens.dart';
import '../controllers/brand_controller.dart';
import 'brand_form_view.dart';

/// Brand list view
class BrandListView extends GetView<BrandController> {
  const BrandListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brands'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search brands...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: controller.search,
            ),
          ),
        ),
      ),
      body: Obx(() {
        final state = controller.state.value;

        return switch (state) {
          Idle() => const Center(child: Text('Ready to load brands')),
          Loading() => const Center(child: CircularProgressIndicator()),
          Empty() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.branding_watermark_outlined,
                      size: AppTokens.iconSizeXLarge * 2,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: AppTokens.spacing16),
                  Text('No brands found',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppTokens.spacing8),
                  Text('Add your first brand to get started',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppTokens.spacing24),
                  FilledButton.icon(
                    onPressed: () => Get.to(() => const BrandFormView()),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Brand'),
                  ),
                ],
              ),
            ),
          Ready(data: final brands) => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: AppTokens.spacing12,
                mainAxisSpacing: AppTokens.spacing12,
              ),
              padding: const EdgeInsets.all(AppTokens.spacing16),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Card(
                  child: InkWell(
                    onTap: () => Get.to(() => BrandFormView(brandId: brand.id)),
                    borderRadius: BorderRadius.circular(AppTokens.radius16),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.branding_watermark,
                                  size: AppTokens.iconSizeLarge,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(height: AppTokens.spacing8),
                              Text(brand.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                _confirmDelete(brand.id, brand.name);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: AppTokens.spacing8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ErrorState(message: final msg) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: AppTokens.iconSizeXLarge * 2, color: Colors.red),
                  const SizedBox(height: AppTokens.spacing16),
                  Text('Error loading brands',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppTokens.spacing8),
                  Text(msg,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppTokens.spacing24),
                  FilledButton.icon(
                    onPressed: controller.fetch,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
        };
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const BrandFormView()),
        icon: const Icon(Icons.add),
        label: const Text('Add Brand'),
      ),
    );
  }

  void _confirmDelete(String id, String name) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Brand'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.delete(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
