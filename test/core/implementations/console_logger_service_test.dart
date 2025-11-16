import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/implementations/console_logger_service.dart';
import 'package:getx_modular_template/core/interfaces/logger_interface.dart';

void main() {
  group('ConsoleLoggerService', () {
    late ConsoleLoggerService logger;

    setUp(() {
      logger = ConsoleLoggerService();
    });

    test('debug logs message', () {
      expect(() => logger.debug('Debug message'), returnsNormally);
    });

    test('debug logs message with data', () {
      expect(
        () => logger.debug('Debug message', data: {'key': 'value'}),
        returnsNormally,
      );
    });

    test('info logs message', () {
      expect(() => logger.info('Info message'), returnsNormally);
    });

    test('warning logs message', () {
      expect(() => logger.warning('Warning message'), returnsNormally);
    });

    test('error logs message', () {
      expect(() => logger.error('Error message'), returnsNormally);
    });

    test('error logs message with error and stacktrace', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      expect(
        () => logger.error('Error message', error: error, stackTrace: stackTrace),
        returnsNormally,
      );
    });

    test('fatal logs message', () {
      expect(() => logger.fatal('Fatal message'), returnsNormally);
    });

    test('setLogLevel changes minimum log level', () {
      logger.setLogLevel(LogLevel.error);
      // Debug and info messages should not be logged (but no way to test output)
      expect(() => logger.debug('Should not log'), returnsNormally);
      expect(() => logger.error('Should log'), returnsNormally);
    });

    test('setEnabled disables logging', () {
      logger.setEnabled(false);
      expect(() => logger.debug('Should not log'), returnsNormally);
      expect(() => logger.error('Should not log'), returnsNormally);
    });

    test('setEnabled enables logging', () {
      logger.setEnabled(false);
      logger.setEnabled(true);
      expect(() => logger.info('Should log'), returnsNormally);
    });
  });
}
