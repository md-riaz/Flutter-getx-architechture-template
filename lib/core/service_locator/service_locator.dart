import 'package:get_it/get_it.dart';
import '../interfaces/interfaces.dart';
import '../implementations/implementations.dart';

/// Global service locator instance
/// This provides dependency injection using get_it package
final GetIt locator = GetIt.instance;

/// Initialize all services in the service locator
/// This should be called at app startup before any services are used
Future<void> setupServiceLocator() async {
  // Storage Service
  locator.registerLazySingleton<IStorageService>(
    () => MemoryStorageService(),
  );

  // Network Service
  locator.registerLazySingleton<INetworkService>(
    () => ApiNetworkService(locator<INetworkService>() as dynamic),
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
