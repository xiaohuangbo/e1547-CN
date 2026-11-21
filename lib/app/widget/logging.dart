import 'package:e1547/app/app.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/widgets.dart';

class LogLevelScope extends StatelessWidget {
  const LogLevelScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: context.watch<Settings>().verboseLogs,
    builder: (context, verbose, child) {
      setLogLevel(verboseLogLevel(verbose: verbose));
      return child!;
    },
    child: child,
  );
}
