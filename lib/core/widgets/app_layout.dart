import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'responsive_builder.dart';

/// Navigation item model
class NavigationItem {
  final String label;
  final IconData icon;
  final String route;
  final IconData? selectedIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
    this.selectedIcon,
  });
}

/// App layout that provides responsive navigation
/// - Mobile: BottomNavigationBar
/// - Tablet/Desktop: NavigationRail or Drawer
class AppLayout extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final List<NavigationItem> navigationItems;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool showDrawer;
  final bool showBottomNav;

  const AppLayout({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.navigationItems = const [],
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showDrawer = true,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout(context);
          case DeviceType.tablet:
            return _buildTabletLayout(context);
          case DeviceType.desktop:
            return _buildDesktopLayout(context);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? _buildAppBar(context),
      drawer: showDrawer && navigationItems.isNotEmpty
          ? _buildDrawer(context)
          : null,
      body: body,
      bottomNavigationBar: showBottomNav && navigationItems.isNotEmpty
          ? _buildBottomNavigationBar(context)
          : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? _buildAppBar(context),
      body: Row(
        children: [
          if (navigationItems.isNotEmpty) _buildNavigationRail(context),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? _buildAppBar(context),
      body: Row(
        children: [
          if (navigationItems.isNotEmpty) _buildNavigationRail(context, extended: true),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(title ?? 'GetX Template'),
      actions: actions,
      elevation: 2,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.flutter_dash,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'GetX Template',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
          for (final item in navigationItems)
            ListTile(
              leading: Icon(
                currentRoute == item.route
                    ? (item.selectedIcon ?? item.icon)
                    : item.icon,
              ),
              title: Text(item.label),
              selected: currentRoute == item.route,
              onTap: () {
                Navigator.pop(context);
                if (currentRoute != item.route) {
                  Get.offAllNamed(item.route);
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final currentIndex = navigationItems.indexWhere((item) => item.route == currentRoute);

    return BottomNavigationBar(
      currentIndex: currentIndex >= 0 ? currentIndex : 0,
      onTap: (index) {
        final item = navigationItems[index];
        if (currentRoute != item.route) {
          Get.offAllNamed(item.route);
        }
      },
      items: navigationItems
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: Icon(item.selectedIcon ?? item.icon),
              label: item.label,
            ),
          )
          .toList(),
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget _buildNavigationRail(BuildContext context, {bool extended = false}) {
    final currentRoute = Get.currentRoute;
    final currentIndex = navigationItems.indexWhere((item) => item.route == currentRoute);

    return NavigationRail(
      selectedIndex: currentIndex >= 0 ? currentIndex : 0,
      onDestinationSelected: (index) {
        final item = navigationItems[index];
        if (currentRoute != item.route) {
          Get.offAllNamed(item.route);
        }
      },
      extended: extended,
      labelType: extended ? null : NavigationRailLabelType.all,
      destinations: navigationItems
          .map(
            (item) => NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon ?? item.icon),
              label: Text(item.label),
            ),
          )
          .toList(),
    );
  }
}
