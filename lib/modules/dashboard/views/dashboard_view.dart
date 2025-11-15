import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../inventory/views/widgets/inventory_summary_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modular Dashboard')),
      body: Obx(() {
        final features = controller.availableFeatures;

        if (features.isEmpty) {
          return const Center(child: Text('No available features'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final feature in features) _buildFeatureCard(feature),
          ],
        );
      }),
    );
  }

  Widget _buildFeatureCard(Feature feature) {
    switch (feature) {
      case Feature.inventory:
        return const InventorySummaryCard();
    }
  }
}
