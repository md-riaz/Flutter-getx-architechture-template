import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'binding/initial_bindings.dart';
import 'theme/app_theme.dart';
import 'util/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX Architecture',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      onInit: () {
        print('[MyApp] App initialized');
        // Initialize feature registry after initial bindings
        AppRoutes.initializeFeatureRegistry();
      },
    );
  }
}
