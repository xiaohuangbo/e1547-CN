import 'package:e1547/markup/markup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tracks reveal state for inline spoilers in a single rendered document.
/// Keys are [DTextInlineSpoiler] node instances; each parsed document yields
/// fresh instances, so a re-parse starts every spoiler hidden again.
class SpoilerController extends ChangeNotifier
    implements ValueNotifier<Map<DTextInlineSpoiler, SpoilerEntry>> {
  SpoilerController();

  Map<DTextInlineSpoiler, SpoilerEntry> _value = {};

  @override
  Map<DTextInlineSpoiler, SpoilerEntry> get value => _value;

  @override
  set value(Map<DTextInlineSpoiler, SpoilerEntry> newValue) {
    if (!mapEquals(_value, newValue)) {
      _value = newValue;
      notifyListeners();
    }
  }

  SpoilerEntry _entryFor(DTextInlineSpoiler node) =>
      _value.putIfAbsent(node, () {
        return SpoilerEntry(
          hidden: true,
          recognizer: TapGestureRecognizer()..onTap = () => toggle(node),
        );
      });

  void register(DTextInlineSpoiler node) {
    _entryFor(node);
  }

  bool hidden(DTextInlineSpoiler node) => _entryFor(node).hidden;

  GestureRecognizer recognizer(DTextInlineSpoiler node) =>
      _entryFor(node).recognizer;

  void toggle(DTextInlineSpoiler node) {
    final entry = _entryFor(node);
    _value[node] = entry.copyWith(hidden: !entry.hidden);
    notifyListeners();
  }

  @override
  void dispose() {
    for (final entry in _value.values) {
      entry.recognizer.dispose();
    }
    super.dispose();
  }
}

@immutable
class SpoilerEntry {
  const SpoilerEntry({required this.hidden, required this.recognizer});

  final bool hidden;
  final GestureRecognizer recognizer;

  SpoilerEntry copyWith({bool? hidden, GestureRecognizer? recognizer}) =>
      SpoilerEntry(
        hidden: hidden ?? this.hidden,
        recognizer: recognizer ?? this.recognizer,
      );
}

class SpoilerBlockWrap extends StatefulWidget {
  const SpoilerBlockWrap({super.key, required this.child});

  final Widget child;

  @override
  State<SpoilerBlockWrap> createState() => _SpoilerBlockWrapState();
}

class _SpoilerBlockWrapState extends State<SpoilerBlockWrap> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).textTheme.bodyMedium?.color;
    return GestureDetector(
      onTap: () => setState(() => _hidden = !_hidden),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: baseColor?.withAlpha(26),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(4),
            child: widget.child,
          ),
          if (_hidden)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: baseColor?.withAlpha(255),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SpoilerProvider extends StatefulWidget {
  const SpoilerProvider({super.key, this.child, this.builder, this.controller});

  final Widget? child;
  final TransitionBuilder? builder;
  final SpoilerController? controller;

  @override
  State<SpoilerProvider> createState() => _SpoilerProviderState();
}

class _SpoilerProviderState extends State<SpoilerProvider> {
  late SpoilerController controller = widget.controller ?? SpoilerController();

  @override
  void didUpdateWidget(covariant SpoilerProvider oldWidget) {
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) {
        controller.dispose();
      }
      controller = widget.controller ?? SpoilerController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: widget.builder,
      child: widget.child,
    );
  }
}
