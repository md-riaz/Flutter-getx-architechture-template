import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/theme_service.dart';
import '../../../util/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Home!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final user = controller.user.value;
                return Text(
                  'User: ${user?.email ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 18),
                );
              }),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.todos),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                icon: const Icon(Icons.check_box),
                label: const Text('Go to Todos'),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final message = controller.errorMessage.value;
                if (message == null) {
                  return const SizedBox.shrink();
                }
                return Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
