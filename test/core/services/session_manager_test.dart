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

    test('initial state has no active session', () {
      expect(sessionManager.hasActiveSession, isFalse);
    });

    test('initializeSession creates active session', () {
      sessionManager.initializeSession();

      expect(sessionManager.hasActiveSession, isTrue);
      expect(sessionManager.currentSessionTag, 'session');
    });

    test('clearSession removes active session', () {
      sessionManager.initializeSession();
      expect(sessionManager.hasActiveSession, isTrue);

      sessionManager.clearSession();

      expect(sessionManager.hasActiveSession, isFalse);
    });

    test('clearSession deletes tagged dependencies', () {
      // Register a test dependency with session tag
      sessionManager.initializeSession();
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
      sessionManager.initializeSession();
      sessionManager.clearSession();

      // Should not throw
      expect(() => sessionManager.clearSession(), returnsNormally);
    });
  });
}
