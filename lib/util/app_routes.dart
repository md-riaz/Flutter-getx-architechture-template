import 'package:get/get.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/todos/screens/todos_screen.dart';
import '../features/auth/binding/auth_binding.dart';
import '../features/home/binding/home_binding.dart';
import '../features/todos/binding/todos_binding.dart';
import '../services/feature_registry_service.dart';

/// App routes configuration
class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String todos = '/todos';

  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      // No binding - controller managed by feature registry
    ),
    GetPage(
      name: todos,
      page: () => const TodosScreen(),
      // No binding - controller and service managed by feature registry
    ),
  ];

  /// Initialize feature registry with feature bindings
  static void initializeFeatureRegistry() {
    final featureRegistry = Get.find<FeatureRegistryService>();
    
    // Register home feature binding
    featureRegistry.registerFeature('home', HomeBinding());
    
    // Register todos feature binding
    featureRegistry.registerFeature('todos', TodosBinding());
    
    print('[AppRoutes] Feature registry initialized');
  }
}
