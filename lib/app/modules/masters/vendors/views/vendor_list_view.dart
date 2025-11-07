import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/state/ui_state.dart';
import '../../../../core/theme/tokens.dart';
import '../controllers/vendor_controller.dart';
import '../widgets/vendor_card.dart';
import 'vendor_form_view.dart';

/// Vendor list view
/// Displays searchable list of vendors
class VendorListView extends GetView<VendorController> {
  const VendorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendors'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search vendors...',
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
          Idle() => const Center(
              child: Text('Ready to load vendors'),
            ),
          Loading() => const Center(
              child: CircularProgressIndicator(),
            ),
          Empty() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: AppTokens.iconSizeXLarge * 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: AppTokens.spacing16),
                  Text(
                    'No vendors found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTokens.spacing8),
                  Text(
                    'Add your first vendor to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTokens.spacing24),
                  FilledButton.icon(
                    onPressed: () => _showAddVendor(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Vendor'),
                  ),
                ],
              ),
            ),
          Ready(data: final vendors) => ListView.builder(
              itemCount: vendors.length,
              padding: const EdgeInsets.only(
                top: AppTokens.spacing8,
                bottom: AppTokens.spacing64,
              ),
              itemBuilder: (context, index) {
                final vendor = vendors[index];
                return VendorCard(
                  vendor: vendor,
                  onEdit: () => _showEditVendor(vendor.id),
                  onDelete: () => _confirmDelete(vendor.id, vendor.name),
                );
              },
            ),
          ErrorState(message: final msg) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: AppTokens.iconSizeXLarge * 2,
                    color: Colors.red,
                  ),
                  const SizedBox(height: AppTokens.spacing16),
                  Text(
                    'Error loading vendors',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTokens.spacing8),
                  Text(
                    msg,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
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
        onPressed: _showAddVendor,
        icon: const Icon(Icons.add),
        label: const Text('Add Vendor'),
      ),
    );
  }

  void _showAddVendor() {
    Get.to(() => const VendorFormView());
  }

  void _showEditVendor(String id) {
    Get.to(() => VendorFormView(vendorId: id));
  }

  void _confirmDelete(String id, String name) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Vendor'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
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
