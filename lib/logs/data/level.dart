enum LogLevel {
  /// Raw payload dumps, such as http bodies.
  trace,

  /// Diagnostics. Unbounded rate, development only.
  debug,

  /// Session timeline.
  info,

  /// Abnormal but handled. The world misbehaved, not us.
  warn,

  /// Our code is wrong.
  error;

  bool isAtLeast(LogLevel other) => index >= other.index;

  static LogLevel? byName(String name) {
    for (final LogLevel level in LogLevel.values) {
      if (level.name == name) return level;
    }
    return null;
  }
}
