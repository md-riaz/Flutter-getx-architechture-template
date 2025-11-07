import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/tokens.dart';
import '../controllers/reports_controller.dart';

/// Reports view with tabs for different report types
class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports & Analytics'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Purchase', icon: Icon(Icons.shopping_cart)),
              Tab(text: 'Sales', icon: Icon(Icons.point_of_sale)),
              Tab(text: 'Stock', icon: Icon(Icons.inventory)),
              Tab(text: 'GST', icon: Icon(Icons.receipt_long)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ReportTab(
              title: 'Purchase Report',
              icon: Icons.shopping_cart_outlined,
              description: 'View all purchase transactions and vendor summaries',
            ),
            _ReportTab(
              title: 'Sales Report',
              icon: Icons.point_of_sale_outlined,
              description: 'View all sales transactions and customer analytics',
            ),
            _ReportTab(
              title: 'Stock Report',
              icon: Icons.inventory_outlined,
              description: 'Current inventory status and stock movement',
            ),
            _ReportTab(
              title: 'GST Report',
              icon: Icons.receipt_long_outlined,
              description: 'Tax calculations and GST filing reports',
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const _ReportTab({
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppTokens.iconSizeXLarge * 2,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: AppTokens.spacing24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTokens.spacing16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTokens.spacing32),
            FilledButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Coming Soon',
                  'Detailed $title will be available soon with Excel/PDF export',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.file_download),
              label: const Text('Export Report'),
            ),
          ],
        ),
      ),
    );
  }
}
