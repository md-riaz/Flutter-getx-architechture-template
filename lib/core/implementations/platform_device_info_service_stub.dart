/// Stub implementation for unsupported platforms
/// This should never be used in practice as we have io and web implementations
class PlatformInfo {
  String get operatingSystem => 'Unknown';
  String get operatingSystemVersion => 'N/A';
  bool get isAndroid => false;
  bool get isIOS => false;
  bool get isDesktop => false;
  bool get isMobile => false;
}

PlatformInfo getPlatformInfo() => PlatformInfo();
