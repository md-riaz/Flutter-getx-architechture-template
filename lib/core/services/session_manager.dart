import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// SessionManager handles the lifecycle of session-level bindings.
/// Session-level dependencies are created after login and disposed on logout.
///
/// Register cleanup callbacks via [registerCleanup] when putting session-scoped
/// dependencies. [clearSession] runs every registered callback in order and
/// then resets the list.
///
/// Example:
/// ```dart
/// Get.put(MyController(), tag: SessionManager.sessionTag);
/// sessionManager.registerCleanup(
///   () => Get.delete<MyController>(tag: SessionManager.sessionTag, force: true),
/// );
/// ```
class SessionManager extends GetxService {
  static const String sessionTag = 'session';

  final List<VoidCallback> _cleanupCallbacks = [];

  /// Register a callback that will be invoked when [clearSession] is called.
  void registerCleanup(VoidCallback cleanup) {
    _cleanupCallbacks.add(cleanup);
  }

  /// Clear all session-level bindings by running every registered cleanup.
  void clearSession() {
    debugPrint("SessionManager: Clearing all session-level dependencies.");
    for (final cleanup in _cleanupCallbacks) {
      try {
        cleanup();
      } catch (e) {
        debugPrint("SessionManager: Error during cleanup: $e");
      }
    }
    _cleanupCallbacks.clear();
  }

  /// Returns true while there are registered session cleanup callbacks,
  /// i.e., session bindings have been set up but not yet cleared.
  bool get hasActiveSession => _cleanupCallbacks.isNotEmpty;

  /// The tag used for all session-scoped GetX dependencies.
  String get currentSessionTag => sessionTag;
}

