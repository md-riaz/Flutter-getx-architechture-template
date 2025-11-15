import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

/// Middleware to protect routes that require authentication
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    
    // If user is not logged in, redirect to login
    if (!authService.isLoggedIn) {
      return const RouteSettings(name: Routes.login);
    }
    
    // User is authenticated, allow access
    return null;
  }
}
