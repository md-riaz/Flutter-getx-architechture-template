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
    debugPrint('SplashController: Finished delay, validating session');
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
