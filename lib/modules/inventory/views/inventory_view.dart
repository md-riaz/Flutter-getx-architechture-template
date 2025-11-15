import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const Center(child: Text('No inventory items'));
        }

        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (_, i) {
            final item = controller.items[i];
            return ListTile(
              title: Text(item.name),
              subtitle: Text('Quantity: ${item.quantity}'),
            );
          },
        );
      }),
    );
  }
}
