import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:e1547/logs/logs.dart';
import 'package:flutter/foundation.dart';

abstract class LogSource extends ChangeNotifier {
  final List<LogEntry> internalEntries = [];

  List<LogEntry> get entries => UnmodifiableListView(internalEntries);

  DateTime? get date => null;

  bool get live => false;

  bool get hasEarlier => false;

  bool get loading => false;

  bool get loadingEarlier => false;

  Future<void> load() async {}

  Future<void> loadEarlier() async {}
}

class LiveLogSource extends LogSource {
  LiveLogSource(this.logs) {
    internalEntries.addAll(logs.entries);
    _subscription = logs.added.listen((entry) {
      internalEntries.add(entry);
      if (internalEntries.length > Logs.maxEntries) {
        internalEntries.removeRange(
          0,
          internalEntries.length - Logs.maxEntries,
        );
      }
      notifyListeners();
    });
  }

  final Logs logs;
  late final StreamSubscription<LogEntry> _subscription;

  @override
  bool get live => true;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

typedef _Page = ({List<LogEntry> entries, int start, int end});

class LogFileSource extends LogSource {
  LogFileSource(this.file, {this.date, this.pageBytes = 256 * 1024});

  static const int maxEntries = 5000;

  final File file;

  final int pageBytes;

  @override
  final DateTime? date;

  int _start = 0;
  int _end = 0;
  bool _loading = true;
  bool _loadingEarlier = false;
  bool _reading = false;
  bool _again = false;
  bool _disposed = false;
  StreamSubscription<FileSystemEvent>? _watch;

  @override
  bool get hasEarlier => _start > 0;

  @override
  bool get loading => _loading;

  @override
  bool get loadingEarlier => _loadingEarlier;

  @override
  Future<void> load() async {
    await _loadTail();
    if (_disposed) return;
    try {
      _watch = file
          .watch(events: FileSystemEvent.modify)
          .listen((_) => _tail(), onError: (_) {});
    } on FileSystemException {
      return;
    }
  }

  @override
  Future<void> loadEarlier() async {
    if (_loadingEarlier || _disposed || !hasEarlier) return;
    _loadingEarlier = true;
    notifyListeners();
    try {
      final int to = _start;
      final int from = max(0, to - pageBytes);
      final _Page page = await _read(from, to, skipPartial: from > 0);
      if (_disposed) return;
      internalEntries.insertAll(0, page.entries);
      _start = from == 0 ? 0 : page.start;
    } on FileSystemException {
      return;
    } finally {
      _loadingEarlier = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _loadTail() async {
    try {
      final int length = await file.length();
      if (_disposed) return;
      final int from = max(0, length - pageBytes);
      final _Page page = await _read(from, length, skipPartial: from > 0);
      if (_disposed) return;
      internalEntries
        ..clear()
        ..addAll(page.entries);
      _start = from == 0 ? 0 : page.start;
      _end = page.end;
    } on FileSystemException {
      return;
    } finally {
      _loading = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _tail() async {
    if (_reading) {
      _again = true;
      return;
    }
    _reading = true;
    try {
      final int length = await file.length();
      if (_disposed) return;
      if (length < _end) {
        await _loadTail();
        return;
      }
      if (length <= _end) return;

      final _Page page = await _read(_end, length, skipPartial: false);
      if (_disposed) return;
      internalEntries.addAll(page.entries);
      _end = page.end;
      if (internalEntries.length > maxEntries) {
        internalEntries.removeRange(0, internalEntries.length - maxEntries);
        _start = internalEntries.first.id ?? _start;
      }
      notifyListeners();
    } on FileSystemException {
      return;
    } finally {
      _reading = false;
      if (_again && !_disposed) {
        _again = false;
        await _tail();
      }
    }
  }

  Future<_Page> _read(int from, int to, {required bool skipPartial}) async {
    final BytesBuilder builder = BytesBuilder(copy: false);
    await for (final List<int> chunk in file.openRead(from, to)) {
      if (_disposed) break;
      builder.add(chunk);
    }
    final Uint8List bytes = builder.takeBytes();

    int cursor = 0;
    if (skipPartial) {
      final int first = bytes.indexOf(0x0a);
      if (first < 0) return (entries: const <LogEntry>[], start: to, end: to);
      cursor = first + 1;
    }

    final int begin = cursor;
    final List<LogEntry> entries = [];
    for (int i = cursor; i < bytes.length; i++) {
      if (bytes[i] != 0x0a) continue;
      final String line = utf8.decode(
        Uint8List.sublistView(bytes, cursor, i),
        allowMalformed: true,
      );
      final LogEntry? entry = parseLogLine(line, from + cursor);
      if (entry != null) entries.add(entry);
      cursor = i + 1;
    }
    return (entries: entries, start: from + begin, end: from + cursor);
  }

  @override
  void dispose() {
    _disposed = true;
    _watch?.cancel();
    super.dispose();
  }
}
