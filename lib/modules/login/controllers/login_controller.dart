import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/bindings/session_bindings.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    // Clear previous errors
    errorMessage.value = '';

    // Validate inputs
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your email';
      return;
    }

    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return;
    }

    // Attempt login
    final success = await _authService.login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (success) {
      // Initialize session-level bindings with user permissions
      final user = _authService.currentUser;
      if (user != null) {
        SessionBindings(user: user).dependencies();
      }
      
      // Navigate to dashboard
      Get.offAllNamed(Routes.dashboard);
    } else {
      errorMessage.value = 'Invalid email or password';
    }
  }

  bool get isLoading => _authService.isLoading;
}
