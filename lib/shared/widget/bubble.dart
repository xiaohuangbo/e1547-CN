import 'dart:math';

import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

@immutable
class OverlayBubble {
  const OverlayBubble({
    required this.id,
    required this.size,
    required this.child,
  });

  final Object id;
  final double size;
  final Widget child;
}

class BubbleOverlay extends StatefulWidget {
  const BubbleOverlay({
    super.key,
    required this.child,
    required this.bubbles,
    this.margin = 16,
    this.side = HorizontalDirection.right,
  });

  final Widget child;
  final List<OverlayBubble> bubbles;
  final double margin;
  final HorizontalDirection side;

  @override
  State<BubbleOverlay> createState() => _BubbleOverlayState();
}

class _BubbleOverlayState extends State<BubbleOverlay>
    with TickerProviderStateMixin {
  static const int _relaxPasses = 8;
  static final SpringDescription _spring = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 220,
    ratio: 0.85,
  );

  static const double _maxFlingVelocity = 2400;

  final Map<Object, Offset> _positions = {};
  final Map<Object, AnimationController> _x = {};
  final Map<Object, AnimationController> _y = {};

  BoxConstraints _bounds = const BoxConstraints();
  EdgeInsets _insets = EdgeInsets.zero;

  final Map<Object, bool> _snapRight = {};
  final Map<Object, double> _sizes = {};

  double _sizeOf(Object id) {
    for (final OverlayBubble bubble in widget.bubbles) {
      if (bubble.id == id) return bubble.size;
    }
    return _sizes[id] ?? 0;
  }

  Offset _confine(Object id, Offset value) =>
      _clamp(value, _sizeOf(id), _bounds, _insets);

  @override
  void didUpdateWidget(covariant BubbleOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.side == widget.side) return;
    for (final Object id in _positions.keys.toList()) {
      if (_snapRight.containsKey(id)) continue;
      _stop(id);
      _positions[id] = _confine(
        id,
        Offset(
          _edge(_sizeOf(id), _bounds, right: _defaultRight),
          _positions[id]!.dy,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final AnimationController controller in [..._x.values, ..._y.values]) {
      controller.dispose();
    }
    super.dispose();
  }

  AnimationController _axis(Object id, {required bool horizontal}) {
    final Map<Object, AnimationController> map = horizontal ? _x : _y;
    return map.putIfAbsent(id, () {
      final AnimationController controller = AnimationController.unbounded(
        vsync: this,
      );
      controller.addListener(() {
        final Offset current = _positions[id] ?? Offset.zero;
        final Offset next = horizontal
            ? Offset(controller.value, current.dy)
            : Offset(current.dx, controller.value);
        setState(() => _positions[id] = _confine(id, next));
      });
      return controller;
    });
  }

  void _stop(Object id) {
    _x[id]?.stop();
    _y[id]?.stop();
  }

  Offset _capVelocity(Offset velocity) {
    final double magnitude = velocity.distance;
    if (magnitude <= _maxFlingVelocity) return velocity;
    return velocity / magnitude * _maxFlingVelocity;
  }

  void _springTo(Object id, Offset target, Offset velocity) {
    final Offset current = _positions[id] ?? target;
    _axis(id, horizontal: true).animateWith(
      SpringSimulation(_spring, current.dx, target.dx, velocity.dx),
    );
    _axis(id, horizontal: false).animateWith(
      SpringSimulation(_spring, current.dy, target.dy, velocity.dy),
    );
  }

  bool get _defaultRight => widget.side == HorizontalDirection.right;

  double _edge(
    double size,
    BoxConstraints constraints, {
    required bool right,
  }) => right ? constraints.maxWidth - size - widget.margin : widget.margin;

  Offset _rest(int index, double size, BoxConstraints constraints) => Offset(
    _edge(size, constraints, right: _defaultRight),
    (constraints.maxHeight - size) / 2 + index * (size + widget.margin),
  );

  Offset _clamp(
    Offset value,
    double size,
    BoxConstraints constraints,
    EdgeInsets padding,
  ) {
    final double maxX = max(
      widget.margin,
      constraints.maxWidth - size - widget.margin,
    );
    final double minY = padding.top + widget.margin;
    final double maxY = max(
      minY,
      constraints.maxHeight - size - padding.bottom - widget.margin,
    );
    return Offset(
      value.dx.clamp(widget.margin, maxX),
      value.dy.clamp(minY, maxY),
    );
  }

  Map<Object, Offset> _separate(
    Map<Object, Offset> input,
    Object? anchor,
    BoxConstraints constraints,
    EdgeInsets padding,
  ) {
    final Map<Object, OverlayBubble> bubbles = {
      for (final OverlayBubble bubble in widget.bubbles) bubble.id: bubble,
    };
    final Map<Object, Offset> result = Map.of(input);
    final List<Object> ids = result.keys
        .where(bubbles.containsKey)
        .toList(growable: false);

    for (int pass = 0; pass < _relaxPasses; pass++) {
      bool moved = false;
      for (int i = 0; i < ids.length; i++) {
        for (int j = i + 1; j < ids.length; j++) {
          final Object a = ids[i];
          final Object b = ids[j];
          final double sizeA = bubbles[a]!.size;
          final double sizeB = bubbles[b]!.size;
          final double reach = (sizeA + sizeB) / 2 + widget.margin / 2;

          Offset delta =
              (result[b]! + Offset(sizeB / 2, sizeB / 2)) -
              (result[a]! + Offset(sizeA / 2, sizeA / 2));
          double distance = delta.distance;
          if (distance >= reach) continue;
          if (distance < 0.01) {
            delta = const Offset(0, 1);
            distance = 1;
          }

          moved = true;
          final Offset push = (delta / distance) * (reach - distance);
          if (a == anchor) {
            result[b] = result[b]! + push;
          } else if (b == anchor) {
            result[a] = result[a]! - push;
          } else {
            result[a] = result[a]! - push / 2;
            result[b] = result[b]! + push / 2;
          }
        }
      }
      if (!moved) break;
    }

    for (final Object id in ids) {
      if (id == anchor) continue;
      result[id] = _clamp(result[id]!, bubbles[id]!.size, constraints, padding);
    }
    return result;
  }

  Offset _reanchor(Object id, BoxConstraints from, BoxConstraints to) {
    final double size = _sizeOf(id);
    final Offset current = _positions[id]!;
    final double fromSpan = from.maxHeight - size;
    final double toSpan = to.maxHeight - size;
    final double y = fromSpan > 0
        ? current.dy * (toSpan / fromSpan)
        : current.dy;
    final bool right = _snapRight[id] ?? _defaultRight;
    return _confine(id, Offset(_edge(size, to, right: right), y));
  }

  void _settle(
    OverlayBubble bubble,
    Offset velocity,
    BoxConstraints constraints,
    EdgeInsets padding,
  ) {
    final Offset current = _positions[bubble.id]!;
    final bool snapRight =
        current.dx + bubble.size / 2 > constraints.maxWidth / 2;
    _snapRight[bubble.id] = snapRight;
    final Offset target = _clamp(
      Offset(
        snapRight ? constraints.maxWidth - bubble.size - widget.margin : 0,
        current.dy,
      ),
      bubble.size,
      constraints,
      padding,
    );

    final Map<Object, Offset> resolved = _separate(
      {..._positions, bubble.id: target},
      bubble.id,
      constraints,
      padding,
    );

    _springTo(bubble.id, target, _capVelocity(velocity));
    for (final MapEntry<Object, Offset> entry in resolved.entries) {
      if (entry.key == bubble.id) continue;
      _springTo(entry.key, entry.value, Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final EdgeInsets padding = MediaQuery.paddingOf(context);
        final bool resized = _bounds != constraints || _insets != padding;
        final BoxConstraints previous = _bounds;
        _bounds = constraints;
        _insets = padding;
        for (final OverlayBubble bubble in widget.bubbles) {
          _sizes[bubble.id] = bubble.size;
        }

        if (resized && _positions.isNotEmpty && previous.maxHeight.isFinite) {
          for (final Object id in _positions.keys.toList()) {
            _stop(id);
            _positions[id] = _reanchor(id, previous, constraints);
          }
        }

        bool added = false;
        for (int i = 0; i < widget.bubbles.length; i++) {
          final OverlayBubble bubble = widget.bubbles[i];
          if (_positions.containsKey(bubble.id)) continue;
          _positions[bubble.id] = _rest(i, bubble.size, constraints);
          added = true;
        }

        if (added || resized) {
          final Map<Object, Offset> resolved = _separate(
            _positions,
            null,
            constraints,
            padding,
          );
          if (!mapEquals(resolved, _positions)) {
            for (final Object id in resolved.keys) {
              _stop(id);
            }
            _positions
              ..clear()
              ..addAll(resolved);
          }
        }

        return Stack(
          children: [
            Positioned.fill(child: widget.child),
            for (final OverlayBubble bubble in widget.bubbles)
              Positioned(
                left: _positions[bubble.id]!.dx,
                top: _positions[bubble.id]!.dy,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (_) => _stop(bubble.id),
                  onPanUpdate: (details) {
                    final Map<Object, Offset> next = Map.of(_positions);
                    next[bubble.id] = _confine(
                      bubble.id,
                      next[bubble.id]! + details.delta,
                    );
                    final Map<Object, Offset> resolved = _separate(
                      next,
                      bubble.id,
                      constraints,
                      padding,
                    );
                    for (final Object id in resolved.keys) {
                      if (id != bubble.id) _stop(id);
                    }
                    setState(() => _positions.addAll(resolved));
                  },
                  onPanEnd: (details) => _settle(
                    bubble,
                    details.velocity.pixelsPerSecond,
                    constraints,
                    padding,
                  ),
                  child: bubble.child,
                ),
              ),
          ],
        );
      },
    );
  }
}
