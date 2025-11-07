import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
          actions: [
            IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () => _showDateRangePicker(context),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              _PurchaseReportTab(data: controller.purchaseData.value),
              _SalesReportTab(data: controller.salesData.value),
              _StockReportTab(data: controller.stockData.value),
              _GSTReportTab(data: controller.gstData.value),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: controller.startDate != null && controller.endDate != null
          ? DateTimeRange(
              start: controller.startDate!,
              end: controller.endDate!,
            )
          : null,
    );

    if (range != null) {
      await controller.setDateRange(range.start, range.end);
    }
  }
}

class _PurchaseReportTab extends StatelessWidget {
  final Map<String, dynamic> data;

  const _PurchaseReportTab({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppTokens.spacing16),
      children: [
        _StatCard(
          title: 'Total Purchases',
          value: data['total_purchases']?.toString() ?? '0',
          icon: Icons.shopping_cart,
          color: Colors.blue,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Total Amount',
          value: '₹${NumberFormat('#,##0.00').format(data['total_amount'] ?? 0)}',
          icon: Icons.currency_rupee,
          color: Colors.green,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Total Items',
          value: data['total_items']?.toString() ?? '0',
          icon: Icons.inventory,
          color: Colors.orange,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Average Purchase',
          value: '₹${NumberFormat('#,##0.00').format(data['avg_purchase'] ?? 0)}',
          icon: Icons.analytics,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _SalesReportTab extends StatelessWidget {
  final Map<String, dynamic> data;

  const _SalesReportTab({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppTokens.spacing16),
      children: [
        _StatCard(
          title: 'Total Sales',
          value: data['total_sales']?.toString() ?? '0',
          icon: Icons.point_of_sale,
          color: Colors.blue,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Total Revenue',
          value: '₹${NumberFormat('#,##0.00').format(data['total_revenue'] ?? 0)}',
          icon: Icons.currency_rupee,
          color: Colors.green,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Taxable Amount',
          value: '₹${NumberFormat('#,##0.00').format(data['taxable_amount'] ?? 0)}',
          icon: Icons.money,
          color: Colors.teal,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Total Tax',
          value: '₹${NumberFormat('#,##0.00').format(data['total_tax'] ?? 0)}',
          icon: Icons.receipt_long,
          color: Colors.red,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Average Sale',
          value: '₹${NumberFormat('#,##0.00').format(data['avg_sale'] ?? 0)}',
          icon: Icons.analytics,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StockReportTab extends StatelessWidget {
  final Map<String, dynamic> data;

  const _StockReportTab({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppTokens.spacing16),
      children: [
        _StatCard(
          title: 'Total Items',
          value: data['total_items']?.toString() ?? '0',
          icon: Icons.inventory,
          color: Colors.blue,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'In Stock',
          value: data['in_stock']?.toString() ?? '0',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Sold',
          value: data['sold']?.toString() ?? '0',
          icon: Icons.sell,
          color: Colors.orange,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Returned',
          value: data['returned']?.toString() ?? '0',
          icon: Icons.keyboard_return,
          color: Colors.red,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Stock Value',
          value: '₹${NumberFormat('#,##0.00').format(data['stock_value'] ?? 0)}',
          icon: Icons.currency_rupee,
          color: Colors.teal,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Potential Revenue',
          value: '₹${NumberFormat('#,##0.00').format(data['potential_revenue'] ?? 0)}',
          icon: Icons.trending_up,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _GSTReportTab extends StatelessWidget {
  final Map<String, dynamic> data;

  const _GSTReportTab({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppTokens.spacing16),
      children: [
        _StatCard(
          title: 'Total GST',
          value: '₹${NumberFormat('#,##0.00').format(data['total_gst'] ?? 0)}',
          icon: Icons.receipt_long,
          color: Colors.red,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Total CGST',
          value: '₹${NumberFormat('#,##0.00').format(data['total_cgst'] ?? 0)}',
          icon: Icons.payments,
          color: Colors.blue,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Total SGST',
          value: '₹${NumberFormat('#,##0.00').format(data['total_sgst'] ?? 0)}',
          icon: Icons.payments,
          color: Colors.green,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Total IGST',
          value: '₹${NumberFormat('#,##0.00').format(data['total_igst'] ?? 0)}',
          icon: Icons.payments,
          color: Colors.orange,
        ),
        const SizedBox(height: AppTokens.spacing12),
        _StatCard(
          title: 'Taxable Amount',
          value: '₹${NumberFormat('#,##0.00').format(data['taxable_amount'] ?? 0)}',
          icon: Icons.money,
          color: Colors.teal,
        ),
        const SizedBox(height: AppTokens.spacing12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTokens.spacing16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Intra-State Sales:',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(data['intra_state_count']?.toString() ?? '0',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Inter-State Sales:',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(data['inter_state_count']?.toString() ?? '0',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.spacing16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: AppTokens.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

