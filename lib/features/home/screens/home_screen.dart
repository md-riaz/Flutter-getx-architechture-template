import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'Logout',
          ),
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
              Text(
                'User: ${controller.getUserEmail()}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              Obx(() => Text(
                'Counter: ${controller.counter.value}',
                style: const TextStyle(fontSize: 24),
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.incrementCounter,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Increment Counter'),
              ),
              const SizedBox(height: 40),
              Obx(() => Text(
                'Random State: ${controller.randomState.value}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
