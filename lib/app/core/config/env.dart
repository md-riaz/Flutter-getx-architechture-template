/// Application environment configuration
class AppEnv {
  /// Use local JSON storage instead of remote API
  final bool localJson;

  /// Fault injection rate for testing error handling (0.0 to 1.0)
  final double faultRate;

  /// Simulated network latency in milliseconds
  final int latencyMs;

  /// Development mode flag
  final bool isDev;

  const AppEnv({
    this.localJson = true,
    this.faultRate = 0.0,
    this.latencyMs = 200,
    this.isDev = true,
  });

  /// Development environment configuration
  static const dev = AppEnv(
    localJson: true,
    faultRate: 0.1,
    latencyMs: 300,
    isDev: true,
  );

  /// Production environment configuration
  static const prod = AppEnv(
    localJson: true,
    faultRate: 0.0,
    latencyMs: 100,
    isDev: false,
  );

  /// Current environment (defaults to dev)
  static const current = dev;
}
