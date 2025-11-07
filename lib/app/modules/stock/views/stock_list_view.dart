import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/state/ui_state.dart';
import '../../../core/theme/tokens.dart';
import '../../../data/models/product_unit.dart';
import '../controllers/stock_controller.dart';

/// Stock list view
class StockListView extends GetView<StockController> {
  const StockListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Statistics
              Obx(() {
                final stats = controller.statistics.value;
                if (stats.isEmpty) return const SizedBox.shrink();
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacing16),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatChip(
                        label: 'Total',
                        value: stats['total'] ?? 0,
                        color: Colors.blue,
                      ),
                      _StatChip(
                        label: 'In Stock',
                        value: stats['in_stock'] ?? 0,
                        color: Colors.green,
                      ),
                      _StatChip(
                        label: 'Sold',
                        value: stats['sold'] ?? 0,
                        color: Colors.orange,
                      ),
                      _StatChip(
                        label: 'Returned',
                        value: stats['returned'] ?? 0,
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              }),
              
              // Search
              Padding(
                padding: const EdgeInsets.all(AppTokens.spacing16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by IMEI or color...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: controller.search,
                ),
              ),
              
              // Status filter
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacing16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: AppTokens.spacing8),
                      child: Obx(() => FilterChip(
                            label: const Text('All'),
                            selected: controller.selectedStatus.value == null,
                            onSelected: (selected) {
                              controller.filterByStatus(null);
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: AppTokens.spacing8),
                      child: Obx(() => FilterChip(
                            label: const Text('In Stock'),
                            selected: controller.selectedStatus.value == ProductStatus.inStock,
                            onSelected: (selected) {
                              controller.filterByStatus(
                                selected ? ProductStatus.inStock : null,
                              );
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: AppTokens.spacing8),
                      child: Obx(() => FilterChip(
                            label: const Text('Sold'),
                            selected: controller.selectedStatus.value == ProductStatus.sold,
                            onSelected: (selected) {
                              controller.filterByStatus(
                                selected ? ProductStatus.sold : null,
                              );
                            },
                          )),
                    ),
                    Obx(() => FilterChip(
                          label: const Text('Returned'),
                          selected: controller.selectedStatus.value == ProductStatus.returned,
                          onSelected: (selected) {
                            controller.filterByStatus(
                              selected ? ProductStatus.returned : null,
                            );
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        final state = controller.state.value;

        return switch (state) {
          Idle() => const Center(child: Text('Ready to load stock')),
          Loading() => const Center(child: CircularProgressIndicator()),
          Empty() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_outlined,
                      size: AppTokens.iconSizeXLarge * 2,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: AppTokens.spacing16),
                  Text('No stock items found',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppTokens.spacing8),
                  Text('Stock will appear here after purchases',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          Ready(data: final units) => ListView.builder(
              itemCount: units.length,
              padding: const EdgeInsets.all(AppTokens.spacing16),
              itemBuilder: (context, index) {
                final unit = units[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTokens.spacing12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(unit.status),
                      child: Icon(Icons.phone_android, color: Colors.white),
                    ),
                    title: Text('IMEI: ${unit.imei}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${unit.color ?? 'N/A'} • ${unit.ram ?? 'N/A'} • ${unit.rom ?? 'N/A'}'),
                        Text('Purchase: ₹${NumberFormat('#,##0').format(unit.purchasePrice)} • '
                            'Sell: ₹${NumberFormat('#,##0').format(unit.sellPrice)}'),
                        Text('Status: ${unit.status.value}',
                            style: TextStyle(
                              color: _getStatusColor(unit.status),
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    trailing: unit.status == ProductStatus.sold
                        ? PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'return') {
                                _confirmReturn(unit.id, unit.imei);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'return',
                                child: Row(
                                  children: [
                                    Icon(Icons.undo),
                                    SizedBox(width: AppTokens.spacing8),
                                    Text('Mark as Returned'),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : null,
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
                  Text('Error loading stock',
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
    );
  }

  Color _getStatusColor(ProductStatus status) {
    return switch (status) {
      ProductStatus.inStock => Colors.green,
      ProductStatus.sold => Colors.orange,
      ProductStatus.returned => Colors.red,
    };
  }

  void _confirmReturn(String id, String imei) {
    Get.dialog(
      AlertDialog(
        title: const Text('Mark as Returned'),
        content: Text('Mark unit with IMEI $imei as returned?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.markAsReturned(id);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
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
