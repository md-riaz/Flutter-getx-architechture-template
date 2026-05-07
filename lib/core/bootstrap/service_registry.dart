import '../service_locator/service_locator.dart';

class ServiceRegistry {
  ServiceRegistry._();

  static Future<void> register() async {
    await setupServiceLocator();
  }
}
