/// Platform implementation for web
class PlatformInfo {
  String get operatingSystem => 'Web';
  String get operatingSystemVersion => 'N/A';
  bool get isAndroid => false;
  bool get isIOS => false;
  bool get isDesktop => false;
  bool get isMobile => false;
}

PlatformInfo getPlatformInfo() => PlatformInfo();
