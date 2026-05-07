import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/app_bindings.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/service_locator/service_locator.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Boot the service locator so all facades (Storage, Log, Api, etc.) are
  // available before the widget tree is built.
  await setupServiceLocator();

  runApp(const ModularGetXApp());
}

class ModularGetXApp extends StatelessWidget {
  const ModularGetXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Modular Template',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // Follows system theme
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
    );
  }
}
