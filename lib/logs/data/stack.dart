import 'package:e1547/logs/logs.dart';
import 'package:stack_trace/stack_trace.dart';

class LogStackCompactor {
  const LogStackCompactor({
    this.limit = 15,
    this.head = 3,
    this.package = 'e1547',
  });

  final int limit;
  final int head;
  final String package;

  LogEntry apply(LogEntry entry) {
    final List<String>? frames = entry.stackTrace;
    if (frames == null || frames.isEmpty) return entry;
    return entry.copyWith(stackTrace: compact(frames));
  }

  List<String> compact(List<String> frames) {
    List<Frame> parsed;
    try {
      parsed = Trace.parse(frames.join('\n')).terse.frames;
    } on FormatException {
      return _cap(frames);
    }

    final List<String> kept = [];
    int elided = 0;

    void collapse() {
      if (elided == 0) return;
      kept.add('<$elided frames elided>');
      elided = 0;
    }

    for (int i = 0; i < parsed.length; i++) {
      final Frame frame = parsed[i];
      if (i < head || frame.package == package) {
        collapse();
        kept.add(frame.toString());
      } else {
        elided++;
      }
    }
    collapse();

    return _cap(kept);
  }

  List<String> _cap(List<String> frames) {
    if (frames.length <= limit) return frames;
    return [...frames.take(limit), '+${frames.length - limit} more'];
  }
}
