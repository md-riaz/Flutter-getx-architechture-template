import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../inventory/views/widgets/inventory_summary_card.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/responsive_builder.dart';
import '../../../core/config/navigation_config.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the session-tagged controller
    final controller = Get.find<DashboardController>(tag: 'session');
    
    return AppLayout(
      title: 'Dashboard',
      navigationItems: NavigationConfig.mainNavigationItems,
      appBar: const CustomAppBar(
        title: 'Modular Dashboard',
        centerTitle: false,
      ),
      body: Obx(() {
        final features = controller.availableFeatures;

        if (features.isEmpty) {
          return const Center(child: Text('No available features'));
        }

        return ResponsiveBuilder(
          builder: (context, deviceType) {
            return ListView(
              padding: EdgeInsets.all(
                context.responsive(
                  mobile: 16.0,
                  tablet: 24.0,
                  desktop: 32.0,
                ),
              ),
              children: [
                _buildWelcomeSection(context),
                const SizedBox(height: 24),
                _buildFeaturesGrid(context, features),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${controller.userName}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This template includes responsive layouts, navigation, and modular architecture with proper authentication.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context, List<Feature> features) {
    final crossAxisCount = context.responsive(
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: context.responsive(
          mobile: 1.5,
          tablet: 1.3,
          desktop: 1.2,
        ),
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _buildFeatureCard(features[index]);
      },
    );
  }

  Widget _buildFeatureCard(Feature feature) {
    switch (feature) {
      case Feature.inventory:
        return const InventorySummaryCard();
    }
  }
}
