import 'package:get/get.dart';
import '../features/home/controllers/home_controller.dart';
import '../features/todos/controllers/todos_controller.dart';
import '../features/todos/services/todos_service.dart';

/// Service to manage feature bindings
/// Creates bindings on login, deletes on logout
class FeatureRegistryService extends GetxService {
  final _registeredFeatures = <String, Bindings>{};

  /// Register a feature binding
  void registerFeature(String featureName, Bindings binding) {
    print('[FeatureRegistryService] Registering feature: $featureName');
    _registeredFeatures[featureName] = binding;
  }

  /// Create all registered feature bindings (on login)
  void createFeatureBindings() {
    print('[FeatureRegistryService] Creating feature bindings');
    for (final entry in _registeredFeatures.entries) {
      print('[FeatureRegistryService] Creating binding for: ${entry.key}');
      entry.value.dependencies();
    }
  }

  /// Delete all registered feature bindings (on logout)
  void deleteFeatureBindings() {
    print('[FeatureRegistryService] Deleting feature bindings');
    
    // Delete specific controllers for home feature
    if (_registeredFeatures.containsKey('home')) {
      print('[FeatureRegistryService] Deleting HomeController');
      try {
        Get.delete<HomeController>(force: true);
      } catch (e) {
        print('[FeatureRegistryService] Error deleting HomeController: $e');
      }
    }
    
    // Delete specific controllers and services for todos feature
    if (_registeredFeatures.containsKey('todos')) {
      print('[FeatureRegistryService] Deleting TodosController and TodosService');
      try {
        Get.delete<TodosController>(force: true);
        Get.delete<TodosService>(force: true);
      } catch (e) {
        print('[FeatureRegistryService] Error deleting todos bindings: $e');
      }
    }
  }

  /// Clear all feature registrations
  void clearFeatures() {
    print('[FeatureRegistryService] Clearing all features');
    _registeredFeatures.clear();
  }

  /// Get registered features
  List<String> getRegisteredFeatures() {
    return _registeredFeatures.keys.toList();
  }
}
