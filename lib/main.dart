import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/config/env.dart';
import 'app/core/services/auth_service.dart';
import 'app/core/services/json_db_service.dart';
import 'app/core/services/number_series_service.dart';
import 'app/core/services/tax_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/modules/dashboard/bindings/dashboard_binding.dart';
import 'app/modules/dashboard/views/dashboard_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await Get.putAsync(() => JsonDbService().init());
  Get.put(TaxService());
  Get.put(NumberSeriesService());
  Get.put(AuthService.mock(role: UserRole.admin));

  if (kDebugMode) {
    debugPrint('[Main] App initialized with env: ${AppEnv.current.isDev ? "DEV" : "PROD"}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mobile Store',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const DashboardView(),
      initialBinding: DashboardBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
