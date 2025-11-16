import 'dart:io' show Platform;

/// Platform implementation for native platforms (Android, iOS, Desktop)
class PlatformInfo {
  String get operatingSystem => Platform.operatingSystem;
  String get operatingSystemVersion => Platform.operatingSystemVersion;
  bool get isAndroid => Platform.isAndroid;
  bool get isIOS => Platform.isIOS;
  bool get isDesktop => Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  bool get isMobile => Platform.isAndroid || Platform.isIOS;
}

PlatformInfo getPlatformInfo() => PlatformInfo();
