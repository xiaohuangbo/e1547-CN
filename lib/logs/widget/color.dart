import 'package:e1547/logs/logs.dart';
import 'package:flutter/material.dart';

extension LogLevelDisplay on LogLevel {
  Color get color => switch (this) {
    LogLevel.trace => Colors.blue[200]!,
    LogLevel.debug => Colors.blue[400]!,
    LogLevel.info => Colors.green[400]!,
    LogLevel.warn => Colors.orange[400]!,
    LogLevel.error => Colors.red[400]!,
  };

  IconData get icon => switch (this) {
    LogLevel.trace => Icons.data_object,
    LogLevel.debug => Icons.monitor_heart_outlined,
    LogLevel.info => Icons.info_outline,
    LogLevel.warn => Icons.warning_amber,
    LogLevel.error => Icons.report_outlined,
  };
}
