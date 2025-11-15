import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate app initialization (loading config, checking updates, etc.)
    await Future.delayed(const Duration(seconds: 2));

    // Check if user has valid session
    final hasValidSession = await _authService.validateSession();

    if (hasValidSession) {
      // User is logged in, go to dashboard
      Get.offAllNamed(Routes.dashboard);
    } else {
      // User is not logged in, go to login
      Get.offAllNamed(Routes.login);
    }
  }
}
