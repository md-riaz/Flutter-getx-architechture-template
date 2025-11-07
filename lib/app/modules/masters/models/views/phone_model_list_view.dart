import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/state/ui_state.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../data/models/brand.dart';
import '../../../masters/brands/controllers/brand_controller.dart';
import '../controllers/phone_model_controller.dart';
import 'phone_model_form_view.dart';

/// Phone model list view
class PhoneModelListView extends GetView<PhoneModelController> {
  const PhoneModelListView({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.find<BrandController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Models'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacing16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search models...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: controller.search,
                ),
              ),
              const SizedBox(height: AppTokens.spacing8),
              Obx(() {
                final brandState = brandController.state.value;
                if (brandState is Ready<List<Brand>>) {
                  return SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacing16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: AppTokens.spacing8),
                          child: Obx(() => FilterChip(
                                label: const Text('All'),
                                selected: controller.selectedBrandId.value == null,
                                onSelected: (selected) {
                                  controller.filterByBrand(null);
                                },
                              )),
                        ),
                        ...brandState.data.map((brand) => Padding(
                              padding: const EdgeInsets.only(right: AppTokens.spacing8),
                              child: Obx(() => FilterChip(
                                    label: Text(brand.name),
                                    selected: controller.selectedBrandId.value == brand.id,
                                    onSelected: (selected) {
                                      controller.filterByBrand(selected ? brand.id : null);
                                    },
                                  )),
                            )),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
      body: Obx(() {
        final state = controller.state.value;

        return switch (state) {
          Idle() => const Center(child: Text('Ready to load models')),
          Loading() => const Center(child: CircularProgressIndicator()),
          Empty() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android_outlined,
                      size: AppTokens.iconSizeXLarge * 2,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: AppTokens.spacing16),
                  Text('No models found',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppTokens.spacing8),
                  Text('Add your first phone model to get started',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppTokens.spacing24),
                  FilledButton.icon(
                    onPressed: () => Get.to(() => const PhoneModelFormView()),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Model'),
                  ),
                ],
              ),
            ),
          Ready(data: final models) => ListView.builder(
              itemCount: models.length,
              padding: const EdgeInsets.all(AppTokens.spacing16),
              itemBuilder: (context, index) {
                final model = models[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTokens.spacing12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.phone_android,
                          color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    title: Text(model.name),
                    subtitle: Text('Brand ID: ${model.brandId}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.to(() => PhoneModelFormView(modelId: model.id));
                        } else if (value == 'delete') {
                          _confirmDelete(model.id, model.name);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: AppTokens.spacing8),
                              Text('Edit'),
                            ],
                          ),
                        ),
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
                  Text('Error loading models',
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
        onPressed: () => Get.to(() => const PhoneModelFormView()),
        icon: const Icon(Icons.add),
        label: const Text('Add Model'),
      ),
    );
  }

  void _confirmDelete(String id, String name) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Model'),
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
