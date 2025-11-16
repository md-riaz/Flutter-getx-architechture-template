import '../service_locator/service_locator.dart';
import '../interfaces/logger_interface.dart';

/// Log Facade - Laravel-style static access to logger service
/// Usage: Log.info('Message'); Log.error('Error', error: e);
class Log {
  Log._(); // Private constructor to prevent instantiation

  static ILoggerService get _service => locator<ILoggerService>();

  /// Log a debug message
  static void debug(String message, {Map<String, dynamic>? data}) {
    _service.debug(message, data: data);
  }

  /// Log an info message
  static void info(String message, {Map<String, dynamic>? data}) {
    _service.info(message, data: data);
  }

  /// Log a warning message
  static void warning(String message, {Map<String, dynamic>? data}) {
    _service.warning(message, data: data);
  }

  /// Log an error message
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _service.error(message, error: error, stackTrace: stackTrace, data: data);
  }

  /// Log a fatal/critical message
  static void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _service.fatal(message, error: error, stackTrace: stackTrace, data: data);
  }

  /// Set the minimum log level
  static void setLevel(LogLevel level) {
    _service.setLogLevel(level);
  }

  /// Enable/disable logging
  static void setEnabled(bool enabled) {
    _service.setEnabled(enabled);
  }
}
