import 'dart:async';

import 'package:collection/collection.dart';
import 'package:e1547/logs/logs.dart';

typedef LogEmit = void Function(LogEntry entry);

class LogDeduplicator {
  LogDeduplicator({
    this.window = const Duration(seconds: 10),
    this.threshold = 3,
    this.errorThreshold = 10,
  });

  static const String suppressedEvent = 'Suppressed {count} repeats of {event}';

  final Duration window;
  final int threshold;
  final int errorThreshold;

  final Map<String, _Suppression> _windows = {};
  LogEmit? _emit;
  Timer? _timer;

  void attach(LogEmit emit) {
    _emit = emit;
    _timer ??= Timer.periodic(window, (_) => flush(DateTime.now()));
  }

  void add(LogEntry entry) {
    final LogEmit? emit = _emit;
    if (emit == null) return;
    if (entry.event == suppressedEvent) {
      emit(entry);
      return;
    }

    final String key = _keyOf(entry);
    final _Suppression? state = _windows[key];

    if (state != null && entry.time.difference(state.opened) < window) {
      final int limit = entry.level == LogLevel.error
          ? errorThreshold
          : threshold;
      if (state.passed < limit) {
        state.passed++;
        emit(entry);
      } else {
        state.suppressed++;
        state.first ??= entry.time;
        state.last = entry.time;
      }
      return;
    }

    if (state != null) _close(state, entry.time, emit);
    _windows[key] = _Suppression(entry: entry, opened: entry.time)..passed = 1;
    emit(entry);
  }

  void flush(DateTime now) {
    final LogEmit? emit = _emit;
    if (emit == null) return;
    _windows.removeWhere((_, state) {
      if (now.difference(state.opened) < window) return false;
      _close(state, now, emit);
      return true;
    });
  }

  void close() {
    _timer?.cancel();
    _timer = null;
    final LogEmit? emit = _emit;
    if (emit != null) {
      final DateTime now = DateTime.now();
      for (final state in _windows.values) {
        _close(state, now, emit);
      }
    }
    _windows.clear();
    _emit = null;
  }

  void _close(_Suppression state, DateTime now, LogEmit emit) {
    if (state.suppressed == 0) return;
    emit(
      LogEntry(
        time: now,
        level: state.entry.level,
        source: state.entry.source,
        event: suppressedEvent,
        attributes: {
          'event': state.entry.event,
          'count': state.suppressed,
          'first_seen': state.first!.toUtc().toIso8601String(),
          'last_seen': state.last!.toUtc().toIso8601String(),
        },
      ),
    );
  }

  String _keyOf(LogEntry entry) => [
    entry.source,
    entry.event,
    entry.level.name,
    entry.error?.type ?? '',
    const DeepCollectionEquality().hash(entry.attributes),
  ].join(' ');
}

class _Suppression {
  _Suppression({required this.entry, required this.opened});

  final LogEntry entry;
  final DateTime opened;
  int passed = 0;
  int suppressed = 0;
  DateTime? first;
  DateTime? last;
}
