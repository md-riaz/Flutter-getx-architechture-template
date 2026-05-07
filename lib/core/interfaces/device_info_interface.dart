/// Interface for device information operations
/// This allows swapping between different device info implementations
/// (device_info_plus, platform, etc.) without changing usage
abstract class IDeviceInfoService {
  /// Get the device operating system
  Future<String> getOperatingSystem();

  /// Get the device OS version
  Future<String> getOSVersion();

  /// Get the device model
  Future<String> getDeviceModel();

  /// Get the device manufacturer
  Future<String> getDeviceManufacturer();

  /// Check if running on Android
  Future<bool> isAndroid();

  /// Check if running on iOS
  Future<bool> isIOS();

  /// Check if running on Web
  Future<bool> isWeb();

  /// Check if running on Desktop (Windows, Linux, macOS)
  Future<bool> isDesktop();

  /// Check if running on Mobile (Android or iOS)
  Future<bool> isMobile();

  /// Get device unique identifier (if available)
  Future<String?> getDeviceId();

  /// Get app version
  Future<String> getAppVersion();

  /// Get app build number
  Future<String> getBuildNumber();

  /// Get device screen size
  Future<DeviceScreenInfo> getScreenInfo();
}

/// Device screen information
class DeviceScreenInfo {
  final double width;
  final double height;
  final double pixelRatio;

  DeviceScreenInfo({
    required this.width,
    required this.height,
    required this.pixelRatio,
  });

  double get physicalWidth => width * pixelRatio;
  double get physicalHeight => height * pixelRatio;
}
