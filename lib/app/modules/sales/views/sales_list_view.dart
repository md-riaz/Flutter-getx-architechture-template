import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/state/ui_state.dart';
import '../../../core/theme/tokens.dart';
import '../controllers/sales_controller.dart';

/// Sales list view
class SalesListView extends GetView<SalesController> {
  const SalesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
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
                        label: 'Total Sales',
                        value: stats['total_sales']?.toString() ?? '0',
                      ),
                      _StatColumn(
                        label: 'Revenue',
                        value: '₹${NumberFormat('#,##0').format(stats['total_revenue'] ?? 0)}',
                      ),
                      _StatColumn(
                        label: 'Tax',
                        value: '₹${NumberFormat('#,##0').format(stats['total_tax'] ?? 0)}',
                      ),
                    ],
                  ),
                );
              }),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacing16),
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
          Idle() => const Center(child: Text('Ready to load sales')),
          Loading() => const Center(child: CircularProgressIndicator()),
          Empty() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.point_of_sale_outlined,
                      size: AppTokens.iconSizeXLarge * 2,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: AppTokens.spacing16),
                  Text('No sales found',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppTokens.spacing8),
                  Text('Sales will appear here after transactions',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          Ready(data: final sales) => ListView.builder(
              itemCount: sales.length,
              padding: const EdgeInsets.all(AppTokens.spacing16),
              itemBuilder: (context, index) {
                final sale = sales[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTokens.spacing12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.receipt,
                          color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    title: Text(sale.invoiceNo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('dd MMM yyyy, HH:mm').format(sale.date)),
                        Text('Taxable: ₹${NumberFormat('#,##0').format(sale.taxable)}'),
                        if (sale.cgst > 0 || sale.sgst > 0)
                          Text('CGST: ₹${NumberFormat('#,##0').format(sale.cgst)} + '
                              'SGST: ₹${NumberFormat('#,##0').format(sale.sgst)}'),
                        if (sale.igst > 0)
                          Text('IGST: ₹${NumberFormat('#,##0').format(sale.igst)}'),
                        Text('Total: ₹${NumberFormat('#,##0').format(sale.total)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                        Text('Payment: ${sale.payMode.toUpperCase()}'),
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
                  Text('Error loading sales',
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
        onPressed: () {
          Get.snackbar('Info', 'Sale creation feature coming soon',
              snackPosition: SnackPosition.BOTTOM);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Sale'),
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
