import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/state/ui_state.dart';
import '../../../core/theme/tokens.dart';
import '../controllers/purchases_controller.dart';
import 'purchase_create_view.dart';

/// Purchases list view
class PurchasesListView extends GetView<PurchasesController> {
  const PurchasesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Statistics
              Obx(() {
                final stats = controller.statistics.value;
                if (stats.isEmpty) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.all(AppTokens.spacing16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(
                        label: 'Total',
                        value: stats['total_purchases']?.toString() ?? '0',
                      ),
                      _StatColumn(
                        label: 'Amount',
                        value:
                            '₹${NumberFormat('#,##0').format(stats['total_amount'] ?? 0)}',
                      ),
                      _StatColumn(
                        label: 'Items',
                        value: stats['total_items']?.toString() ?? '0',
                      ),
                    ],
                  ),
                );
              }),

              // Search
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTokens.spacing16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by invoice number...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: controller.search,
                ),
              ),
              const SizedBox(height: AppTokens.spacing16),
            ],
          ),
        ),
      ),
      body: Obx(() {
        final state = controller.state.value;

        return switch (state) {
          Idle() => const Center(child: Text('Ready to load purchases')),
          Loading() => const Center(child: CircularProgressIndicator()),
          Empty() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: AppTokens.iconSizeXLarge * 2,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: AppTokens.spacing16),
                  Text('No purchases found',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppTokens.spacing8),
                  Text('Add your first purchase to get started',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppTokens.spacing24),
                  FilledButton.icon(
                    onPressed: () =>
                        Get.to(() => const PurchaseCreateView())?.then((_) {
                      controller.refresh();
                    }),
                    icon: const Icon(Icons.add),
                    label: const Text('New Purchase'),
                  ),
                ],
              ),
            ),
          Ready(data: final purchases) => ListView.builder(
              itemCount: purchases.length,
              padding: const EdgeInsets.all(AppTokens.spacing16),
              itemBuilder: (context, index) {
                final purchase = purchases[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTokens.spacing12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.receipt,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer),
                    ),
                    title: Text('Invoice: ${purchase.vendorInvoiceNo}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('dd MMM yyyy').format(purchase.date)),
                        Text(
                          'Total: ₹${NumberFormat('#,##0').format(purchase.total)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        if (purchase.notes != null &&
                            purchase.notes!.isNotEmpty)
                          Text(
                            purchase.notes!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    isThreeLine: true,
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
                  Text('Error loading purchases',
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
        onPressed: () => Get.to(() => const PurchaseCreateView())?.then((_) {
          controller.refresh();
        }),
        icon: const Icon(Icons.add),
        label: const Text('New Purchase'),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
