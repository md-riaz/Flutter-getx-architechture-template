import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../inventory/bindings/inventory_bindings.dart';

class SessionManagerBindings extends Bindings {
  final AuthService auth;

  SessionManagerBindings({required this.auth});

  @override
  void dependencies() {
    final permissions = auth.permissions;

    if (permissions.inventoryAccess) {
      InventoryBindings().dependencies();
    }
  }
}
