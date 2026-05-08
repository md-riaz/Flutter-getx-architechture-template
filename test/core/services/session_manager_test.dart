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

    test('hasActiveSession returns false when no cleanups are registered', () {
      expect(sessionManager.hasActiveSession, isFalse);
    });

    test('hasActiveSession returns true when a cleanup is registered', () {
      sessionManager.registerCleanup(() {});
      expect(sessionManager.hasActiveSession, isTrue);

      // Clean up
      sessionManager.clearSession();
    });

    test('clearSession runs registered cleanup callbacks', () {
      var callCount = 0;
      sessionManager.registerCleanup(() => callCount++);
      sessionManager.registerCleanup(() => callCount++);

      sessionManager.clearSession();

      expect(callCount, 2);
      expect(sessionManager.hasActiveSession, isFalse);
    });

    test('clearSession integrates with Get.delete for tagged dependencies', () {
      Get.put('test_value', tag: sessionManager.currentSessionTag);

      expect(
        Get.isRegistered<String>(tag: sessionManager.currentSessionTag),
        isTrue,
      );

      sessionManager.registerCleanup(() {
        Get.delete<String>(
          tag: sessionManager.currentSessionTag,
          force: true,
        );
      });

      sessionManager.clearSession();

      expect(
        Get.isRegistered<String>(tag: sessionManager.currentSessionTag),
        isFalse,
      );
    });

    test('multiple clearSession calls are safe', () {
      sessionManager.registerCleanup(() {});
      sessionManager.clearSession();

      // Should not throw on a second call with empty callback list
      expect(() => sessionManager.clearSession(), returnsNormally);
    });

    test('clearSession handles errors in callbacks without throwing', () {
      sessionManager.registerCleanup(() => throw Exception('boom'));
      sessionManager.registerCleanup(() {}); // should still run

      expect(() => sessionManager.clearSession(), returnsNormally);
      expect(sessionManager.hasActiveSession, isFalse);
    });
  });
}
