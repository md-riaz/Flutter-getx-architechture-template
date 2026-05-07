/// Interface for logging operations
/// This allows swapping between different logging implementations
/// (logger, dart:developer, custom solutions, etc.) without changing usage
abstract class ILoggerService {
  /// Log a debug message
  void debug(String message, {Map<String, dynamic>? data});

  /// Log an info message
  void info(String message, {Map<String, dynamic>? data});

  /// Log a warning message
  void warning(String message, {Map<String, dynamic>? data});

  /// Log an error message
  void error(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data});

  /// Log a fatal/critical message
  void fatal(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data});

  /// Set the minimum log level
  void setLogLevel(LogLevel level);

  /// Enable/disable logging
  void setEnabled(bool enabled);
}

/// Log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}
