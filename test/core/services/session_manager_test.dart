import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_modular_template/core/services/session_manager.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('SessionManager', () {
    late SessionManager sessionManager;

    setUp(() {
      sessionManager = SessionManager();
    });

    test('currentSessionTag returns correct tag', () {
      expect(sessionManager.currentSessionTag, 'session');
    });

    test('hasActiveSession returns false when no session dependencies exist', () {
      expect(sessionManager.hasActiveSession, isFalse);
    });

    test('hasActiveSession returns true when session dependencies exist', () {
      // Register a test dependency with session tag
      Get.put('test_value', tag: sessionManager.currentSessionTag);

      expect(sessionManager.hasActiveSession, isTrue);
      
      // Clean up
      sessionManager.clearSession();
    });

    test('clearSession deletes tagged dependencies', () {
      // Register a test dependency with session tag
      Get.put('test_value', tag: sessionManager.currentSessionTag);

      expect(
        Get.isRegistered<String>(tag: sessionManager.currentSessionTag),
        isTrue,
      );

      sessionManager.clearSession();

      expect(
        Get.isRegistered<String>(tag: sessionManager.currentSessionTag),
        isFalse,
      );
    });

    test('multiple clearSession calls are safe', () {
      // Register and clear
      Get.put('test_value', tag: sessionManager.currentSessionTag);
      sessionManager.clearSession();

      // Should not throw
      expect(() => sessionManager.clearSession(), returnsNormally);
    });
  });
}
