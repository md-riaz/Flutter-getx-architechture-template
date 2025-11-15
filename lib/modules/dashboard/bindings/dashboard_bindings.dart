import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/bindings/session_bindings.dart';
import '../controllers/dashboard_controller.dart';

/// Route-level bindings for Dashboard screen
class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    // Check if session bindings already exist
    final sessionControllerExists = Get.isRegistered<DashboardController>(tag: 'session');
    
    if (!sessionControllerExists) {
      // Session bindings not initialized, initialize them now
      // This handles the case where user navigates directly to dashboard
      final authService = Get.find<AuthService>();
      final user = authService.currentUser;
      
      if (user != null) {
        SessionBindings(user: user).dependencies();
      }
    }
    
    // Note: We don't register DashboardController here as it's already 
    // registered with 'session' tag in SessionBindings
  }
}
