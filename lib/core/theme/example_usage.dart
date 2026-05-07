/// This file demonstrates how to use the theme configuration system.
///
/// This is for documentation purposes only and is not used in the app.
/// You can delete this file or use it as a reference for implementing
/// themed widgets in your application.
library example_usage;

// ignore_for_file: unused_element, unused_local_variable

import 'package:flutter/material.dart';

import 'theme.dart';

/// Example 1: Using theme colors in a widget
class ThemedButtonExample extends StatelessWidget {
  const ThemedButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Theme.of(context) to access colors that adapt to light/dark mode
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        // Using theme configuration
        shape: AppThemeConfig.buttonShape,
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeConfig.spaceL,
          vertical: AppThemeConfig.spaceM,
        ),
      ),
      child: const Text('Themed Button'),
    );
  }
}

/// Example 2: Custom card with themed styling
class ThemedCardExample extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;

  const ThemedCardExample({
    required this.title,
    required this.description,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Card automatically uses theme configuration
      elevation: AppThemeConfig.cardElevation,
      shape: AppThemeConfig.cardShape,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            AppThemeConfig.borderRadius(AppThemeConfig.cardBorderRadius),
        child: Padding(
          padding: EdgeInsets.all(AppThemeConfig.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title using theme typography
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: AppThemeConfig.spaceS),

              // Description
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example 3: Custom container with gradient background
class GradientContainerExample extends StatelessWidget {
  final Widget child;

  const GradientContainerExample({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.all(
          Radius.circular(AppThemeConfig.radiusL),
        ),
      ),
      padding: EdgeInsets.all(AppThemeConfig.spaceL),
      child: child,
    );
  }
}

/// Example 4: Custom input field with theme styling
class ThemedInputFieldExample extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;

  const ThemedInputFieldExample({
    required this.label,
    required this.hint,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // Input field automatically uses theme configuration
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.text_fields),
        // Border styles are defined in theme
      ),
    );
  }
}

/// Example 5: Status indicator with semantic colors
class StatusIndicatorExample extends StatelessWidget {
  final String status;
  final String message;

  const StatusIndicatorExample({
    required this.status,
    required this.message,
    super.key,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      case 'error':
        return AppColors.error;
      case 'info':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'success':
        return Icons.check_circle_outline;
      case 'warning':
        return Icons.warning_amber_outlined;
      case 'error':
        return Icons.error_outline;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      padding: EdgeInsets.all(AppThemeConfig.spaceM),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: (0.1 * 255)),
        borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.radiusM),
        border: Border.all(
          color: statusColor.withValues(alpha: (0.5 * 255)),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(),
            color: statusColor,
            size: AppThemeConfig.iconSizeM,
          ),
          SizedBox(width: AppThemeConfig.spaceS),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Example 6: Animated widget using theme configuration
class AnimatedThemedContainerExample extends StatefulWidget {
  const AnimatedThemedContainerExample({super.key});

  @override
  State<AnimatedThemedContainerExample> createState() =>
      _AnimatedThemedContainerExampleState();
}

class _AnimatedThemedContainerExampleState
    extends State<AnimatedThemedContainerExample> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        // Using theme animation duration
        duration: AppThemeConfig.animationNormal,
        curve: Curves.easeInOut,
        width: _isExpanded ? 200 : 100,
        height: _isExpanded ? 200 : 100,
        decoration: BoxDecoration(
          color: _isExpanded ? AppColors.primary : AppColors.secondary,
          borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.radiusL),
        ),
        child: Center(
          child: Icon(
            _isExpanded ? Icons.fullscreen_exit : Icons.fullscreen,
            color: Colors.white,
            size: AppThemeConfig.iconSizeL,
          ),
        ),
      ),
    );
  }
}

/// Example 7: Responsive widget using theme breakpoints
class ResponsiveThemedWidgetExample extends StatelessWidget {
  const ResponsiveThemedWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine device type using theme breakpoints
    final isMobile = screenWidth < AppThemeConfig.breakpointMobile;
    final isTablet = screenWidth >= AppThemeConfig.breakpointMobile &&
        screenWidth < AppThemeConfig.breakpointTablet;
    final isDesktop = screenWidth >= AppThemeConfig.breakpointDesktop;

    // Adjust padding based on device type
    final padding = isMobile
        ? AppThemeConfig.spaceM
        : isTablet
            ? AppThemeConfig.spaceL
            : AppThemeConfig.spaceXL;

    return Container(
      padding: EdgeInsets.all(padding),
      child: Text(
        isMobile
            ? 'Mobile View'
            : isTablet
                ? 'Tablet View'
                : 'Desktop View',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

/// Example 8: Custom chip using theme configuration
class ThemedChipExample extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const ThemedChipExample({
    required this.label,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      backgroundColor: isSelected
          ? AppColors.primary.withValues(alpha: (0.2 * 255))
          : Theme.of(context).colorScheme.surface,
      side: BorderSide(
        color: isSelected
            ? AppColors.primary
            : Theme.of(context).colorScheme.outline,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppThemeConfig.borderRadius(AppThemeConfig.radiusM),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeConfig.spaceM,
        vertical: AppThemeConfig.spaceS,
      ),
      onPressed: onTap,
    );
  }
}
