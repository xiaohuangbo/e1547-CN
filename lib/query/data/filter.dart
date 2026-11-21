import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

abstract class FilterController<T> extends ChangeNotifier {
  FilterController();

  final Map<Object, List<T>> _tracked = {};

  bool _notifyScheduled = false;
  bool _disposed = false;

  Object idOf(T item);

  bool filter(T item);

  List<T> track(Object key, List<T> items) {
    final previous = _tracked[key];
    _tracked[key] = items;
    if (!identical(previous, items) && !listEquals(previous, items)) {
      _scheduleNotify();
    }
    return items.where(filter).toList();
  }

  void untrack(Object key) {
    if (_tracked.remove(key) != null) {
      _scheduleNotify();
    }
  }

  Iterable<T> get tracked {
    final seen = <Object>{};
    return _tracked.values
        .expand((items) => items)
        .where((item) => seen.add(idOf(item)));
  }

  int get blockedCount => tracked.where((item) => !filter(item)).length;

  void _scheduleNotify() {
    if (_notifyScheduled || _disposed) return;
    _notifyScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _notifyScheduled = false;
      if (_disposed) return;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
