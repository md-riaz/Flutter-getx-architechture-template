import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../modules/inventory/bindings/inventory_bindings.dart';
import '../data/models/user_model.dart';
import '../services/session_manager.dart';

/// Session-level bindings
/// These are initialized after login and disposed on logout
/// This is NOT a service - it's a Bindings class that receives user permissions
class SessionBindings extends Bindings {
  final User user;

  SessionBindings({required this.user});

  @override
  void dependencies() {
    debugPrint(
        "SessionBindings: Initializing features based on user permissions.");

    final sessionManager = Get.find<SessionManager>();

    // Initialize feature services first based on user permissions.
    // Each feature Bindings class registers its own cleanup callbacks with
    // the SessionManager, so no additional registration is needed here.
    if (user.permissions.inventoryAccess) {
      InventoryBindings().dependencies();
    }

    // Add more feature bindings here based on permissions
    // if (user.permissions.paymentsAccess) {
    //   PaymentsBindings().dependencies();
    // }

    // Finally, initialize the dashboard controller which will use these services.
    // It's tagged with 'session' so it's disposed on logout.
    Get.put(DashboardController(), tag: SessionManager.sessionTag);
    sessionManager.registerCleanup(
      () => Get.delete<DashboardController>(
        tag: SessionManager.sessionTag,
        force: true,
      ),
    );
  }
}
