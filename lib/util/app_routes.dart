import 'package:get/get.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/todos/screens/todos_screen.dart';
import '../binding/auth_binding.dart';
import '../binding/home_binding.dart';
import '../binding/todos_binding.dart';
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
      binding: HomeBinding(),
    ),
    GetPage(
      name: todos,
      page: () => const TodosScreen(),
      binding: TodosBinding(),
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
