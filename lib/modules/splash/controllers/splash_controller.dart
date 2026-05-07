import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    debugPrint('SplashController: onInit called');
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    debugPrint('SplashController: _initializeApp started');
    await Future.delayed(const Duration(seconds: 2));

    // First try to restore a persisted session (token from previous run)
    final restored = await _authService.restoreSession();
    if (restored) {
      debugPrint('SplashController: Session restored, navigating to dashboard');
      Get.offAllNamed(Routes.dashboard);
      return;
    }

    // Fall back to validating any in-memory session
    debugPrint('SplashController: No stored session, validating in-memory');
    final hasValidSession = await _authService.validateSession();
    debugPrint('SplashController: Session valid? $hasValidSession');
    if (hasValidSession) {
      debugPrint('SplashController: Navigating to dashboard');
      Get.offAllNamed(Routes.dashboard);
    } else {
      debugPrint('SplashController: Navigating to login');
      Get.offAllNamed(Routes.login);
    }
  }
}
