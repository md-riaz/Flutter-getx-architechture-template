import '../interfaces/logger_interface.dart';

/// Console-based implementation of ILoggerService
/// Uses dart:developer log for production, print for debug
/// Can be replaced with logger package, firebase_crashlytics, or other logging solutions
class ConsoleLoggerService implements ILoggerService {
  LogLevel _minLevel = LogLevel.debug;
  bool _enabled = true;

  @override
  void debug(String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.debug, message, data: data);
  }

  @override
  void info(String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.info, message, data: data);
  }

  @override
  void warning(String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.warning, message, data: data);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace, data: data);
  }

  @override
  void fatal(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(LogLevel.fatal, message, error: error, stackTrace: stackTrace, data: data);
  }

  @override
  void setLogLevel(LogLevel level) {
    _minLevel = level;
  }

  @override
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    if (!_enabled || level.index < _minLevel.index) {
      return;
    }

    final levelStr = _getLevelString(level);
    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer();
    
    buffer.write('[$timestamp] [$levelStr] $message');
    
    if (data != null && data.isNotEmpty) {
      buffer.write(' | Data: $data');
    }
    
    if (error != null) {
      buffer.write('\nError: $error');
    }
    
    if (stackTrace != null) {
      buffer.write('\nStackTrace:\n$stackTrace');
    }

    // Use print for simplicity (can be replaced with dart:developer log)
    print(buffer.toString());
  }

  String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.fatal:
        return 'FATAL';
    }
  }
}
