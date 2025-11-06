import 'package:get/get.dart';

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
    for (final entry in _registeredFeatures.entries) {
      print('[FeatureRegistryService] Deleting binding for: ${entry.key}');
      // Delete all controllers and services associated with the feature
      // Services with matching tags will have onClose() called
      Get.delete(force: true, tag: entry.key);
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
