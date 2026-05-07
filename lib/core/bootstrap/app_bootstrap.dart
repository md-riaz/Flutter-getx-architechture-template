import 'app_auth.dart';
import 'app_config.dart';
import 'app_database.dart';
import 'service_registry.dart';

class AppBootstrap {
  AppBootstrap._();

  static Future<void> boot() async {
    await Config.load();
    await ServiceRegistry.register();
    await Database.boot();
    await AuthBootstrap.boot();
  }
}
