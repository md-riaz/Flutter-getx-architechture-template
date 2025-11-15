import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../inventory/controllers/inventory_controller.dart';

enum Feature { inventory }

class DashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final availableFeatures = <Feature>[].obs;

  @override
  void onInit() {
    super.onInit();
    _detectFeatures();
  }

  void _detectFeatures() {
    // Check if user is authenticated
    if (!_authService.isLoggedIn) {
      return;
    }

    // Check permissions and detect available features
    if (Get.isRegistered<InventoryController>(tag: 'session')) {
      availableFeatures.add(Feature.inventory);
    }
  }

  String get userName => _authService.currentUser?.name ?? 'User';
  String get userEmail => _authService.currentUser?.email ?? '';
}
