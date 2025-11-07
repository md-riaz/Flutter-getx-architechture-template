import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/state/ui_state.dart';
import '../../../../core/theme/tokens.dart';
import '../controllers/customer_controller.dart';
import '../widgets/customer_card.dart';
import 'customer_form_view.dart';

/// Customer list view
class CustomerListView extends GetView<CustomerController> {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search customers...',
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
          Idle() => const Center(child: Text('Ready to load customers')),
          Loading() => const Center(child: CircularProgressIndicator()),
          Empty() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline,
                      size: AppTokens.iconSizeXLarge * 2,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: AppTokens.spacing16),
                  Text('No customers found',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppTokens.spacing8),
                  Text('Add your first customer to get started',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppTokens.spacing24),
                  FilledButton.icon(
                    onPressed: () => _showAddCustomer(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Customer'),
                  ),
                ],
              ),
            ),
          Ready(data: final customers) => ListView.builder(
              itemCount: customers.length,
              padding: const EdgeInsets.only(
                top: AppTokens.spacing8,
                bottom: AppTokens.spacing64,
              ),
              itemBuilder: (context, index) {
                final customer = customers[index];
                return CustomerCard(
                  customer: customer,
                  onEdit: () => _showEditCustomer(customer.id),
                  onDelete: () => _confirmDelete(customer.id, customer.name),
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
                  Text('Error loading customers',
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
        onPressed: _showAddCustomer,
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
      ),
    );
  }

  void _showAddCustomer() {
    Get.to(() => const CustomerFormView());
  }

  void _showEditCustomer(String id) {
    Get.to(() => CustomerFormView(customerId: id));
  }

  void _confirmDelete(String id, String name) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Customer'),
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
