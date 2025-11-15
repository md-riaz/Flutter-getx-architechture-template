import 'package:get/get.dart';
import '../../../core/bindings/session_bindings.dart';
import '../controllers/dashboard_controller.dart';

/// Route-level bindings for Dashboard screen
class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize session-level bindings if not already done
    // This ensures session dependencies are available when navigating directly to dashboard
    final sessionBindingsExist = Get.isRegistered<DashboardController>(tag: 'session');
    if (!sessionBindingsExist) {
      SessionBindings().dependencies();
    }
    
    // Register the dashboard controller (route-level)
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
