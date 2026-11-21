import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:e1547/logs/logs.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' show Level, LogRecord;

LogLevel _logLevelOf(Level level) {
  if (level >= Level.SEVERE) return LogLevel.error;
  if (level >= Level.WARNING) return LogLevel.warn;
  if (level >= Level.INFO) return LogLevel.info;
  if (level >= Level.FINE) return LogLevel.debug;
  return LogLevel.trace;
}

@immutable
class LogError {
  const LogError({required this.type, required this.message});

  factory LogError.from(Object error) =>
      LogError(type: error.runtimeType.toString(), message: error.toString());

  factory LogError.fromJson(Map<String, Object?> json) => LogError(
    type: json['type'] as String? ?? 'Object',
    message: json['message'] as String? ?? '',
  );

  final String type;
  final String message;

  Map<String, Object?> toJson() => {'type': type, 'message': message};

  @override
  bool operator ==(Object other) =>
      other is LogError && other.type == type && other.message == message;

  @override
  int get hashCode => Object.hash(type, message);

  @override
  String toString() => '$type: $message';
}

@immutable
class LogEntry {
  const LogEntry({
    required this.time,
    required this.level,
    required this.source,
    required this.event,
    this.attributes = const {},
    this.error,
    this.stackTrace,
    this.id,
  });

  factory LogEntry.fromRecord(LogRecord record) {
    final Object? object = record.object;
    final LogEvent event = object is LogEvent
        ? object
        : LogEvent(record.message);
    return LogEntry(
      time: record.time,
      level: _logLevelOf(record.level),
      source: record.loggerName,
      event: event.name,
      attributes: event.attributes,
      error: record.error != null ? LogError.from(record.error!) : null,
      stackTrace: record.stackTrace == null
          ? null
          : FlutterError.demangleStackTrace(
              record.stackTrace!,
            ).toString().split('\n').where((e) => e.trim().isNotEmpty).toList(),
    );
  }

  factory LogEntry.fromJson(Map<String, Object?> json) => LogEntry(
    time: DateTime.parse(json['t']! as String).toLocal(),
    level: LogLevel.byName(json['lvl'] as String? ?? '') ?? LogLevel.info,
    source: json['src'] as String? ?? '',
    event: json['ev'] as String? ?? '',
    attributes:
        (json['attr'] as Map?)?.map((k, v) => MapEntry(k.toString(), v)) ??
        const {},
    error: json['err'] is Map
        ? LogError.fromJson(
            (json['err']! as Map).map((k, v) => MapEntry(k.toString(), v)),
          )
        : null,
    stackTrace: (json['st'] as List?)?.map((e) => e.toString()).toList(),
  );

  static const int version = 1;

  final DateTime time;
  final LogLevel level;
  final String source;
  final String event;
  final Map<String, Object?> attributes;
  final LogError? error;
  final List<String>? stackTrace;

  String get message => renderLogEvent(event, attributes);

  final int? id;

  LogEntry copyWith({
    Map<String, Object?>? attributes,
    List<String>? stackTrace,
    LogError? error,
    int? id,
  }) => LogEntry(
    time: time,
    level: level,
    source: source,
    event: event,
    attributes: attributes ?? this.attributes,
    error: error ?? this.error,
    stackTrace: stackTrace ?? this.stackTrace,
    id: id ?? this.id,
  );

  Map<String, Object?> toJson() => {
    'v': version,
    't': time.toUtc().toIso8601String(),
    'lvl': level.name,
    'src': source,
    'ev': event,
    if (attributes.isNotEmpty) 'attr': encodeLogValue(attributes),
    if (error != null) 'err': error!.toJson(),
    if (stackTrace != null && stackTrace!.isNotEmpty) 'st': stackTrace,
  };

  @override
  bool operator ==(Object other) =>
      other is LogEntry &&
      other.id == id &&
      other.time == time &&
      other.level == level &&
      other.source == source &&
      other.event == event &&
      other.error == error &&
      const DeepCollectionEquality().equals(other.attributes, attributes) &&
      const DeepCollectionEquality().equals(other.stackTrace, stackTrace);

  @override
  int get hashCode => Object.hash(
    id,
    time,
    level,
    source,
    event,
    error,
    const DeepCollectionEquality().hash(attributes),
    const DeepCollectionEquality().hash(stackTrace),
  );

  @override
  String toString() => '${level.name} | $time | $source: $event';
}

final RegExp _logHoles = RegExp(r'\{(\w+)\}');

String renderLogEvent(String event, Map<String, Object?> attributes) {
  if (!event.contains('{')) return event;
  return event.replaceAllMapped(_logHoles, (match) {
    final String name = match.group(1)!;
    if (!attributes.containsKey(name)) return match.group(0)!;
    return '${encodeLogValue(attributes[name])}';
  });
}

LogEntry? parseLogLine(String line, int id) {
  if (line.trim().isEmpty) return null;
  try {
    final Object? json = jsonDecode(line);
    if (json is! Map) return null;
    return LogEntry.fromJson(
      json.map((k, v) => MapEntry(k.toString(), v)),
    ).copyWith(id: id);
  } on Object {
    return null;
  }
}

Object? encodeLogValue(Object? value) => switch (value) {
  null || bool() || String() => value,
  double() when !value.isFinite => value.toString(),
  num() => value,
  List() => value.map(encodeLogValue).toList(),
  Map() => value.map((k, v) => MapEntry(k.toString(), encodeLogValue(v))),
  _ => value.toString(),
};
