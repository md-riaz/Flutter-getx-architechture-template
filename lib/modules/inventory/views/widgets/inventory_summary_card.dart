import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/inventory_controller.dart';

class InventorySummaryCard extends GetView<InventoryController> {
  const InventorySummaryCard({super.key});

  static const String sessionTag = 'session';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>(tag: sessionTag);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final totalItems = controller.items.length;
          final lowStock =
              controller.items.where((e) => e.quantity < 10).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Inventory Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Total items: $totalItems'),
              Text('Low stock items: $lowStock'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed('/inventory'),
                  child: const Text('View Inventory'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
