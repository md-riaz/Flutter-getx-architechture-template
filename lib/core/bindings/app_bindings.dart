import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';
import '../services/session_manager.dart';
import '../data/repositories/auth_repository.dart';

/// Global-level bindings
/// These are initialized at app startup and persist throughout the app lifecycle
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core services (permanent, global-level)
    Get.put(ApiClient(), permanent: true);
    Get.put(SessionManager(), permanent: true);
    
    // Auth infrastructure (permanent, global-level)
    Get.put(
      AuthRepository(Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put(
      AuthService(
        Get.find<AuthRepository>(),
        Get.find<SessionManager>(),
      ),
      permanent: true,
    );
  }
}
