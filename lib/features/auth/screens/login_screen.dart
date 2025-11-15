import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Flutter GetX Architecture',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => controller.email.value = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              onChanged: (value) => controller.password.value = value,
            ),
            const SizedBox(height: 16),
            Obx(() {
              final message = controller.errorMessage.value;
              if (message == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }),
            const SizedBox(height: 8),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          final success = await controller.login();
                          if (success) {
                            if (!Get.testMode) {
                              Get.offAllNamed(AppRoutes.home);
                            }
                          } else {
                            final message =
                                controller.errorMessage.value ?? 'Login failed';
                            if (!Get.testMode) {
                              Get.snackbar(
                                'Login',
                                message,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                )),
            const SizedBox(height: 24),
            const _CredentialsCard(),
          ],
        ),
      ),
    );
  }
}

class _CredentialsCard extends StatelessWidget {
  const _CredentialsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final credentials = const [
      _CredentialRow(
        name: 'Alex Operations',
        email: 'alex.operations@example.com',
        password: 'Passw0rd!',
        features: ['SMS', 'Voice'],
      ),
      _CredentialRow(
        name: 'Brenda Dispatch',
        email: 'brenda.dispatch@example.com',
        password: 'FaxMeNow',
        features: ['Fax', 'Todos'],
      ),
      _CredentialRow(
        name: 'Cameron Supervisor',
        email: 'cameron.supervisor@example.com',
        password: 'Secure*123',
        features: ['SMS', 'Fax', 'Voice', 'Todos'],
      ),
    ];

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demo Accounts',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...credentials,
          ],
        ),
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String name;
  final String email;
  final String password;
  final List<String> features;

  const _CredentialRow({
    required this.name,
    required this.email,
    required this.password,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: theme.textTheme.titleSmall),
          Text('Email: $email'),
          Text('Password: $password'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: features
                .map((feature) => Chip(label: Text(feature)))
                .toList(),
          ),
        ],
      ),
    );
  }
}
