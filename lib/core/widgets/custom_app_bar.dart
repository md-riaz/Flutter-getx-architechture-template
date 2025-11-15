import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

/// Custom app bar with common actions and responsive design
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final List<Widget>? extraActions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.centerTitle = false,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      bottom: bottom,
      actions: [
        ...?extraActions,
        ...?actions,
        _buildSearchAction(context),
        _buildNotificationAction(context),
        _buildProfileAction(context),
      ],
      elevation: 2,
    );
  }

  Widget _buildSearchAction(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: 'Search',
      onPressed: () {
        // Search functionality can be implemented here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Search functionality coming soon!')),
        );
      },
    );
  }

  Widget _buildNotificationAction(BuildContext context) {
    return IconButton(
      icon: const Badge(
        label: Text('3'),
        child: Icon(Icons.notifications_outlined),
      ),
      tooltip: 'Notifications',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications coming soon!')),
        );
      },
    );
  }

  Widget _buildProfileAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: PopupMenuButton<String>(
        icon: const CircleAvatar(
          radius: 16,
          child: Icon(Icons.person, size: 20),
        ),
        tooltip: 'Profile',
        onSelected: (value) {
          _handleMenuSelection(context, value);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'profile',
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'settings',
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'theme',
            child: ListTile(
              leading: Icon(Icons.palette),
              title: Text('Theme'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'logout',
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    if (value == 'logout') {
      _handleLogout(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected: $value')),
      );
    }
  }

  void _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        // Get the auth service and logout
        final authService = Get.find<AuthService>();
        await authService.logout();
        
        // Navigate to login screen
        Get.offAllNamed('/login');
      } catch (e) {
        // Fallback if service not found
        Get.offAllNamed('/login');
      }
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
