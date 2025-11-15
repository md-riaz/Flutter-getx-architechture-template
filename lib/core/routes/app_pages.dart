import 'package:get/get.dart';
import '../../modules/dashboard/bindings/dashboard_bindings.dart';
import '../../modules/dashboard/views/dashboard_view.dart';
import '../../modules/inventory/bindings/inventory_bindings.dart';
import '../../modules/inventory/views/inventory_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
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
  ];
}
