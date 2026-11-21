import 'package:e1547/logs/logs.dart';
import 'package:logging/logging.dart' as logging;

class LogEvent {
  const LogEvent(this.name, [this.attributes = const {}]);

  final String name;
  final Map<String, Object?> attributes;

  @override
  String toString() => renderLogEvent(name, attributes);
}

extension _Threshold on LogLevel {
  logging.Level get level => switch (this) {
    LogLevel.trace => logging.Level.FINEST,
    LogLevel.debug => logging.Level.FINE,
    LogLevel.info => logging.Level.INFO,
    LogLevel.warn => logging.Level.WARNING,
    LogLevel.error => logging.Level.SEVERE,
  };
}

void setLogLevel(LogLevel level) => logging.Logger.root.level = level.level;

class Logger {
  Logger(String name, [Map<String, Object?> context = const {}])
    : this._(logging.Logger(name), context);

  Logger._(this._logger, this.context);

  final logging.Logger _logger;
  final Map<String, Object?> context;

  String get name => _logger.fullName;

  Logger child(Map<String, Object?> context) =>
      Logger._(_logger, {...this.context, ...context});

  bool isLoggable(LogLevel level) => _logger.isLoggable(level.level);

  void _log(
    LogLevel level,
    String event,
    Map<String, Object?>? attributes, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (!_logger.isLoggable(level.level)) return;
    _logger.log(
      level.level,
      LogEvent(event, {...context, ...?attributes}),
      error,
      stackTrace,
    );
  }

  void trace(String event, [Map<String, Object?>? attributes]) =>
      _log(LogLevel.trace, event, attributes);

  void debug(String event, [Map<String, Object?>? attributes]) =>
      _log(LogLevel.debug, event, attributes);

  void info(String event, [Map<String, Object?>? attributes]) =>
      _log(LogLevel.info, event, attributes);

  void warn(
    String event, [
    Map<String, Object?>? attributes,
    Object? error,
    StackTrace? stackTrace,
  ]) => _log(LogLevel.warn, event, attributes, error, stackTrace);

  void error(
    String event, [
    Map<String, Object?>? attributes,
    Object? error,
    StackTrace? stackTrace,
  ]) => _log(LogLevel.error, event, attributes, error, stackTrace);
}
