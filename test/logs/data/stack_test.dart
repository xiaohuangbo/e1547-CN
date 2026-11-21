import 'package:e1547/logs/logs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const LogStackCompactor compactor = LogStackCompactor();

  group('LogStackCompactor', () {
    test('keeps our frames and elides framework runs', () {
      final List<String> result = compactor.compact([
        '#0      one (package:flutter/src/widgets/framework.dart:1:1)',
        '#1      two (package:flutter/src/widgets/binding.dart:2:1)',
        '#2      three (package:flutter/src/widgets/binding.dart:3:1)',
        '#3      ours (package:e1547/post/data/post.dart:4:1)',
        '#4      four (package:flutter/src/foundation/binding.dart:5:1)',
        '#5      five (package:flutter/src/foundation/binding.dart:6:1)',
        '#6      six (package:flutter/src/foundation/binding.dart:7:1)',
      ]);
      expect(result.any((e) => e.contains('e1547')), isTrue);
      expect(result.any((e) => e.contains('frames elided')), isTrue);
      expect(result.length, lessThan(7));
    });

    test('caps long traces and says how much it dropped', () {
      final List<String> result = compactor.compact([
        for (int i = 0; i < 60; i++) '#$i      f$i (package:e1547/a.dart:$i:1)',
      ]);
      expect(result.length, compactor.limit + 1);
      expect(result.last, '+45 more');
    });

    test('survives traces it cannot parse', () {
      final List<String> result = compactor.compact([
        'not a stack trace at all',
      ]);
      expect(result, isNotEmpty);
    });

    test('leaves entries without a trace untouched', () {
      final LogEntry entry = LogEntry(
        time: DateTime(2026),
        level: LogLevel.warn,
        source: 'Test',
        event: 'test.event',
      );
      expect(compactor.apply(entry).stackTrace, isNull);
    });
  });
}
