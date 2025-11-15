import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/app_bindings.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
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
