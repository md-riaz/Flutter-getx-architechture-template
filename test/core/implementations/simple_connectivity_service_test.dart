import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/implementations/simple_connectivity_service.dart';
import 'package:getx_modular_template/core/interfaces/connectivity_interface.dart';

void main() {
  group('SimpleConnectivityService', () {
    late SimpleConnectivityService connectivityService;

    setUp(() {
      connectivityService = SimpleConnectivityService();
    });

    tearDown(() {
      connectivityService.dispose();
    });

    test('hasConnection returns true', () async {
      final hasConnection = await connectivityService.hasConnection();
      expect(hasConnection, true);
    });

    test('getConnectionType returns initial connection type', () async {
      final type = await connectivityService.getConnectionType();
      expect(type, ConnectionType.wifi);
    });

    test('isWiFi returns true for WiFi connection', () async {
      final isWiFi = await connectivityService.isWiFi();
      expect(isWiFi, true);
    });

    test('isMobile returns false for WiFi connection', () async {
      final isMobile = await connectivityService.isMobile();
      expect(isMobile, false);
    });

    test('isEthernet returns false for WiFi connection', () async {
      final isEthernet = await connectivityService.isEthernet();
      expect(isEthernet, false);
    });

    test('simulateConnectivityChange updates connection type', () async {
      connectivityService.simulateConnectivityChange(ConnectionType.mobile);
      final type = await connectivityService.getConnectionType();
      expect(type, ConnectionType.mobile);
    });

    test('onConnectivityChanged stream emits changes', () async {
      final stream = connectivityService.onConnectivityChanged;
      
      final future = stream.first;
      connectivityService.simulateConnectivityChange(ConnectionType.mobile);
      
      final type = await future;
      expect(type, ConnectionType.mobile);
    });

    test('connectivity changes are reflected in query methods', () async {
      connectivityService.simulateConnectivityChange(ConnectionType.mobile);
      
      expect(await connectivityService.isMobile(), true);
      expect(await connectivityService.isWiFi(), false);
    });
  });
}
