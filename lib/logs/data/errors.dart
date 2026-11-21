import 'dart:async';
import 'dart:collection';

import 'package:e1547/logs/logs.dart';
import 'package:flutter/foundation.dart';

class LogErrors extends ChangeNotifier {
  LogErrors(this.logs) {
    _errors.addAll(logs.entries.where(_isError));
    _subscription = logs.added.listen((entry) {
      if (!_isError(entry)) return;
      _errors.add(entry);
      if (_errors.length > maxErrors) {
        _errors.removeRange(0, _errors.length - maxErrors);
      }
      notifyListeners();
    });
  }

  static const int maxErrors = 100;

  final ValueNotifier<bool> suppressBubble = ValueNotifier<bool>(false);

  final Logs logs;
  late final StreamSubscription<LogEntry> _subscription;
  final List<LogEntry> _errors = [];

  List<LogEntry> get errors => UnmodifiableListView(_errors);
  bool get isEmpty => _errors.isEmpty;
  int get length => _errors.length;

  static bool _isError(LogEntry entry) => entry.level == LogLevel.error;

  void clear() {
    if (_errors.isEmpty) return;
    _errors.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    suppressBubble.dispose();
    super.dispose();
  }
}
