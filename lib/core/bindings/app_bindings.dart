import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';
import '../services/session_manager.dart';
import '../data/repositories/auth_repository.dart';
import '../interfaces/interfaces.dart';
import '../service_locator/service_locator.dart';

/// Global-level bindings
/// These are initialized at app startup and persist throughout the app lifecycle.
///
/// Native-interface implementations (IStorageService, ILoggerService, etc.) are
/// registered in [setupServiceLocator] and accessed via facades or [locator].
/// Only GetX-specific services that rely on Get.find are registered here.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Legacy mock API client used by the Inventory module
    Get.put(ApiClient(), permanent: true);

    // Auth infrastructure (permanent, global-level)
    Get.put(
      AuthRepository(Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put(SessionManager(), permanent: true);
    Get.put(
      AuthService(
        Get.find<AuthRepository>(),
        Get.find<SessionManager>(),
        locator<IStorageService>(),
      ),
      permanent: true,
    );
  }
}
