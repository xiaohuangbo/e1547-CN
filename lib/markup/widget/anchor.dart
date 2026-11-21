import 'package:flutter/material.dart';

String normalizeAnchor(String name) =>
    name.trim().toLowerCase().replaceAll(' ', '_');

class DTextAnchors extends StatefulWidget {
  const DTextAnchors({super.key, required this.child});

  static DTextAnchorsState? of(BuildContext context) =>
      context.findAncestorStateOfType<DTextAnchorsState>();

  final Widget child;

  @override
  State<DTextAnchors> createState() => DTextAnchorsState();
}

class DTextAnchorsState extends State<DTextAnchors> {
  final Map<String, List<BuildContext>> _anchors = {};

  void register(String name, BuildContext context) =>
      _anchors.putIfAbsent(name, () => []).add(context);

  void unregister(String name, BuildContext context) {
    final targets = _anchors[name];
    if (targets == null) return;
    targets.remove(context);
    if (targets.isEmpty) _anchors.remove(name);
  }

  /// The name `top` leads to the start of the surrounding scrollable, because
  /// pages link there without declaring it.
  void reveal(String name) {
    if (name == 'top') {
      final position = Scrollable.maybeOf(context)?.position;
      if (position == null) return;
      position.animateTo(
        position.minScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      return;
    }

    final BuildContext? target = _anchors[name]?.firstOrNull;
    if (target == null || !target.mounted) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class DTextAnchorTarget extends StatefulWidget {
  const DTextAnchorTarget({super.key, required this.name});

  final String name;

  @override
  State<DTextAnchorTarget> createState() => _DTextAnchorTargetState();
}

class _DTextAnchorTargetState extends State<DTextAnchorTarget> {
  DTextAnchorsState? anchors;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DTextAnchorsState? found = DTextAnchors.of(context);
    if (found == anchors) return;
    anchors?.unregister(widget.name, context);
    anchors = found;
    anchors?.register(widget.name, context);
  }

  @override
  void dispose() {
    anchors?.unregister(widget.name, context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
