import 'package:e1547/logs/logs.dart';
import 'package:intl/intl.dart';

final DateFormat logTimeFormat = DateFormat('HH:mm:ss.SSS');

String formatLogEntry(LogEntry entry) {
  final StringBuffer buffer = StringBuffer()
    ..write(entry.level.name.toUpperCase().padRight(5))
    ..write(' | ')
    ..write(logTimeFormat.format(entry.time))
    ..write(' | ')
    ..write(entry.source)
    ..write(': ')
    ..write(entry.message);

  for (final MapEntry<String, Object?> attribute in entry.attributes.entries) {
    buffer.write('\n  ${attribute.key}: ${encodeLogValue(attribute.value)}');
  }
  if (entry.error != null) {
    buffer.write('\n  ! ${entry.error}');
  }
  for (final String frame in entry.stackTrace ?? const []) {
    buffer.write('\n    $frame');
  }

  return buffer.toString();
}
