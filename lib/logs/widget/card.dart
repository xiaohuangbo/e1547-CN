import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

const TextStyle logTextStyle = TextStyle(
  fontFamily: 'JetBrains Mono',
  fontSize: 12,
  height: 1.35,
);

class LogEntryTile extends StatelessWidget {
  const LogEntryTile({super.key, required this.item});

  final LogEntry item;

  bool get detailed =>
      item.attributes.isNotEmpty ||
      item.error != null ||
      (item.stackTrace?.isNotEmpty ?? false);

  static const double stackWidth = 600;

  static double rowPadding(BuildContext context) =>
      Theme.of(context).isDesktop ? 4 : 16;

  @override
  Widget build(BuildContext context) {
    final Color dim = dimTextColor(context);
    return ExpandableNotifier(
      controller: Expandables.of(context, ValueKey(item.id ?? item)),
      child: Builder(
        builder: (context) {
          final ExpandableController controller = ExpandableController.of(
            context,
            required: true,
          )!;
          final double width =
              LimitedWidthLayout.maybeOf(context)?.contentWidth ??
              MediaQuery.sizeOf(context).width;
          final bool stacked = controller.expanded && width < stackWidth;
          final Widget message = Text(
            item.message,
            style: logTextStyle,
            maxLines: controller.expanded ? null : 1,
            overflow: controller.expanded
                ? TextOverflow.clip
                : TextOverflow.ellipsis,
          );
          return InkWell(
            onTap: detailed ? controller.toggle : null,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: item.level.color, width: 3),
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: rowPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: controller.expanded
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        logTimeFormat.format(item.time),
                        style: logTextStyle.copyWith(color: dim),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.source,
                        style: logTextStyle.copyWith(color: item.level.color),
                      ),
                      const SizedBox(width: 8),
                      if (stacked) const Spacer() else Expanded(child: message),
                      SizedBox(
                        width: 16,
                        child: detailed
                            ? Icon(
                                controller.expanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 14,
                                color: dim,
                              )
                            : null,
                      ),
                    ],
                  ),
                  if (stacked)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: message,
                    ),
                  if (detailed)
                    ClipRect(
                      child: AnimatedAlign(
                        alignment: Alignment.topLeft,
                        heightFactor: controller.expanded ? 1 : 0,
                        duration: defaultAnimationDuration,
                        curve: Curves.easeOut,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            top: 4,
                            bottom: 4,
                          ),
                          child: LogEntryDetails(item: item),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class LogEntryDetails extends StatelessWidget {
  const LogEntryDetails({super.key, required this.item});

  final LogEntry item;

  @override
  Widget build(BuildContext context) {
    final List<String> stackTrace = item.stackTrace ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final MapEntry<String, Object?> attribute
            in item.attributes.entries)
          LogAttribute(name: attribute.key, value: attribute.value),
        if (item.error != null)
          LogAttribute(name: item.error!.type, value: item.error!.message),
        if (stackTrace.isNotEmpty)
          LogAttribute(name: 'stack', value: stackTrace.join('\n')),
      ],
    );
  }
}

class LogAttribute extends StatelessWidget {
  const LogAttribute({super.key, required this.name, required this.value});

  final String name;
  final Object? value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$name  ',
            style: logTextStyle.copyWith(color: dimTextColor(context)),
          ),
          TextSpan(
            text: '${encodeLogValue(value)}'.ellipse(1000),
            style: logTextStyle,
          ),
        ],
      ),
    );
  }
}

class SelectionRowOverlay<T> extends StatelessWidget {
  const SelectionRowOverlay({
    super.key,
    required this.child,
    required this.item,
  });

  final Widget child;
  final T item;

  @override
  Widget build(BuildContext context) {
    final SelectionLayoutData<T>? layoutData = SelectionLayout.maybeOf<T>(
      context,
    );
    if (layoutData == null) return child;
    final bool selected = layoutData.selections.contains(item);
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        AnimatedContainer(
          duration: defaultAnimationDuration,
          color: selected ? scheme.primary.withValues(alpha: 0.16) : null,
          child: child,
        ),
        Positioned.fill(
          child: MouseCursorRegion(
            behavior: HitTestBehavior.translucent,
            onTap: layoutData.selections.isNotEmpty
                ? () => layoutData.toggleSelection(item)
                : null,
            onLongPress: () => layoutData.toggleSelection(item),
            onSecondaryTap: () => layoutData.toggleSelection(item),
            child: ExcludeFocus(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: defaultAnimationDuration,
                  opacity: selected ? 1 : 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.check_circle,
                        size: 16,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
