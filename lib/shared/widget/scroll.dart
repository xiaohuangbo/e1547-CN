import 'package:flutter/material.dart';

/// Fades the content of a scrollable at every edge it can still scroll towards.
///
/// The fade ramps out over the last [extent] pixels, so a bounce or a fractional
/// offset leaves no fade at all.
class ScrollEdgeFade extends StatefulWidget {
  const ScrollEdgeFade({
    super.key,
    required this.child,
    this.axis = Axis.horizontal,
    this.extent = 24,
  });

  final Widget child;
  final Axis axis;
  final double extent;

  @override
  State<ScrollEdgeFade> createState() => _ScrollEdgeFadeState();
}

class _ScrollEdgeFadeState extends State<ScrollEdgeFade> {
  double _leading = 0;
  double _trailing = 0;

  bool _onMetrics(ScrollMetrics metrics) {
    final leading = (metrics.extentBefore / widget.extent).clamp(0.0, 1.0);
    final trailing = (metrics.extentAfter / widget.extent).clamp(0.0, 1.0);
    if (leading != _leading || trailing != _trailing) {
      setState(() {
        _leading = leading;
        _trailing = trailing;
      });
    }
    return false;
  }

  Shader _shader(Rect bounds) {
    final length = widget.axis == Axis.horizontal
        ? bounds.width
        : bounds.height;
    final stop = (widget.extent / length).clamp(0.0, 0.5);
    return LinearGradient(
      begin: widget.axis == Axis.horizontal
          ? Alignment.centerLeft
          : Alignment.topCenter,
      end: widget.axis == Axis.horizontal
          ? Alignment.centerRight
          : Alignment.bottomCenter,
      colors: [
        Colors.white.withValues(alpha: 1 - _leading),
        Colors.white,
        Colors.white,
        Colors.white.withValues(alpha: 1 - _trailing),
      ],
      stops: [0, stop, 1 - stop, 1],
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: (notification) => _onMetrics(notification.metrics),
        child: NotificationListener<ScrollMetricsNotification>(
          onNotification: (notification) => _onMetrics(notification.metrics),
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            // A tear-off would compare equal across builds, and the mask would
            // keep the gradient it was first painted with.
            shaderCallback: (bounds) => _shader(bounds),
            // The mask rect rounds inward on fractional bounds, so the child
            // stops one physical pixel short of it, leaving nothing to paint
            // in a column the mask does not cover.
            child: Padding(
              padding: widget.axis == Axis.horizontal
                  ? EdgeInsets.symmetric(
                      horizontal: 1 / MediaQuery.devicePixelRatioOf(context),
                    )
                  : EdgeInsets.symmetric(
                      vertical: 1 / MediaQuery.devicePixelRatioOf(context),
                    ),
              child: widget.child,
            ),
          ),
        ),
      );
}
