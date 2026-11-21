import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:e1547/logs/logs.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;
import 'package:rxdart/rxdart.dart';

abstract class LogPrinter {
  const LogPrinter();

  void onLog(LogEntry entry);

  FutureOr<void> close() {}
}

class Logs {
  Logs({
    this.printers = const [],
    this.redactor = const LogRedactor(),
    this.compactor = const LogStackCompactor(),
    LogDeduplicator? deduplicator,
  }) : deduplicator = deduplicator ?? LogDeduplicator() {
    this.deduplicator.attach(_publish);
  }

  static const int maxEntries = 500;

  final List<LogPrinter> printers;
  final LogRedactor redactor;
  final LogStackCompactor compactor;
  final LogDeduplicator deduplicator;

  final List<LogEntry> _entries = [];
  final StreamController<LogEntry> _added = StreamController.broadcast();
  StreamSubscription<logging.LogRecord>? _subscription;
  int _sequence = 0;

  List<LogEntry> get entries => UnmodifiableListView(_entries);

  Stream<LogEntry> get added => _added.stream;

  void connect() {
    _subscription = logging.Logger.root.onRecord.listen(
      (record) => deduplicator.add(
        compactor.apply(redactor.apply(LogEntry.fromRecord(record))),
      ),
    );
  }

  void _publish(LogEntry entry) {
    final LogEntry stored = entry.copyWith(id: _sequence++);
    _entries.add(stored);
    if (_entries.length > maxEntries) {
      _entries.removeRange(0, _entries.length - maxEntries);
    }
    _added.add(stored);
    for (final LogPrinter printer in printers) {
      printer.onLog(stored);
    }
  }

  Future<void> close() async {
    await _subscription?.cancel();
    deduplicator.close();
    await _added.close();
    for (final LogPrinter printer in printers) {
      await printer.close();
    }
  }
}

class JsonLogPrinter extends LogPrinter {
  JsonLogPrinter(this.file, {this.flushInterval = const Duration(seconds: 5)}) {
    _writing = _write();
  }

  final File file;
  final Duration flushInterval;

  final StreamController<LogEntry> _stream = StreamController();
  late final Future<void> _writing;

  Future<void> _write() async {
    final IOSink sink = file.openWrite(mode: FileMode.append);
    await for (final List<LogEntry> batch
        in _stream.stream
            .bufferTime(flushInterval)
            .where((e) => e.isNotEmpty)) {
      try {
        for (final LogEntry entry in batch) {
          sink.writeln(jsonEncode(entry.toJson()));
        }
        await sink.flush();
      } on Object {
        continue;
      }
    }
    try {
      await sink.flush();
      await sink.close();
    } on Object {
      return;
    }
  }

  @override
  void onLog(LogEntry entry) => _stream.add(entry);

  @override
  Future<void> close() async {
    await _stream.close();
    await _writing;
  }
}

class ConsoleLogPrinter extends LogPrinter {
  const ConsoleLogPrinter();

  static String color(LogLevel level) => switch (level) {
    LogLevel.error => '\x1B[31m',
    LogLevel.warn => '\x1B[33m',
    LogLevel.info => '\x1B[34m',
    LogLevel.debug || LogLevel.trace => '\x1B[90m',
  };

  @override
  void onLog(LogEntry entry) =>
      debugPrint('${color(entry.level)}${formatLogEntry(entry)}\x1B[0m');
}
