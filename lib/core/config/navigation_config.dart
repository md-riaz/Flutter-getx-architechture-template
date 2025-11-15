import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';
import '../routes/app_routes.dart';

/// Central navigation configuration for the app
class NavigationConfig {
  static final List<NavigationItem> mainNavigationItems = [
    const NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: Routes.dashboard,
    ),
    const NavigationItem(
      label: 'Inventory',
      icon: Icons.inventory_outlined,
      selectedIcon: Icons.inventory,
      route: Routes.inventory,
    ),
    const NavigationItem(
      label: 'Examples',
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
      route: Routes.examples,
    ),
  ];
}
