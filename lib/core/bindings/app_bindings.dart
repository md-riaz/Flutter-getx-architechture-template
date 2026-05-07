import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';
import '../services/session_manager.dart';
import '../data/repositories/auth_repository.dart';
import '../interfaces/interfaces.dart';
import '../implementations/implementations.dart';

/// Global-level bindings
/// These are initialized at app startup and persist throughout the app lifecycle
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Native interface implementations (permanent, global-level)
    // These can be easily swapped with other implementations
    Get.put<IStorageService>(MemoryStorageService(), permanent: true);
    Get.put<ILoggerService>(ConsoleLoggerService(), permanent: true);
    Get.put<IDeviceInfoService>(PlatformDeviceInfoService(), permanent: true);
    Get.put<IConnectivityService>(SimpleConnectivityService(), permanent: true);
    
    // Core services (permanent, global-level)
    Get.put(ApiClient(), permanent: true);
    Get.put<INetworkService>(
      ApiNetworkService(Get.find<ApiClient>()),
      permanent: true,
    );
    Get.put(SessionManager(), permanent: true);
    
    // Initialize storage service
    Get.find<IStorageService>().init();
    
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
