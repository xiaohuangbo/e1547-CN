import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class LogErrorBubble extends StatelessWidget {
  const LogErrorBubble({super.key, this.onTap});

  static const double size = 56;
  static const double _innerSize = 48;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final LogErrors errors = context.watch<LogErrors>();
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.error, width: 3),
                ),
              ),
              Material(
                color: scheme.surfaceContainerHigh,
                elevation: 6,
                shape: const CircleBorder(),
                child: SizedBox(
                  width: _innerSize,
                  height: _innerSize,
                  child: Center(
                    child: Text(
                      errors.length > 99 ? '99+' : '${errors.length}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: scheme.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
