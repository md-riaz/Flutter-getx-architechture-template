import 'package:flutter/material.dart';

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Device type enum
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Responsive builder that adapts UI based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  final Widget Function(BuildContext context)? mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  })  : mobile = null,
        tablet = null,
        desktop = null;

  const ResponsiveBuilder.custom({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : builder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, DeviceType deviceType) {
    return const SizedBox.shrink();
  }

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) {
      return DeviceType.mobile;
    } else if (width < Breakpoints.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    if (mobile != null || tablet != null || desktop != null) {
      switch (deviceType) {
        case DeviceType.mobile:
          return mobile?.call(context) ??
              tablet?.call(context) ??
              desktop?.call(context) ??
              const SizedBox.shrink();
        case DeviceType.tablet:
          return tablet?.call(context) ??
              desktop?.call(context) ??
              mobile?.call(context) ??
              const SizedBox.shrink();
        case DeviceType.desktop:
          return desktop?.call(context) ??
              tablet?.call(context) ??
              mobile?.call(context) ??
              const SizedBox.shrink();
      }
    }

    return builder(context, deviceType);
  }
}

/// Helper extension for responsive values
extension ResponsiveValue on BuildContext {
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = ResponsiveBuilder.getDeviceType(this);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? desktop ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}
