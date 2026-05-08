import 'package:get_it/get_it.dart';
import '../http/api_client.dart';
import '../interfaces/interfaces.dart';
import '../implementations/implementations.dart';

/// Global service locator instance
/// This provides dependency injection using get_it package
final GetIt locator = GetIt.instance;

/// Initialize all services in the service locator.
/// Must be called at app startup (before [runApp]) so that all facades and
/// get_it-backed services are available immediately.
Future<void> setupServiceLocator() async {
  // Storage Service
  locator.registerLazySingleton<IStorageService>(
    () => MemoryStorageService(),
  );

  // Shared Dio-based HTTP client (used by Api facade and modules)
  locator.registerLazySingleton<DioApiClient>(
    () => DioApiClient(),
  );

  // Network Service — wraps DioApiClient to satisfy INetworkService callers
  locator.registerLazySingleton<INetworkService>(
    () => ApiNetworkService(locator<DioApiClient>().dio),
  );

  // Device Info Service
  locator.registerLazySingleton<IDeviceInfoService>(
    () => PlatformDeviceInfoService(),
  );

  // Connectivity Service
  locator.registerLazySingleton<IConnectivityService>(
    () => SimpleConnectivityService(),
  );

  // Logger Service
  locator.registerLazySingleton<ILoggerService>(
    () => ConsoleLoggerService(),
  );

  // File Service
  locator.registerLazySingleton<IFileService>(
    () => FilePickerService(),
  );

  // Initialize services that need async setup
  await locator<IStorageService>().init();
}

/// Reset the service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await locator.reset();
}
