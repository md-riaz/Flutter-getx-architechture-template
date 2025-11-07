import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/settings_controller.dart';

/// Settings view
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // User Profile Section
          Card(
            margin: const EdgeInsets.all(AppTokens.spacing16),
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.spacing16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spacing16),
                  Text(
                    authService.currentUser?.name ?? 'User',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    authService.currentUser?.email ?? 'user@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTokens.spacing8),
                  Chip(
                    label: Text(authService.currentUser?.role.name.toUpperCase() ?? 'ROLE'),
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ],
              ),
            ),
          ),

          // App Settings Section
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTokens.spacing16,
              vertical: AppTokens.spacing8,
            ),
            child: Text(
              'App Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          Obx(() => SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable dark theme'),
                value: controller.isDarkMode.value,
                onChanged: controller.toggleDarkMode,
                secondary: const Icon(Icons.dark_mode),
              )),

          Obx(() => SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Enable push notifications'),
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
                secondary: const Icon(Icons.notifications),
              )),

          const Divider(),

          // Store Settings Section
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTokens.spacing16,
              vertical: AppTokens.spacing8,
            ),
            child: Text(
              'Store Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Store Profile'),
            subtitle: const Text('Manage store information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.snackbar('Coming Soon', 'Store profile settings',
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),

          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Invoice Settings'),
            subtitle: const Text('Configure invoice templates'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.snackbar('Coming Soon', 'Invoice settings',
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),

          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Tax Settings'),
            subtitle: const Text('Configure GST rates and rules'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.snackbar('Coming Soon', 'Tax settings',
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),

          const Divider(),

          // Data Management Section
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTokens.spacing16,
              vertical: AppTokens.spacing8,
            ),
            child: Text(
              'Data Management',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup Data'),
            subtitle: const Text('Export all data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.snackbar('Coming Soon', 'Data backup feature',
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),

          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Data'),
            subtitle: const Text('Import data from backup'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.snackbar('Coming Soon', 'Data restore feature',
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),

          const Divider(),

          // About Section
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTokens.spacing16,
              vertical: AppTokens.spacing8,
            ),
            child: Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Mobile Store'),
            subtitle: const Text('Version 1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('About Mobile Store'),
                  content: const Text(
                    'Mobile Store v1.0.0\n\n'
                    'A complete inventory management system for mobile phone retail.\n\n'
                    'Built with Flutter & GetX',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: AppTokens.spacing32),
        ],
      ),
    );
  }
}
