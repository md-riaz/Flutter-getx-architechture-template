import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/examples_controller.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/responsive_builder.dart';
import '../../../core/config/navigation_config.dart';

/// Examples view demonstrating all template features
class ExamplesView extends GetView<ExamplesController> {
  const ExamplesView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Examples',
      navigationItems: NavigationConfig.mainNavigationItems,
      appBar: const CustomAppBar(
        title: 'UI Components Examples',
        centerTitle: false,
      ),
      body: ResponsiveBuilder(
        builder: (context, deviceType) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(
              context.responsive(
                mobile: 16.0,
                tablet: 24.0,
                desktop: 32.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDeviceTypeCard(context, deviceType),
                const SizedBox(height: 24),
                _buildResponsiveGridExample(context),
                const SizedBox(height: 24),
                _buildResponsiveLayoutExample(context),
                const SizedBox(height: 24),
                _buildCardsExample(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeviceTypeCard(BuildContext context, DeviceType deviceType) {
    final deviceName = deviceType.name.toUpperCase();
    final deviceIcon = deviceType == DeviceType.mobile
        ? Icons.phone_android
        : deviceType == DeviceType.tablet
            ? Icons.tablet
            : Icons.computer;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Icon(
              deviceIcon,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Device: $deviceName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Resize your browser to see responsive layout changes',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
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

  Widget _buildResponsiveGridExample(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Responsive Grid Layout',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.responsive(
              mobile: 1,
              tablet: 2,
              desktop: 4,
            ),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text('Item ${index + 1}'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResponsiveLayoutExample(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Responsive Layout Builder',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ResponsiveBuilder.custom(
          mobile: (context) => _buildMobileLayout(context),
          tablet: (context) => _buildTabletLayout(context),
          desktop: (context) => _buildDesktopLayout(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.phone_android, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              'Mobile Layout',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            const Text('Single column, compact design'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Icon(Icons.tablet, size: 64, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tablet Layout',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text('Two columns, medium spacing'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Icon(Icons.computer, size: 80, color: Colors.purple),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Desktop Layout',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Multi-column layout with large spacing and extended navigation'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsExample(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Components',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: context.responsive(
                mobile: double.infinity,
                tablet: 250.0,
                desktop: 300.0,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.work,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Feature Card',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text('This is an example of a feature card component.'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: context.responsive(
                mobile: double.infinity,
                tablet: 250.0,
                desktop: 300.0,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 40,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Analytics Card',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text('Display analytics and metrics here.'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
