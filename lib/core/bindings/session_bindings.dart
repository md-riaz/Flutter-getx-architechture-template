import 'package:get/get.dart';
import '../../modules/inventory/bindings/inventory_bindings.dart';
import '../services/auth_service.dart';
import '../services/session_manager.dart';

/// Session-level bindings
/// These are initialized after login and disposed on logout
class SessionBindings extends Bindings {
  @override
  void dependencies() {
    final sessionManager = Get.find<SessionManager>();
    final sessionTag = sessionManager.currentSessionTag;
    final auth = Get.find<AuthService>();
    final permissions = auth.permissions;

    // Register session-level dependencies based on user permissions
    if (permissions?.inventoryAccess ?? false) {
      _registerInventoryModule(sessionTag);
    }

    // Add more modules here based on permissions
    // if (permissions?.paymentsAccess ?? false) {
    //   _registerPaymentsModule(sessionTag);
    // }
  }

  void _registerInventoryModule(String sessionTag) {
    // Use InventoryBindings but ensure dependencies use the session tag
    final inventoryBindings = InventoryBindings();
    inventoryBindings.dependencies();
  }
}
