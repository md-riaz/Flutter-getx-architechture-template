import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import '../interfaces/device_info_interface.dart';
import 'platform_device_info_service_stub.dart'
    if (dart.library.io) 'platform_device_info_service_io.dart'
    if (dart.library.html) 'platform_device_info_service_web.dart';

/// Platform-based implementation of IDeviceInfoService
/// Uses conditional imports to support both native and web platforms
/// Can be replaced with device_info_plus or other packages for more detailed info
class PlatformDeviceInfoService implements IDeviceInfoService {
  final PlatformInfo _platform = getPlatformInfo();

  @override
  Future<String> getOperatingSystem() async {
    return _platform.operatingSystem;
  }

  @override
  Future<String> getOSVersion() async {
    return _platform.operatingSystemVersion;
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
    return _platform.isAndroid;
  }

  @override
  Future<bool> isIOS() async {
    return _platform.isIOS;
  }

  @override
  Future<bool> isWeb() async {
    return kIsWeb;
  }

  @override
  Future<bool> isDesktop() async {
    return _platform.isDesktop;
  }

  @override
  Future<bool> isMobile() async {
    return _platform.isMobile;
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
