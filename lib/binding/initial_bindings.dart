import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/feature_registry_service.dart';

/// Initial bindings for services that should be permanent
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    print('[InitialBindings] Setting up permanent services');
    
    // Register FeatureRegistryService as permanent
    Get.put<FeatureRegistryService>(
      FeatureRegistryService(),
      permanent: true,
    );
    
    // Register AuthService as permanent
    Get.put<AuthService>(
      AuthService(),
      permanent: true,
    );
  }
}
