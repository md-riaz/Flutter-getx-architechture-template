import 'package:get/get.dart';

/// SessionManager handles lifecycle of session-level bindings
/// Session-level bindings are created after login and disposed on logout
class SessionManager extends GetxService {
  static const String sessionTag = 'session';

  /// Clear all session-level bindings
  void clearSession() {
    print("SessionManager: Clearing all session-level dependencies.");
    // Delete all dependencies registered with session tag
    Get.deleteAll(tag: sessionTag, force: true);
  }

  /// Check if session is active by checking if session-tagged controllers exist
  bool get hasActiveSession {
    // You can check for any session-tagged dependency
    // For now, we'll check if anything is registered with the session tag
    try {
      Get.find(tag: sessionTag);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the current session tag
  String get currentSessionTag => sessionTag;
}
