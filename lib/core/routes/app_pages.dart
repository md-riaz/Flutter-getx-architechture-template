import 'package:get/get.dart';
import '../../modules/splash/bindings/splash_bindings.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/login/bindings/login_bindings.dart';
import '../../modules/login/views/login_view.dart';
import '../../modules/dashboard/bindings/dashboard_bindings.dart';
import '../../modules/dashboard/views/dashboard_view.dart';
import '../../modules/inventory/bindings/inventory_bindings.dart';
import '../../modules/inventory/views/inventory_view.dart';
import '../../modules/examples/bindings/examples_bindings.dart';
import '../../modules/examples/views/examples_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBindings(),
    ),
    GetPage(
      name: Routes.inventory,
      page: () => const InventoryView(),
      binding: InventoryBindings(),
    ),
    GetPage(
      name: Routes.examples,
      page: () => const ExamplesView(),
      binding: ExamplesBindings(),
    ),
  ];
}
