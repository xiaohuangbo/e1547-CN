import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/material.dart';

class TaskBubble extends StatelessWidget {
  const TaskBubble({super.key, this.onTap});

  final VoidCallback? onTap;

  static const double size = 64;
  static const double _innerSize = 56;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: Listenable.merge([controller, controller.currentProgress]),
      builder: (context, _) {
        final TaskKind kind = controller.kind;
        final bool isDone = kind == TaskKind.done;
        final double progress = isDone ? 1 : controller.progress;
        final bool indeterminate = !isDone && controller.runningTotal == 0;
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
                  SizedBox(
                    width: size,
                    height: size,
                    child: CircularProgressIndicator(
                      value: indeterminate ? null : progress,
                      strokeWidth: 3,
                      trackGap: 0,
                      backgroundColor: scheme.surfaceContainerHighest,
                    ),
                  ),
                  Material(
                    color: scheme.surfaceContainerHigh,
                    elevation: 6,
                    shape: const CircleBorder(),
                    child: SizedBox(
                      width: _innerSize,
                      height: _innerSize,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                        child: Icon(
                          _iconFor(kind),
                          key: ValueKey(kind),
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static IconData _iconFor(TaskKind kind) => switch (kind) {
    TaskKind.none || TaskKind.download => Icons.download,
    TaskKind.favorite => Icons.favorite,
    TaskKind.unfavorite => Icons.heart_broken,
    TaskKind.mixed => Icons.layers,
    TaskKind.done => Icons.check,
  };
}
