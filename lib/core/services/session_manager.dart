import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// SessionManager handles lifecycle of session-level bindings
/// Session-level bindings are created after login and disposed on logout
class SessionManager extends GetxService {
  static const String sessionTag = 'session';

  // Track all types registered with session tag
  final Set<Type> _sessionTypes = {};

  /// Register a type as session-scoped
  void registerSessionType<T>() {
    _sessionTypes.add(T);
  }

  /// Clear all session-level bindings
  void clearSession() {
    debugPrint("SessionManager: Clearing all session-level dependencies.");

    // Delete all tracked session types with the session tag
    for (final type in _sessionTypes) {
      try {
        Get.delete(tag: sessionTag);
      } catch (e) {
        debugPrint("SessionManager: Error deleting $type: $e");
      }
    }

    _sessionTypes.clear();
  }

  /// Check if session is active by checking if session-tagged controllers exist
  bool get hasActiveSession {
    // Check if any session-tagged dependency exists
    for (final _ in _sessionTypes) {
      try {
        Get.find(tag: sessionTag);
        return true;
      } catch (e) {
        // Continue checking other types
      }
    }
    return false;
  }

  /// Get the current session tag
  String get currentSessionTag => sessionTag;
}
