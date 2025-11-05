import 'package:get/get.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../binding/auth_binding.dart';
import '../binding/home_binding.dart';
import '../services/feature_registry_service.dart';

/// App routes configuration
class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];

  /// Initialize feature registry with feature bindings
  static void initializeFeatureRegistry() {
    final featureRegistry = Get.find<FeatureRegistryService>();
    
    // Register home feature binding
    featureRegistry.registerFeature('home', HomeBinding());
    
    print('[AppRoutes] Feature registry initialized');
  }
}
