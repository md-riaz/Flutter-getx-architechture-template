import 'package:get/get.dart';
import 'interfaces.dart';

/// Example service demonstrating how to use the native interfaces
/// This shows how business logic can use interfaces without depending on specific implementations
class ExampleService extends GetxService {
  final IStorageService _storage;
  final INetworkService _network;
  final ILoggerService _logger;
  final IDeviceInfoService _deviceInfo;
  final IConnectivityService _connectivity;

  ExampleService({
    required IStorageService storage,
    required INetworkService network,
    required ILoggerService logger,
    required IDeviceInfoService deviceInfo,
    required IConnectivityService connectivity,
  })  : _storage = storage,
        _network = network,
        _logger = logger,
        _deviceInfo = deviceInfo,
        _connectivity = connectivity;

  /// Example: Save user preferences
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      _logger.info('Saving user preferences', data: preferences);
      
      await _storage.setString('user_name', preferences['name']);
      await _storage.setInt('theme_mode', preferences['themeMode']);
      await _storage.setBool('notifications_enabled', preferences['notificationsEnabled']);
      
      _logger.info('User preferences saved successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to save user preferences', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Example: Load user preferences
  Future<Map<String, dynamic>> loadUserPreferences() async {
    try {
      _logger.info('Loading user preferences');
      
      final name = await _storage.getString('user_name');
      final themeMode = await _storage.getInt('theme_mode');
      final notificationsEnabled = await _storage.getBool('notifications_enabled');
      
      return {
        'name': name ?? 'Guest',
        'themeMode': themeMode ?? 0,
        'notificationsEnabled': notificationsEnabled ?? true,
      };
    } catch (e, stackTrace) {
      _logger.error('Failed to load user preferences', error: e, stackTrace: stackTrace);
      return {};
    }
  }

  /// Example: Sync data with server (with connectivity check)
  Future<bool> syncDataWithServer() async {
    try {
      _logger.info('Starting data sync');
      
      // Check connectivity first
      final hasConnection = await _connectivity.hasConnection();
      if (!hasConnection) {
        _logger.warning('No internet connection, sync skipped');
        return false;
      }

      final connectionType = await _connectivity.getConnectionType();
      _logger.info('Connection type: $connectionType');

      // Make network request
      final response = await _network.post(
        '/api/sync',
        body: {'device_id': await _deviceInfo.getDeviceId()},
      );

      if (response.isSuccess) {
        _logger.info('Data sync successful');
        return true;
      } else {
        _logger.warning('Data sync failed', data: {'statusCode': response.statusCode});
        return false;
      }
    } catch (e, stackTrace) {
      _logger.error('Error during data sync', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Example: Get device information for analytics
  Future<Map<String, dynamic>> getDeviceAnalytics() async {
    try {
      _logger.debug('Gathering device analytics');
      
      final os = await _deviceInfo.getOperatingSystem();
      final osVersion = await _deviceInfo.getOSVersion();
      final appVersion = await _deviceInfo.getAppVersion();
      final screenInfo = await _deviceInfo.getScreenInfo();
      final connectionType = await _connectivity.getConnectionType();
      
      return {
        'os': os,
        'os_version': osVersion,
        'app_version': appVersion,
        'screen_width': screenInfo.width,
        'screen_height': screenInfo.height,
        'connection_type': connectionType.toString(),
      };
    } catch (e, stackTrace) {
      _logger.error('Failed to gather device analytics', error: e, stackTrace: stackTrace);
      return {};
    }
  }

  /// Example: Clear all local data
  Future<void> clearAllData() async {
    try {
      _logger.info('Clearing all local data');
      
      await _storage.clear();
      
      _logger.info('All local data cleared');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear local data', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Example: Check if feature should be enabled based on device and connection
  Future<bool> shouldEnableFeature(String featureName) async {
    try {
      _logger.debug('Checking if feature should be enabled: $featureName');
      
      // Example logic: disable heavy features on mobile with cellular connection
      final isMobile = await _deviceInfo.isMobile();
      final isCellular = await _connectivity.isMobile();
      
      if (featureName == 'auto_video_playback' && isMobile && isCellular) {
        _logger.info('Feature disabled: mobile device on cellular');
        return false;
      }
      
      return true;
    } catch (e, stackTrace) {
      _logger.error('Error checking feature availability', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

/// Example usage in a binding:
/// ```dart
/// class ExampleBindings extends Bindings {
///   @override
///   void dependencies() {
///     Get.lazyPut<ExampleService>(
///       () => ExampleService(
///         storage: Get.find<IStorageService>(),
///         network: Get.find<INetworkService>(),
///         logger: Get.find<ILoggerService>(),
///         deviceInfo: Get.find<IDeviceInfoService>(),
///         connectivity: Get.find<IConnectivityService>(),
///       ),
///     );
///   }
/// }
/// ```
