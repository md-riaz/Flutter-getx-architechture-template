import 'dart:async';
import '../interfaces/connectivity_interface.dart';

/// Simple implementation of IConnectivityService
/// This is a mock implementation that always returns connected
/// Can be replaced with connectivity_plus package for actual connectivity checking
class SimpleConnectivityService implements IConnectivityService {
  final StreamController<ConnectionType> _connectivityController =
      StreamController<ConnectionType>.broadcast();

  ConnectionType _currentType = ConnectionType.wifi;

  @override
  Future<bool> hasConnection() async {
    // Mock: always return true
    return true;
  }

  @override
  Future<ConnectionType> getConnectionType() async {
    return _currentType;
  }

  @override
  Stream<ConnectionType> get onConnectivityChanged =>
      _connectivityController.stream;

  @override
  Future<bool> isWiFi() async {
    final type = await getConnectionType();
    return type == ConnectionType.wifi;
  }

  @override
  Future<bool> isMobile() async {
    final type = await getConnectionType();
    return type == ConnectionType.mobile;
  }

  @override
  Future<bool> isEthernet() async {
    final type = await getConnectionType();
    return type == ConnectionType.ethernet;
  }

  /// Simulate connectivity change (for testing)
  void simulateConnectivityChange(ConnectionType type) {
    _currentType = type;
    _connectivityController.add(type);
  }

  /// Dispose the service
  void dispose() {
    _connectivityController.close();
  }
}
