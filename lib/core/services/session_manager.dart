import 'package:get/get.dart';

/// SessionManager handles lifecycle of session-level bindings
/// Session-level bindings are created after login and disposed on logout
class SessionManager extends GetxService {
  final List<String> _sessionTags = [];
  static const String sessionTag = 'session';

  /// Initialize session-level bindings
  void initializeSession() {
    _sessionTags.add(sessionTag);
  }

  /// Clear all session-level bindings
  void clearSession() {
    for (final tag in _sessionTags) {
      // Delete all dependencies registered with session tag
      Get.deleteAll(tag: tag, force: true);
    }
    _sessionTags.clear();
  }

  /// Check if session is active
  bool get hasActiveSession => _sessionTags.isNotEmpty;

  /// Get the current session tag
  String get currentSessionTag => sessionTag;
}
