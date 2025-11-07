import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/tokens.dart';
import '../../masters/vendors/views/vendor_list_view.dart';
import '../../masters/brands/views/brand_list_view.dart';
import '../../masters/customers/views/customer_list_view.dart';
import '../../masters/models/views/phone_model_list_view.dart';
import '../../stock/views/stock_list_view.dart';

/// Dashboard view
/// Main entry point showing key features and navigation
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to user profile
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(AppTokens.spacing16),
        mainAxisSpacing: AppTokens.spacing16,
        crossAxisSpacing: AppTokens.spacing16,
        children: [
          _DashboardCard(
            title: 'Vendors',
            icon: Icons.business,
            color: Colors.blue,
            onTap: () => Get.to(() => const VendorListView()),
          ),
          _DashboardCard(
            title: 'Brands',
            icon: Icons.branding_watermark,
            color: Colors.orange,
            onTap: () => Get.to(() => const BrandListView()),
          ),
          _DashboardCard(
            title: 'Models',
            icon: Icons.phone_android,
            color: Colors.green,
            onTap: () => Get.to(() => const PhoneModelListView()),
          ),
          _DashboardCard(
            title: 'Customers',
            icon: Icons.people,
            color: Colors.purple,
            onTap: () => Get.to(() => const CustomerListView()),
          ),
          _DashboardCard(
            title: 'Purchases',
            icon: Icons.shopping_cart,
            color: Colors.teal,
            onTap: () {
              // TODO: Navigate to purchases
              Get.snackbar('Coming Soon', 'Purchases module will be available soon');
            },
          ),
          _DashboardCard(
            title: 'Stock',
            icon: Icons.inventory,
            color: Colors.indigo,
            onTap: () => Get.to(() => const StockListView()),
          ),
          _DashboardCard(
            title: 'Sales',
            icon: Icons.point_of_sale,
            color: Colors.red,
            onTap: () {
              // TODO: Navigate to sales
              Get.snackbar('Coming Soon', 'Sales module will be available soon');
            },
          ),
          _DashboardCard(
            title: 'Reports',
            icon: Icons.analytics,
            color: Colors.brown,
            onTap: () {
              // TODO: Navigate to reports
              Get.snackbar('Coming Soon', 'Reports module will be available soon');
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radius16),
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spacing16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTokens.spacing16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppTokens.iconSizeLarge * 1.5,
                  color: color,
                ),
              ),
              const SizedBox(height: AppTokens.spacing12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
