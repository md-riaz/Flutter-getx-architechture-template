/// Interface for network connectivity operations
/// This allows swapping between different connectivity implementations
/// (connectivity_plus, etc.) without changing usage
abstract class IConnectivityService {
  /// Check if device has internet connection
  Future<bool> hasConnection();

  /// Get current connection type
  Future<ConnectionType> getConnectionType();

  /// Stream of connectivity changes
  Stream<ConnectionType> get onConnectivityChanged;

  /// Check if connected via WiFi
  Future<bool> isWiFi();

  /// Check if connected via Mobile data
  Future<bool> isMobile();

  /// Check if connected via Ethernet
  Future<bool> isEthernet();
}

/// Types of network connection
enum ConnectionType {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  none,
  unknown,
}
