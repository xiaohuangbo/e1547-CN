import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FittedContent {
  const FittedContent({required this.fit, required this.aspectRatio});

  final BoxFit fit;
  final double? aspectRatio;

  Rect? locate(Size box) {
    final double? aspect = aspectRatio;
    if (aspect == null || aspect <= 0 || box.isEmpty) return null;
    final Size input = Size(aspect, 1);
    final FittedSizes sizes = applyBoxFit(fit, input, box);
    final Size shown = input * (sizes.destination.width / sizes.source.width);
    return Alignment.center.inscribe(shown, Offset.zero & box);
  }
}

class ContentHero extends StatelessWidget {
  const ContentHero({
    super.key,
    required this.tag,
    required this.content,
    required this.child,
  });

  final Object tag;
  final FittedContent content;
  final Widget child;

  @override
  Widget build(BuildContext context) => Hero(
    tag: tag,
    flightShuttleBuilder: _shuttle,
    child: _Content(content: content, child: child),
  );

  static Widget _shuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Widget child = (toHeroContext.widget as Hero).child;
    final _Share? start = _Share.of(fromHeroContext);
    final _Share? end = _Share.of(toHeroContext);
    if (start == null || end == null) return child;
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) => LayoutBuilder(
        builder: (context, box) {
          final double progress = switch (direction) {
            HeroFlightDirection.push => animation.value,
            HeroFlightDirection.pop => 1 - animation.value,
          };
          final Rect share = Rect.lerp(start.share, end.share, progress)!;
          final double aspect = ui.lerpDouble(
            start.aspect,
            end.aspect,
            progress,
          )!;
          final Size bounds = box.biggest;
          final double area =
              share.width * bounds.width * share.height * bounds.height;
          final double height = math.sqrt(area / aspect);
          final Offset center = Offset(
            share.center.dx * bounds.width,
            share.center.dy * bounds.height,
          );
          return Stack(
            children: [
              Positioned.fromRect(
                rect: Rect.fromCenter(
                  center: center,
                  width: height * aspect,
                  height: height,
                ),
                child: child!,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Share {
  const _Share(this.share, this.aspect);

  final Rect share;
  final double aspect;

  static _Share? of(BuildContext context) {
    if (context.widget case Hero(
      child: _Content(:final FittedContent content),
    )) {
      final Size box = (context.findRenderObject()! as RenderBox).size;
      final Rect? rect = content.locate(box);
      if (rect == null || rect.isEmpty) return null;
      return _Share(
        Rect.fromLTRB(
          rect.left / box.width,
          rect.top / box.height,
          rect.right / box.width,
          rect.bottom / box.height,
        ),
        rect.width / rect.height,
      );
    }
    return null;
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.content, required this.child});

  final FittedContent content;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
