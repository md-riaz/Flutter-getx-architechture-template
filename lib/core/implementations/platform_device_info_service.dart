import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import '../interfaces/device_info_interface.dart';

/// Platform-based implementation of IDeviceInfoService
/// Uses Flutter's Platform and kIsWeb to determine device information
/// Can be replaced with device_info_plus or other packages for more detailed info
class PlatformDeviceInfoService implements IDeviceInfoService {
  @override
  Future<String> getOperatingSystem() async {
    if (kIsWeb) return 'Web';
    return Platform.operatingSystem;
  }

  @override
  Future<String> getOSVersion() async {
    if (kIsWeb) return 'N/A';
    return Platform.operatingSystemVersion;
  }

  @override
  Future<String> getDeviceModel() async {
    // This would require device_info_plus for actual device model
    return 'Unknown';
  }

  @override
  Future<String> getDeviceManufacturer() async {
    // This would require device_info_plus for actual manufacturer
    return 'Unknown';
  }

  @override
  Future<bool> isAndroid() async {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  @override
  Future<bool> isIOS() async {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  @override
  Future<bool> isWeb() async {
    return kIsWeb;
  }

  @override
  Future<bool> isDesktop() async {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  Future<bool> isMobile() async {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  Future<String?> getDeviceId() async {
    // This would require device_info_plus or platform_device_id
    return null;
  }

  @override
  Future<String> getAppVersion() async {
    // This would require package_info_plus
    return '1.0.0';
  }

  @override
  Future<String> getBuildNumber() async {
    // This would require package_info_plus
    return '1';
  }

  @override
  Future<DeviceScreenInfo> getScreenInfo() async {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    
    return DeviceScreenInfo(
      width: size.width,
      height: size.height,
      pixelRatio: view.devicePixelRatio,
    );
  }
}
