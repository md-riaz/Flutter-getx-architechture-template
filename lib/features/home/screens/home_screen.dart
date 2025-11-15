import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/auth/entities/user.dart' show AppFeature;
import '../../../services/theme_service.dart';
import '../../../util/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final featureCards = _featureDefinitions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  themeService.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: themeService.toggleTheme,
                tooltip: 'Toggle Theme',
              )),
          Obx(() => IconButton(
                icon: controller.isProcessing.value
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.logout),
                onPressed: controller.isProcessing.value
                    ? null
                    : () async {
                        final success = await controller.logout();
                        if (success) {
                          if (!Get.testMode) {
                            Get.offAllNamed(AppRoutes.login);
                          }
                        } else if (!Get.testMode) {
                          Get.snackbar(
                            'Logout',
                            controller.errorMessage.value ??
                                'Unable to logout. Please try again.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                tooltip: 'Logout',
              )),
        ],
      ),
      body: Obx(() {
        final selectedIndex = controller.selectedTabIndex.value;
        if (selectedIndex == 0) {
          return _DashboardTab(
            controller: controller,
            features: featureCards,
          );
        }
        return _ProfileTab(controller: controller);
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedTabIndex.value,
          onTap: controller.selectTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final HomeController controller;
  final List<_FeatureCard> features;

  const _DashboardTab({
    required this.controller,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final available = controller.availableFeatures;
      final enabledCards = features
          .where((card) => available.contains(card.feature))
          .toList();

      return RefreshIndicator(
        onRefresh: () async {
          final user = controller.user.value;
          if (user != null) {
            controller.availableFeatures.assignAll(user.enabledFeatures);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Enabled Modules',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (enabledCards.isEmpty)
              const Text(
                'This account has no feature access. Contact your administrator.',
              ),
            if (enabledCards.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: enabledCards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final card = enabledCards[index];
                  return _FeatureTile(card: card);
                },
              ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: available
                  .map(
                    (feature) => Chip(
                      avatar: Icon(_featureIcon(feature), size: 16),
                      label: Text(feature.name.toUpperCase()),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}

class _ProfileTab extends StatelessWidget {
  final HomeController controller;

  const _ProfileTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Session Details',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final user = controller.user.value;
            if (user == null) {
              return const Text('No user session loaded.');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${user.name}'),
                Text('Email: ${user.email}'),
                const SizedBox(height: 12),
                const Text('Enabled features:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.enabledFeatures
                      .map(
                        (feature) => Chip(
                          label: Text(feature.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.todos),
            icon: const Icon(Icons.check_box),
            label: const Text('Open Todos'),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final error = controller.errorMessage.value;
            if (error == null) {
              return const SizedBox.shrink();
            }
            return Text(
              error,
              style: const TextStyle(color: Colors.red),
            );
          }),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final _FeatureCard card;

  const _FeatureTile({required this.card});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Get.toNamed(card.route),
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(card.icon, size: 40),
              const SizedBox(height: 12),
              Text(
                card.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                card.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard {
  final AppFeature feature;
  final String label;
  final String subtitle;
  final IconData icon;
  final String route;

  const _FeatureCard({
    required this.feature,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}

List<_FeatureCard> get _featureDefinitions => const [
      _FeatureCard(
        feature: AppFeature.sms,
        label: 'SMS Service',
        subtitle: 'View conversations and messages',
        icon: Icons.sms,
        route: AppRoutes.sms,
      ),
      _FeatureCard(
        feature: AppFeature.fax,
        label: 'Fax Center',
        subtitle: 'Browse fax inbox and documents',
        icon: Icons.print,
        route: AppRoutes.fax,
      ),
      _FeatureCard(
        feature: AppFeature.voice,
        label: 'Voice Calls',
        subtitle: 'Inspect recent call history',
        icon: Icons.call,
        route: AppRoutes.voice,
      ),
      _FeatureCard(
        feature: AppFeature.todos,
        label: 'Todo Planner',
        subtitle: 'Manage operational tasks',
        icon: Icons.check_box,
        route: AppRoutes.todos,
      ),
    ];

IconData _featureIcon(AppFeature feature) {
  switch (feature) {
    case AppFeature.sms:
      return Icons.sms;
    case AppFeature.fax:
      return Icons.print;
    case AppFeature.voice:
      return Icons.call;
    case AppFeature.todos:
      return Icons.check_box;
  }
}
