import 'package:get/get.dart';
import '../features/auth/binding/auth_binding.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/home/binding/home_binding.dart';
import '../features/home/screens/home_screen.dart';
import '../features/todos/binding/todos_binding.dart';
import '../features/todos/screens/todos_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String todos = '/todos';

  static final List<GetPage> routes = [
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
}
